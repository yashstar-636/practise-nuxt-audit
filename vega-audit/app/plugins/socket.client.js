import { io } from 'socket.io-client';

export default defineNuxtPlugin(() => {
  const socket = io('http://localhost:8080', {
    transports: ['websocket'],
  });

  socket.on('connect', () => {
    console.log('✅ Connected to WebSocket server:', socket.id);
  });

  socket.on('connect_error', (err) => {
    console.error('❌ Connection error:', err.message);
  });

  return {
    provide: {
      socket,
    },
  };
});
