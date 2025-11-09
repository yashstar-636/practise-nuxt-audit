<template>
  <div class="max-w-2xl mx-auto p-6 bg-white rounded-2xl shadow-lg space-y-6">
    <h2 class="text-2xl font-bold text-center text-purple-700">
      Generate Device Document
    </h2>

    <!-- Form Section -->
    <form @submit.prevent="pdfDownload" class="space-y-4">
      <!-- Device ID -->
      <div>
        <label class="block text-gray-700 font-medium mb-1">Device ID</label>
        <input
          v-model="deviceId"
          type="text"
          placeholder="Enter Device ID"
          class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-purple-500 focus:outline-none"
          required
        />
      </div>

      <!-- Document Type -->
      <div>
        <label class="block text-gray-700 font-medium mb-1"
          >Document Type</label
        >
        <select
          v-model="documentType"
          class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-purple-500 focus:outline-none"
        >
          <option value="">Pdf</option>
          <option value="Alpha">Word</option>
        </select>
      </div>

      <!-- Date Range -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label class="block text-gray-700 font-medium mb-1">Start Date</label>
          <input
            v-model="startDate"
            type="date"
            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-purple-500 focus:outline-none"
            required
          />
        </div>
        <div>
          <label class="block text-gray-700 font-medium mb-1">End Date</label>
          <input
            v-model="endDate"
            type="date"
            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-purple-500 focus:outline-none"
            required
          />
        </div>
      </div>

      <!-- Submit Button -->
      <button
        type="submit"
        class="w-full bg-purple-600 hover:bg-purple-700 text-white font-semibold py-2 rounded-lg transition"
      >
        Generate Document
      </button>
    </form>

    <!-- Result Section -->
    <div v-if="documentFound" class="mt-6 p-4 border rounded-lg bg-gray-50">
      <h3 class="text-lg font-semibold text-gray-800 mb-3">Document Found:</h3>
      <div class="flex justify-between items-center">
        <p class="text-gray-600 truncate">{{ documentName }}</p>
        <div class="flex gap-2">
          <button
            @click="viewDocument"
            class="bg-blue-500 hover:bg-blue-600 text-white p-2 rounded-lg"
            title="View Document"
          >
            <i class="fas fa-eye"></i>
          </button>
          <button
            @click="downloadDocument"
            class="bg-green-500 hover:bg-green-600 text-white p-2 rounded-lg"
            title="Download Document"
          >
            <i class="fas fa-download"></i>
          </button>
        </div>
      </div>
    </div>

    <!-- No Result -->
    <p
      v-else-if="documentChecked && !documentFound"
      class="text-center text-red-500"
    >
      No document found for this Device ID and date range.
    </p>
  </div>
</template>

<script setup>
import { ref } from "vue";

const deviceId = ref("");
const documentType = ref("");
const startDate = ref("");
const endDate = ref("");

const documentFound = ref(false);
const documentChecked = ref(false);
const documentName = ref("");

async function pdfDownload() {
  documentChecked.value = true;
  documentFound.value = false;

  // Example API call
  try {
    const pdfData = await $fetch("/api/pdfpreview", {
      params: {
        id: deviceId.value,
        start_date: startDate.value,
        end_date: endDate.value,
      },
    });
    console.log(pdfData);
    const data = pdfData;

    if (data) {
      documentFound.value = true;
      documentName.value = data.documentName;
    }
  } catch (err) {
    console.error(err);
  }
}

const viewDocument = () => {
  window.open(`/api/viewDocument?deviceId=${deviceId.value}`, "_blank");
};

const downloadDocument = async () => {
  const pdfData = await $fetch("/api/pdfpreview", {
    params: {
      id: deviceId.value,
      start_date: startDate.value,
      end_date: endDate.value,
    },
  });
  console.log(pdfData);
  const data = pdfData;
  // Convert to blob
  const blob = new Blob([pdfData], { type: "application/pdf" });

  // Create download link
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = `report_${deviceId.value}.pdf`; // filename
  document.body.appendChild(link);
  link.click();

  // Clean up
  URL.revokeObjectURL(url);
  link.remove();
};
</script>

<style scoped>
@import url("https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css");
</style>
