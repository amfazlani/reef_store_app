<template>
  <transition name="fade">
    <div
      v-if="visible"
      class="fixed top-20 right-4 bg-green-600 text-white px-6 py-3 rounded shadow-lg z-50"
    >
      {{ message }}
    </div>
  </transition>
</template>

<script setup>
import { ref } from 'vue';

const visible = ref(false);
const message = ref('');

function showToast(msg, duration = 3000) {
  message.value = msg;
  visible.value = true;

  setTimeout(() => {
    visible.value = false;
  }, duration);
}

// 👇 Make this available to parent via ref
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
