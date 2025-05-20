<template>
  <transition name="fade">
    <div
      v-if="visible"
      :class="[
        'fixed top-20 right-4 text-white px-6 py-3 rounded shadow-lg z-50',
        type === 'error' ? 'bg-red-600' : 'bg-green-600'
      ]"
    >
      {{ message }}
    </div>
  </transition>
</template>

<script setup>
import { ref } from 'vue';

const visible = ref(false);
const message = ref('');
const type = ref('success'); // default to success

function showToast(msg, toastType = 'success', duration = 3000) {
  message.value = msg;
  type.value = toastType;
  visible.value = true;

  setTimeout(() => {
    visible.value = false;
  }, duration);
}

// Expose the function for global use
defineExpose({ showToast });
</script>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.4s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
