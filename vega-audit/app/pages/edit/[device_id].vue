<template>
  <div class="p-6">
    <div class="flex justify-between items-center mb-4">
      <NuxtLink to="/devices" class="bg-purple-700 text-white px-4 py-2 rounded">Back to Device</NuxtLink>
    </div>

    <h2 class="text-2xl font-bold text-blue-700 mb-4">Edit Device</h2>

    <form @submit.prevent="updateDevice" class="grid grid-cols-3 gap-4 bg-white p-6 rounded shadow">
      <!-- Row 1 -->
      <div>
        <label class="block text-sm font-semibold mb-1">Device ID</label>
        <input type="text" disabled v-model='device.deviceId' class="border rounded px-3 py-2 w-full" placeholder="Enter Device ID" />
      </div>                                                                              

      <div>
        <label class="block text-sm font-semibold mb-1">Assign Device Name</label>
        <input type="text" v-model="device.name" class="border rounded px-3 py-2 w-full" placeholder="Enter Device Name" />
      </div>

      <div>
        <label class="block text-sm font-semibold mb-1">Device Type</label>
        <input type="text" v-model="device.type" class="border rounded px-3 py-2 w-full" placeholder="Device Type" />
      </div>

      <!-- Row 2 -->
      <div>
        <label class="block text-sm font-semibold mb-1">WiFi SSID</label>
        <input type="text" v-model="device.ssid" class="border rounded px-3 py-2 w-full" placeholder="Enter WiFi SSID" />
      </div>

      <div>
        <label class="block text-sm font-semibold mb-1">WiFi Password</label>
        <input type="password" v-model="device.password" class="border rounded px-3 py-2 w-full" placeholder="Enter WiFi Password" />
      </div>

      <!-- Spacer for layout -->
      <div></div>

      <!-- Row 3 -->
      <div>
        <label class="block text-sm font-semibold mb-1">Min Temperature (Internal)</label>
        <input type="number" v-model="device.minTempInternal" class="border rounded px-3 py-2 w-full" />
      </div>

      <div>
        <label class="block text-sm font-semibold mb-1">Max Temperature (Internal)</label>
        <input type="number" v-model="device.maxTempInternal" class="border rounded px-3 py-2 w-full" />
      </div>

      <!-- Row 4 -->
      <div>
        <label class="block text-sm font-semibold mb-1">Min Temp Warning (Internal)</label>
        <input type="number" v-model="device.minWarnInternal" class="border rounded px-3 py-2 w-full" />
      </div>

      <div>
        <label class="block text-sm font-semibold mb-1">Max Temp Warning (Internal)</label>
        <input type="number" v-model="device.maxWarnInternal" class="border rounded px-3 py-2 w-full" />
      </div>

      <!-- Row 5 -->
      <div>
        <label class="block text-sm font-semibold mb-1">Min Temperature (Probe)</label>
        <input type="number" v-model="device.minTempProbe" class="border rounded px-3 py-2 w-full" />
      </div>

      <div>
        <label class="block text-sm font-semibold mb-1">Max Temperature (Probe)</label>
        <input type="number" v-model="device.maxTempProbe" class="border rounded px-3 py-2 w-full" />
      </div>

      <!-- Row 6 -->
      <div>
        <label class="block text-sm font-semibold mb-1">Min Temp Warning (Probe)</label>
        <input type="number" v-model="device.minWarnProbe" class="border rounded px-3 py-2 w-full" />
      </div>

      <div>
        <label class="block text-sm font-semibold mb-1">Max Temp Warning (Probe)</label>
        <input type="number" v-model="device.maxWarnProbe" class="border rounded px-3 py-2 w-full" />
      </div>

      <!-- Row 7 -->
      <div>
        <label class="block text-sm font-semibold mb-1">Logging Interval</label>
        <input type="text" v-model="device.loggingInterval" class="border rounded px-3 py-2 w-full" placeholder="e.g., 1 min" />
      </div>

      <div>
        <label class="block text-sm font-semibold mb-1">Sending Interval</label>
        <input type="text" v-model="device.sendingInterval" class="border rounded px-3 py-2 w-full" placeholder="e.g., 1 min" />
      </div>

      <!-- Buttons -->
      <div class="col-span-3 flex justify-end gap-3 mt-4">
        <button type="button" @click="updateDevice" class="bg-purple-700 hover:bg-purple-800 text-white px-4 py-2 rounded">
          Update Device Config
        </button>
        <button @click="clearAll" type="reset" class="bg-gray-200 text-gray-700 px-4 py-2 rounded">
          Clear All
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { reactive,onMounted } from 'vue'
import { useRouter,useRoute } from 'vue-router'
const router=useRouter()
const route = useRoute()
const device_id = route.params.device_id
function clearAll(){
  device.name="",
  device.type="",
  device.ssid="",
  device.password="",
  device.minTempInternal="",
  device.maxTempInternal="",
  device.minWarnInternal="",
  device.maxWarnInternal="",
  device.minTempProbe="",
  device.maxTempProbe="",
  device.minWarnProbe="",
  device.maxWarnProbe="",
  device.loggingInterval="",
  device.sendingInterval=""
}

const device = reactive({
  deviceId: '',
  name: '',
  type: '',
  minTempInternal: '',
  maxTempInternal: '',
  minWarnInternal: '',
  maxWarnInternal: '',
  minTempProbe: '',
  maxTempProbe: '',
  minWarnProbe: '',
  maxWarnProbe: '',
  loggingInterval: '',
  sendingInterval: '',
  user_id:"rathodyash636@gmail.com"
})
const error=ref('')
function updateDevice(){
  if(
    device.deviceId===""||
  device.name===""||
  device.type===""||
  device.minTempInternal===""||
  device.maxTempInternal===""||
  device.minWarnInternal===""||
  device.maxWarnInternal===""||
  device.minTempProbe===""||
  device.maxTempProbe===""||
  device.minWarnProbe===""||
  device.maxWarnProbe===""||
  device.loggingInterval===""||
  device.sendingInterval===""){
    error="Please fill the fields!!"
  }
  else{
    addUser()
router.push('/devices')
  }
}

async function addUser() {
  const result=await $fetch('/api/devices_update', {
    method: 'put',
    body: { data:device},
  })
  console.log(result)
}

onMounted(async () => {
  try {
  const result=await $fetch('/api/onedevice',{
    params:{id:device_id}
  })
   const data=result.result[0]
   if(data){
  device.deviceId=data.device_id,
  device.name=data.device_name,
  device.type=data.device_type,
  device.minTempInternal=data.min_temp,
  device.maxTempInternal=data.max_temp,
  device.minWarnInternal=data.min_temp_warning,
  device.maxWarnInternal=data.max_temp_warning,
  device.minTempProbe=data.min_temp_probe,
  device.maxTempProbe=data.max_temp_probe,
  device.minWarnProbe=data.min_temp_warn_prob,
  device.maxWarnProbe=data.max_temp_warn_prob,
  device.loggingInterval=data.logging_interval,
  device.sendingInterval=data.sending_interval
   }
                            
  } catch (err) {
    console.error('Error fetching audit logs:', err)
  }
})

</script>
                                                                                        