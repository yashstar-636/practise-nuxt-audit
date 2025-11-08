<template>
  <div>
    <div>
      <video ref="localVideo" autoplay playsinline muted></video>
      <div v-for="(v, id) in remoteStreams" :key="id">
        <p>{{ id }}</p>
        <video :ref="el => setRemoteRef(el, id)" autoplay playsinline></video>
      </div>
    </div>
    <div>
      <input v-model="roomId" placeholder="room id"/>
      <button @click="joinRoom">Join</button>
      <button @click="leaveRoom">Leave</button>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onBeforeUnmount } from 'vue';
const localVideo = ref(null);
const remoteRefs = reactive({}); // map id -> element
const remoteStreams = reactive({}); // id -> MediaStream
const pcs = reactive({}); // id -> RTCPeerConnection
const roomId = ref('');
const localStream = ref(null);

const nuxtApp = useNuxtApp();
const socket = nuxtApp.$socket; // provided by plugin

// STUN/TURN
const ICE_CONFIG = {
  iceServers: [
    { urls: "stun:stun.l.google.com:19302" },
    // Add TURN server here for production
  ]
};

function setRemoteRef(el, id) {
  if (!el) return;
  remoteRefs[id] = el;
  if (remoteStreams[id]) {
    el.srcObject = remoteStreams[id];
  }
}

async function startLocal() {
  localStream.value = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
  localVideo.value.srcObject = localStream.value;
}

function createPeerConnection(peerId, isInitiator) {
  if (pcs[peerId]) return pcs[peerId];

  const pc = new RTCPeerConnection(ICE_CONFIG);

  // add local tracks
  localStream.value.getTracks().forEach(track => pc.addTrack(track, localStream.value));

  // ontrack -> attach remote stream
  const remoteStream = new MediaStream();
  remoteStreams[peerId] = remoteStream;

  pc.ontrack = (evt) => {
    evt.streams[0].getTracks().forEach(t => remoteStream.addTrack(t));
    // attach to element if exists
    if (remoteRefs[peerId]) remoteRefs[peerId].srcObject = remoteStream;
  };

  pc.onicecandidate = (evt) => {
    if (evt.candidate) {
      socket.emit('signal', { to: peerId, data: { type: 'ice', candidate: evt.candidate } });
    }
  };

  pcs[peerId] = pc;
  return pc;
}

async function handleOffer(from, sdp) {
  const pc = createPeerConnection(from, false);
  await pc.setRemoteDescription(new RTCSessionDescription(sdp));
  const answer = await pc.createAnswer();
  await pc.setLocalDescription(answer);
  socket.emit('signal', { to: from, data: { type: 'sdp', sdp: pc.localDescription } });
}

async function handleAnswer(from, sdp) {
  const pc = pcs[from];
  if (!pc) return console.warn('No pc for', from);
  await pc.setRemoteDescription(new RTCSessionDescription(sdp));
}

async function handleIce(from, candidate) {
  const pc = pcs[from];
  if (!pc) return;
  try {
    await pc.addIceCandidate(new RTCIceCandidate(candidate));
  } catch (e) {
    console.warn('Error adding ICE', e);
  }
}

socket.on('connect', () => console.log('socket connected', socket.id));
socket.on('participants', async (others) => {
  // when joining, we get list of others; create offers to each
  for (const id of others) {
    const pc = createPeerConnection(id, true);
    const offer = await pc.createOffer();
    await pc.setLocalDescription(offer);
    socket.emit('signal', { to: id, data: { type: 'sdp', sdp: pc.localDescription } });
  }
});
socket.on('new-peer', (id) => {
  // someone joined after us — optionally create offer
  (async () => {
    const pc = createPeerConnection(id, true);
    const offer = await pc.createOffer();
    await pc.setLocalDescription(offer);
    socket.emit('signal', { to: id, data: { type: 'sdp', sdp: pc.localDescription } });
  })();
});
socket.on('signal', async ({ from, data }) => {
  if (data.type === 'sdp') {
    const sdp = data.sdp;
    if (sdp.type === 'offer') {
      await handleOffer(from, sdp);
    } else if (sdp.type === 'answer') {
      await handleAnswer(from, sdp);
    }
  } else if (data.type === 'ice') {
    await handleIce(from, data.candidate);
  }
});
socket.on('peer-left', (id) => {
  // cleanup
  if (pcs[id]) {
    pcs[id].close();
    delete pcs[id];
  }
  if (remoteStreams[id]) delete remoteStreams[id];
  if (remoteRefs[id]) {
    remoteRefs[id].srcObject = null;
    delete remoteRefs[id];
  }
});


async function joinRoom() {
  const socket = nuxtApp.$socket;
  if (!socket?.connected) {
    alert('Socket not connected yet!');
    return;
  }
  if (!roomId.value) return alert('Enter room ID first');
  if (!localStream.value) await startLocal();
  socket.emit('join', roomId.value);
  console.log('Joined room:', roomId.value);
}


function leaveRoom() {
  if (roomId.value) {
    socket.emit('leave', roomId.value);
    for (const id in pcs) {
      pcs[id].close();
    }
    Object.keys(pcs).forEach(k => delete pcs[k]);
    Object.keys(remoteStreams).forEach(k => delete remoteStreams[k]);
    roomId.value = '';
  }
}

onMounted(async () => {
  await startLocal();

  const socket = nuxtApp.$socket;
  if (!socket) {
    console.error('Socket not available');
    return;
  }

  socket.on('connect', () => console.log('socket connected', socket.id));

  socket.on('participants', async (others) => {
    for (const id of others) {
      const pc = createPeerConnection(id, true);
      const offer = await pc.createOffer();
      await pc.setLocalDescription(offer);
      socket.emit('signal', { to: id, data: { type: 'sdp', sdp: pc.localDescription } });
    }
  });

  socket.on('new-peer', async (id) => {
    const pc = createPeerConnection(id, true);
    const offer = await pc.createOffer();
    await pc.setLocalDescription(offer);
    socket.emit('signal', { to: id, data: { type: 'sdp', sdp: pc.localDescription } });
  });

  socket.on('signal', async ({ from, data }) => {
    if (data.type === 'sdp') {
      if (data.sdp.type === 'offer') await handleOffer(from, data.sdp);
      else if (data.sdp.type === 'answer') await handleAnswer(from, data.sdp);
    } else if (data.type === 'ice') {
      await handleIce(from, data.candidate);
    }
  });

  socket.on('peer-left', (id) => {
    if (pcs[id]) pcs[id].close();
    delete pcs[id];
    delete remoteStreams[id];
    if (remoteRefs[id]) {
      remoteRefs[id].srcObject = null;
      delete remoteRefs[id];
    }
  });
});


onBeforeUnmount(() => {
  leaveRoom();
  if (localStream.value) {
    localStream.value.getTracks().forEach(t => t.stop());
  }
});
</script>

<style scoped>
video { width: 240px; height: 160px; background: #000; margin: 6px; }
</style>
