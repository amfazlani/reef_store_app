<template>
  <router-link to="/" class="text-blue-600 hover:underline text-sm mb-6 inline-block"
>← Back to store list</router-link>
  <div v-if="store">
    <!-- Store Info Card -->
    <div class="bg-white rounded-lg shadow p-6 flex flex-col sm:flex-row items-start sm:items-center gap-6 mb-8">
      <!-- Logo -->
      <div class="w-20 h-20 rounded-full bg-gray-200 flex items-center justify-center text-3xl font-bold text-gray-600">
        {{ store.name?.charAt(0) }}
      </div>

      <!-- Info -->
      <div class="flex-1">
        <h1 class="text-2xl font-bold text-gray-800 mb-1">{{ store.name }}</h1>
        <p class="text-gray-500 text-sm mb-1">{{ store.address }}</p>
        <p class="text-gray-700 text-sm">{{ store.description }}</p>
      </div>

      <div class="mt-4 text-blue-700 font-medium">
        Total Items: {{ itemCount }}
      </div>

      <router-link
      :to="`/stores/${store.id}/edit?mode=edit`"
      class="inline-block bg-blue-500 hover:bg-blue-700 text-white hover:text-white px-4 py-2 rounded text-sm font-medium shadow hover:bg-blue-600 transition mb-4"
      >
        ✏️ Edit Store
      </router-link>
    </div>

    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-semibold text-gray-800">📦 Items</h2>
      <button
        @click="showForm = !showForm"
        class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded transition"
      >
        {{ showForm ? 'Cancel' : 'Add Item' }}
      </button>
    </div>

    <!-- Form with Transition -->
    <transition name="fade-slide" mode="out-in">
      <div v-if="showForm" class="item-form-wrapper">

        <ItemForm :submit-label="'Create Item'" @submit="createItem" />
      </div>
    </transition>

    <div v-if="items && items.length" class="grid grid-cols-1 md:grid-cols-2 gap-4">
     <router-link
        v-for="item in items"
        :key="item.id"
        :to="{ name: 'Item', params: { store_id: store.id, id: item.id } }"
        class="block bg-white rounded-lg shadow p-4 hover:shadow-md transition duration-200"
      >
        <h3 class="text-lg font-semibold text-gray-800 mb-1">{{ item.name }}</h3>
        <p class="text-sm text-gray-600 mb-1">${{ item.price }}</p>
        <p class="text-sm text-gray-700">{{ item.description }}</p>
      </router-link>
    </div>
    <!-- No Items Message -->
    <p
      v-else
      class="text-center text-gray-400 italic py-16"
    >
      No items found for this store.
    </p>
  </div>

  <div v-else-if="loading">
    <p>Loading store details...</p>
  </div>

  <div v-else>
    <p>Store not found.</p>
  </div>
</template>


<script setup>
import { ref, onMounted, inject } from 'vue';
import { useRoute } from 'vue-router';
import ItemForm from '../components/ItemForm.vue';

const route = useRoute();
const store = ref(null);
const items = ref([]);
const itemCount = ref(0);
const loading = ref(true);
const showForm = ref(false);
const showToast = inject('showToast');

onMounted(async () => {
  const storeId = route.params.id;

  try {
    // Fetch store details
    const storeRes = await fetch(`http://localhost:3000/stores/${storeId}`);
    const data = await storeRes.json()

    if (!storeRes.ok) throw new Error(data.errors);

    store.value = data.data

    // Fetch store items
    const itemsRes = await fetch(`http://localhost:3000/stores/${storeId}/items`);
    if (!itemsRes.ok) throw new Error('Failed to load items');
    
    const itemData = await itemsRes.json()
    items.value = itemData.data

    // Fetch item count
    const countRes = await fetch(`http://localhost:3000/stores/${storeId}/items/count`);
    if (!countRes.ok) throw new Error('Failed to load item count');

    const countData = await countRes.json();
    itemCount.value = countData.data;
  } catch (error) {
    showToast(error, 'error');
  } finally {
    loading.value = false;
  }
});

const createItem = async (newItem) => {
  try {
    const storeId = route.params.id;
    const res = await fetch(`http://localhost:3000/stores/${storeId}/items`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(newItem)
    });
    const created = await res.json();

    if (!res.ok) throw new Error(created.errors);
    items.value.push(created.data);
    itemCount.value++; // update count after adding item
    showForm.value = false; // hide form after submission

    showToast(created.message)
  } catch (error) {
    showToast(error, 'error');
  }
};
</script>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

.item-form-wrapper {
  margin-top: 1rem;
  padding: 1rem;
  border: 1px solid #ccc;
  background: #f9f9f9;
}
</style>
