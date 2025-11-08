<template>
  <v-snackbar v-model="visible" :timeout="timeout" :color="color">
    {{ message }}
    <template #action>
      <v-btn text @click="visible = false">Close</v-btn>
    </template>
  </v-snackbar>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  message: String,
  color: { type: String, default: 'success' },
  timeout: { type: Number, default: 10000 }
})

const visible = ref(false)

// Expose a method to open the snackbar
defineExpose({
  show() {
    visible.value = true
  }
})
</script>
