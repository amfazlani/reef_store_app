<!-- src/views/ItemShow.vue -->
<template>
  <div v-if="item">
    <div class="max-w-4xl mx-auto mt-12 px-4">
      <!-- Back Link -->
      <router-link
        :to="{ name: 'Store', params: { id: route.params.store_id } }"
        class="text-blue-600 hover:underline text-sm mb-6 inline-block"
      >
        ← Back to Store
      </router-link>

      <!-- Main Item Card -->
      <div class="bg-white shadow rounded-lg p-6 flex flex-col md:flex-row gap-6">
        <!-- Image / Placeholder -->
        <div class="w-full md:w-1/3 bg-gray-100 aspect-square rounded flex items-center justify-center text-4xl text-gray-400">
          📦
        </div>

        <!-- Item Details -->
        <div class="flex-1">
          <div v-if="!isEditingItem">
            <h1 class="text-3xl font-bold text-gray-800 mb-2">{{ item.name }}</h1>
            <p class="text-green-600 text-xl font-semibold mb-4">${{ item.price }}</p>
            <p class="text-gray-700 mb-6">{{ item.description }}</p>

            <!-- Action Buttons -->
            <div class="flex gap-4 mb-4">
              <button @click="startEditItem" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition">✏️ Edit</button>
              <button @click="deleteItem(item)" class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700 transition">🗑 Delete</button>
            </div>
          </div>

          <!-- Edit Form -->
          <div v-else class="bg-gray-50 p-4 border border-gray-200 rounded-lg space-y-4">
            <input v-model="editedItem.name" class="w-full border border-gray-300 rounded px-3 py-2" placeholder="Name" />
            <input v-model="editedItem.price" class="w-full border border-gray-300 rounded px-3 py-2" placeholder="Price" type="number" step="0.01" />
            <textarea v-model="editedItem.description" class="w-full border border-gray-300 rounded px-3 py-2" placeholder="Description" />
            <div class="flex gap-4">
              <button @click="saveItemEdit" class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">💾 Save</button>
              <button @click="cancelEditItem" class="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400">❌ Cancel</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Ingredients Section -->
    <div class="mt-10 bg-white shadow rounded-lg p-6">
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-semibold text-gray-800">🧂 Ingredients</h2>
        <button
          @click="showAddForm = !showAddForm"
          class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded text-sm transition"
        >
          {{ showAddForm ? '✖ Cancel' : '➕ Add Ingredient' }}
        </button>
      </div>

      <!-- Add Form -->
      <transition name="fade">
        <div v-if="showAddForm" class="mb-6 space-y-3">
          <input
            v-model="newIngredient.name"
            placeholder="Ingredient Name"
            class="w-full border px-3 py-2 rounded focus:outline-none focus:ring focus:ring-blue-300"
          />
          <input
            v-model="newIngredient.quantity"
            placeholder="Quantity"
            class="w-full border px-3 py-2 rounded focus:outline-none focus:ring focus:ring-blue-300"
          />
          <button
            @click="addIngredient"
            class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700 transition"
          >
            ✅ Add
          </button>
        </div>
      </transition>

      <ul v-if="ingredients.length" class="space-y-4">
        <Ingredient
          v-for="ingredient in ingredients"
          :key="ingredient.id"
          :ingredient="ingredient"
          @updated="handleIngredientUpdate"
          @deleted="handleIngredientDelete"
        />
      </ul>
      <!-- No Ingredients Message -->
      <p
        v-else
        class="text-center text-gray-400 italic py-16"
      >
        No ingredients yet.
      </p>
    </div>
  </div>

  <div v-else-if="loading">
    <p>Loading item...</p>
  </div>

</template>

<script setup>
import { ref, onMounted, inject } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import Ingredient from '../components/Ingredient.vue';

const route = useRoute();
const router = useRouter();
const showToast = inject('showToast');

const item = ref(null);
const loading = ref(true);

const ingredients = ref([]);
const newIngredient = ref({ name: '', quantity: '' });
const showAddForm = ref(false);

// Inline editing for item
const isEditingItem = ref(false);
const editedItem = ref({ name: '', price: '', description: '' });

onMounted(async () => {
  try {
    // Fetch item
    const response = await fetch(`http://localhost:3000/items/${route.params.id}`);
    if (!response.ok) throw new Error('Failed to fetch item');
    const itemRes = await response.json();
    item.value = itemRes.data;

    // Fetch ingredients
    const res = await fetch(`http://localhost:3000/items/${route.params.id}/ingredients`);
    const ingredientRes = await res.json();
    ingredients.value = ingredientRes.data;

  } catch (error) {
    console.error(error);
  } finally {
    loading.value = false;
  }
});

// Item update
const saveItemEdit = async () => {
  try {
    const res = await fetch(`http://localhost:3000/items/${route.params.id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(editedItem.value)
    });

    if (!res.ok) throw new Error('Failed to update item');

    const updated = await res.json();
    item.value = updated.data;
    isEditingItem.value = false;

    showToast(updated.message)
  } catch (err) {
    alert('Failed to save item.');
    console.error(err);
  }
};

const deleteItem = async (item) => {
  if (!confirm('Are you sure you want to delete this item?')) return;

  const storeId = route.params.store_id;

  try {
    const res = await fetch(`http://localhost:3000/items/${item.id}`, {
      method: 'DELETE'
    });

    if (!res.ok) throw new Error('Failed to delete item');

    const deleted = await res.json();

    router.push(`/stores/${storeId}`);

    showToast(deleted.message)
  } catch (error) {
    console.error(error);
    alert('Could not delete item');
  }
};

// Ingredient create
const addIngredient = async () => {
  const res = await fetch(`http://localhost:3000/items/${route.params.id}/ingredients`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(newIngredient.value)
  });

  if (res.ok) {
    const created = await res.json();
    ingredients.value.push(created.data);
    newIngredient.value = { name: '', quantity: '' };
    showAddForm.value = false;

    showToast(created.message)
  } else {
    alert('Failed to add ingredient');
  }
};

// Util updates
const handleIngredientUpdate = (updated) => {
  const i = ingredients.value.findIndex(i => i.id === updated.data.id);
  if (i !== -1) ingredients.value[i] = updated.data;
};

const handleIngredientDelete = (deleted) => {
  ingredients.value = ingredients.value.filter(i => i.id !== deleted.data.id);
  showToast(deleted.message)
};

const startEditItem = () => {
  editedItem.value = { ...item.value };
  isEditingItem.value = true;
};

const cancelEditItem = () => {
  isEditingItem.value = false;
};
</script>


<style>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

.add-ingredient-form {
  margin-top: 1rem;
  padding: 1rem;
  background-color: #f9f9f9;
  border: 1px solid #ddd;
}

.item-edit-form {
  margin-top: 1rem;
  padding: 1rem;
  border: 1px solid #ddd;
  background: #f9f9f9;
}

.item-edit-form input,
.item-edit-form textarea {
  display: block;
  margin-bottom: 0.5rem;
  padding: 0.4rem;
  width: 100%;
  max-width: 400px;
}
</style>
