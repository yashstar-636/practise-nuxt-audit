<script setup>
import { ref, onMounted } from "vue";

const auditLogs = ref([]);
const rowsPerPage = ref(10);
const currentPage = ref(1);
const searchQuery = ref("");

// Fetch audit data from API
onMounted(async () => {
  try {
    const result = await $fetch("/api/devices");
    auditLogs.value = result.result || [];
  } catch (err) {
    console.error("Error fetching audit logs:", err);
  }
});

async function pdfDownload(ids) {
  try {
    const pdfData = await $fetch(`/api/pdfpreview`, {
      params: { id: ids },
      responseType: "arrayBuffer", // important: get raw bytes
    });

    // Convert to blob
    const blob = new Blob([pdfData], { type: "application/pdf" });

    // Create download link
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = `report_${ids}.pdf`; // filename
    document.body.appendChild(link);
    link.click();

    // Clean up
    URL.revokeObjectURL(url);
    link.remove();
  } catch (err) {
    console.error("Error downloading PDF:", err);
  }
}

// Computed paginated data
const filteredLogs = computed(() => {
  const filtered = auditLogs.value.filter((log) =>
    Object.values(log).some((val) =>
      String(val).toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  );
  const start = (currentPage.value - 1) * rowsPerPage.value;
  return filtered.slice(start, start + rowsPerPage.value);
});

const totalPages = computed(() =>
  Math.ceil(auditLogs.value.length / rowsPerPage.value)
);

function nextPage() {
  if (currentPage.value < totalPages.value) currentPage.value++;
}
function prevPage() {
  if (currentPage.value > 1) currentPage.value--;
}
</script>

<template>
  <div class="p-6 bg-gray-50 min-h-screen">
    <!-- Header row -->
    <div class="flex flex-wrap justify-between items-center mb-4 gap-2">
      <div class="flex items-center gap-3">
        <label class="text-sm font-medium text-gray-700">Rows per page:</label>
        <select
          v-model="rowsPerPage"
          class="border rounded-md px-2 py-1 text-sm focus:outline-none"
        >
          <option value="5">5</option>
          <option value="10">10</option>
          <option value="20">20</option>
        </select>
        <select
          class="border rounded-md px-2 py-1 text-sm focus:outline-none text-gray-700"
        >
          <option>All Fields</option>
        </select>
        <input
          v-model="searchQuery"
          type="text"
          placeholder="Search all fields..."
          class="border rounded-md px-3 py-1 w-64 text-sm focus:outline-none"
        />
      </div>

      <NuxtLink
        to="/auditReport"
        class="bg-purple-700 text-white px-4 py-2 rounded hover:bg-purple-800 transition"
      >
        + Report
      </NuxtLink>
    </div>

    <!-- Table -->
    <div class="overflow-x-auto bg-white shadow-md rounded-lg">
      <table class="min-w-full border border-gray-200 text-sm">
        <thead class="bg-purple-700 text-white">
          <tr>
            <th class="px-4 py-2 border">Sr no.</th>
            <th class="px-4 py-2 border">Device ID</th>
            <th class="px-4 py-2 border">Device Name</th>
            <th class="px-4 py-2 border">Type</th>
            <th class="px-4 py-2 border">Download</th>
          </tr>
        </thead>

        <tbody>
          <tr
            v-for="(log, index) in filteredLogs"
            :key="log.audit_id || index"
            class="hover:bg-gray-100 text-center"
          >
            <td class="border px-4 py-2">{{ index + 1 }}</td>
            <td class="border px-4 py-2">{{ log.device_id }}</td>
            <td class="border px-4 py-2">{{ log.device_name }}</td>
            <td class="border px-4 py-2">{{ log.device_type }}</td>
            <td class="border px-4 py-2">
              <button
                @click="pdfDownload(log.device_id)"
                class="bg-green-800 px-2 border border-black text-white text-lg rounded"
              >
                Pdf
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Empty state -->
      <div
        v-if="filteredLogs.length === 0"
        class="p-4 text-center text-gray-500"
      >
        No records found.
      </div>
    </div>

    <!-- Pagination -->
    <div
      class="flex items-center justify-between text-sm text-gray-600 mt-4 flex-wrap"
    >
      <p>Showing {{ filteredLogs.length }} of {{ auditLogs.length }} files</p>

      <div class="flex items-center gap-2">
        <button
          @click="prevPage"
          :disabled="currentPage === 1"
          class="px-3 py-1 border rounded disabled:opacity-40 hover:bg-gray-100"
        >
          &lt;&lt;
        </button>

        <span>Page {{ currentPage }} of {{ totalPages }}</span>

        <button
          @click="nextPage"
          :disabled="currentPage === totalPages"
          class="px-3 py-1 border rounded disabled:opacity-40 hover:bg-gray-100"
        >
          &gt;&gt;
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
table th,
table td {
  white-space: nowrap;
}
</style>
