<template>
  <div class="max-w-7xl mx-auto px-4 py-6">
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-2xl font-bold">Stores</h1>
      <router-link
        to="/stores/new"
        class="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 text-sm font-medium rounded shadow"
      >
        <span class="text-lg">＋</span>
        <span>New Store</span>
      </router-link>
    </div>

    <div class="mb-4 flex items-center gap-4">
      <input
        v-model="searchQuery"
        @input="handleSearch"
        type="text"
        placeholder="Search stores..."
        class="w-full max-w-sm px-4 py-2 border border-gray-300 rounded focus:outline-none focus:ring focus:ring-blue-300"
      />
    </div>

    <div v-if="loading" class="text-center text-gray-500 py-8">Loading stores...</div>

    <div v-if="!loading && stores.length" class="bg-white shadow rounded-lg p-6 space-y-4">
      <div
        v-for="store in stores"
        :key="store.id"
        class="flex items-start sm:items-center justify-between gap-4 border-b pb-4 last:border-b-0"
      >
        <!-- Logo -->
        <div class="w-16 h-16 flex-shrink-0 bg-gray-200 rounded-full flex items-center justify-center text-gray-500 font-bold text-xl">
          {{ store.name[0] }}
        </div>

        <!-- Info or Edit Form -->
        <div class="flex-1">
          <template v-if="editingStoreId === store.id">
            <input
              v-model="editedStore.name"
              class="w-full text-lg font-semibold text-blue-600 border-b border-gray-300 focus:outline-none mb-1"
            />
            <input
              v-model="editedStore.address"
              class="w-full text-sm text-gray-500 border-b border-gray-200 focus:outline-none mb-1"
            />
            <textarea
              v-model="editedStore.description"
              class="w-full text-sm text-gray-600 border border-gray-200 rounded px-2 py-1 resize-none"
              rows="2"
            />
          </template>

          <template v-else>
            <router-link
              :to="`/stores/${store.id}`"
              class="text-lg font-semibold text-blue-600 hover:underline"
            >
              {{ store.name }}
            </router-link>
            <p class="text-sm text-gray-500">{{ store.address }}</p>
            <p class="text-sm text-gray-600 mt-1 line-clamp-2">
              {{ store.description }}
            </p>
          </template>
        </div>

        <!-- Buttons -->
        <div class="flex gap-2 mt-2 sm:mt-0">
          <template v-if="editingStoreId === store.id">
            <button
              @click="updateStore(store.id)"
              class="bg-green-500 hover:bg-green-600 text-white px-3 py-1 rounded text-xs font-medium"
            >
              Save
            </button>
            <button
              @click="cancelEdit"
              class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded text-xs font-medium"
            >
              Cancel
            </button>
          </template>

          <template v-else>
            <button
              @click="startEditing(store)"
              class="bg-yellow-400 hover:bg-yellow-500 text-white px-3 py-1 rounded text-xs font-medium"
            >
              Edit
            </button>
            <button
              @click="deleteStore(store.id)"
              class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded text-xs font-medium"
            >
              Delete
            </button>
          </template>
        </div>
      </div>
    </div>

    <!-- Pagination Controls -->
<div class="flex justify-between items-center pt-4 border-t">
  <button
    @click="prevPage"
    :disabled="page === 1"
    class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 disabled:opacity-50"
  >
    ← Prev
  </button>

  <span class="text-sm text-gray-600">Page {{ page }} of {{ totalPages }}</span>

  <button
    @click="nextPage"
    :disabled="page === totalPages"
    class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 disabled:opacity-50"
  >
    Next →
  </button>
</div>

  </div>
</template>

<script setup>
import { ref, onMounted, inject } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import Toast from '../components/Toast.vue';

const route = useRoute();
const router = useRouter();

const stores = ref([]);
const editingStoreId = ref(null);
const editedStore = ref({ name: '', description: '' });
const showToast = inject('showToast');
const page = ref(1);           // current page
const limit = 5;               // number of items per page
const totalPages = ref(1);     // total pages from API
const loading = ref(false);    // loading indicator
const searchQuery = ref('');
let searchTimeout = null;

onMounted(() => {
  if (route.query.success) {
    // toastMessage.value = route.query.success;
    // showToast.value = true;
    router.replace({ query: {} }); // Clear query param
  }

  fetchStores();
});

const fetchStores = async () => {
  try {
    loading.value = true;
    const res = await fetch(`http://localhost:3000/stores?page=${page.value}&limit=${limit}&q=${encodeURIComponent(searchQuery.value)}`);
    const storeRes = await res.json();
    stores.value = storeRes.data;
    totalPages.value = storeRes.meta.total_pages;
  } catch (error) {
    console.error('Failed to fetch stores:', error);
  } finally {
    loading.value = false;
  }
};

const handleSearch = () => {
  clearTimeout(searchTimeout);
  searchTimeout = setTimeout(() => {
    page.value = 1; // Reset to first page on new search
    fetchStores();
  }, 300); // debounce API calls
};

const startEditing = (store) => {
  editingStoreId.value = store.id;
  editedStore.value = { ...store };
};

const cancelEdit = () => {
  editingStoreId.value = null;
  editedStore.value = { name: '', address: '', description: '' };
};

const updateStore = async (id) => {
  try {
    const res = await fetch(`http://localhost:3000/stores/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(editedStore.value),
    });

    if (!res.ok) throw new Error('Failed to update');

    const updated = await res.json();
    const index = stores.value.findIndex((s) => s.id === id);
    stores.value[index] = updated.data;

    showToast(updated.message, 3000);

    cancelEdit();
  } catch (error) {
    console.error('Error updating store:', error);
  }
};

const deleteStore = async (id) => {
  if (!confirm('Are you sure you want to delete this store?')) return;

  try {
    const res = await fetch(`http://localhost:3000/stores/${id}`, { method: 'DELETE' });
    const deleted = await res.json();
    stores.value = stores.value.filter((s) => s.id !== id);

    showToast(deleted.message, 3000);
  } catch (error) {
    console.error('Error deleting store:', error);
  }
};

// Add these
const nextPage = () => {
  if (page.value < totalPages.value) {
    page.value++;
    fetchStores();
  }
};

const prevPage = () => {
  if (page.value > 1) {
    page.value--;
    fetchStores();
  }
};
</script>
