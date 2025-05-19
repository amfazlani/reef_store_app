<template>
  <Navbar />
  <Toast ref="toastRef" /> <!-- Mounted once here -->

  <div class="pt-20">
    <router-view />
  </div>
</template>

<script setup>
import { provide, ref } from 'vue';
import Navbar from './components/Navbar.vue';
import Toast from './components/Toast.vue';

const toastRef = ref(null);

function showToast(message, duration = 3000) {
  toastRef.value?.showToast(message, duration);
}

// 🌍 Make this globally available
provide('showToast', showToast);
</script>
