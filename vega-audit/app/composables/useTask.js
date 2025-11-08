
import { ref, computed } from "vue";

export function useTasks() {
  const message = ref("");
  const newTask = ref([]);
  const error = ref("");
  const filterType = ref("All");
  const selectedTasks = ref([]);

  function submitTask() {
    if (message.value.trim() !== "") {
      newTask.value.push({
        id: crypto.randomUUID(),
        task: message.value,
        completed: false,
      });
      message.value = "";
      error.value = "";
    } else {
      error.value = "Please fill the required field";
    }
  }

  function toggleCompleted(id) {
    const task = newTask.value.find((t) => t.id === id);
    if (task) task.completed = !task.completed;
  }

  function removeTask(id) {
    newTask.value = newTask.value.filter((task) => task.id !== id);
  }

  function deleteSelected() {
    newTask.value = newTask.value.filter(
      (task) => !selectedTasks.value.includes(task.id)
    );
    selectedTasks.value = [];
  }

  const filteredTasks = computed(() => {
    if (filterType.value === "Completed") {
      return newTask.value.filter((task) => task.completed);
    } else if (filterType.value === "Todo") {
      return newTask.value.filter((task) => !task.completed);
    }
    return newTask.value;
  });

  return {
    message,
    newTask,
    error,
    filterType,
    selectedTasks,
    filteredTasks,
    submitTask,
    toggleCompleted,
    removeTask,
    deleteSelected,
  };
}
