<template>
  <div>
    <div class="flex gap-3 mt-4">
      <button @click="filterType = 'All'">All</button>
      <button @click="filterType = 'Todo'">Todo</button>
      <button @click="filterType = 'Completed'">Completed</button>
      <button
        @click="deleteSelected"
        :disabled="!selectedTasks.length"
        class="bg-red-500 text-white px-2 rounded"
      >
        Delete Selected
      </button>
    </div>

    <TransitionGroup name="fade" tag="div">
      <TaskItem
        v-for="task in filteredTasks"
        :key="task.id"
        :task="task"
      />
    </TransitionGroup>
  </div>
</template>

<script setup>
import TaskItem from "./TaskItem.vue";
import { useTasks } from "../composables/useTasks.js";
const { filteredTasks, filterType, selectedTasks, deleteSelected } = useTasks();
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: all 0.3s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
