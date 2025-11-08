<template>
  <div class="p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-2xl font-bold text-blue-700">Devices list</h2>
      <NuxtLink to="/addDevice" class="bg-purple-700 text-white px-4 py-2 rounded">Add a new Device  </NuxtLink>
    </div>

    <!-- Audit Table -->
    <div class="overflow-x-auto bg-white shadow rounded">
      <table class="min-w-full border border-gray-200">
        <thead class="bg-purple-700 text-white">
          <tr>
            <th class="px-4  py-2 border">Sr No.</th>
            <th class="px-4 py-2 border">Device ID</th>
            <th class="px-4 py-2 border">Device Name</th>
            <th class="px-4 py-2 border">Type</th>
            <th class="px-4 py-2 border">Min Temp</th>
            <th class="px-4 py-2 border">Max Temp</th>
            <th class="px-4 py-2 border">Created At</th>
            <th class="px-4 py-2 border">Edit</th>

          </tr>
        </thead>

        <tbody>
          <tr v-for="log in auditLogs" :key="log.audit_id" class="hover:bg-gray-100">
            <td class="px-4 py-2 border text-center">{{ log.sr_no }}</td>
            <td class="px-4 py-2 border text-center">{{ log.device_id }}</td>
            <td class="px-4 py-2 border text-center text-green-600">{{ log.device_name }}</td>
            <td class="px-4 py-2 border text-center text-green-600">{{ log.device_type }}</td>
            <td class="px-4 py-2 border text-center text-green-600">{{ log.min_temp }}</td>
            <td class="px-4 py-2 border text-center text-green-600">{{ log.max_temp }}</td>
            <td class="px-4 py-2 border text-center">{{ new Date(log.updated_at).toLocaleString() }}</td>
            <td class="px-4 py-2 border text-center"><NuxtLink :to='`/edit/${log.device_id}`' class="bg-green-800  px-2 border border-black text-white text-lg rounded">Edit</NuxtLink></td>

          </tr>
        </tbody>
      </table>

      <!-- No data message -->
      <div v-if="auditLogs.length === 0" class="p-4 text-center text-gray-500">
        No audit records found.
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

// Holds fetched audit data
const auditLogs = ref([])

onMounted(async () => {
  try {
  const result=await $fetch('/api/devices')
    auditLogs.value=result.result 
                            
    console.log(result.result[0])


   
  } catch (err) {
    console.error('Error fetching audit logs:', err)
  }
})
</script>
