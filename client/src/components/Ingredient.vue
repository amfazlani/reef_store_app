<template>
  <li class="bg-gray-50 border border-gray-200 rounded p-4 hover:shadow-sm">
    <div v-if="isEditing" class="space-y-2">
      <input
        v-model="editingData.name"
        placeholder="Ingredient Name"
        class="w-full border px-3 py-2 rounded"
      />
      <input
        v-model="editingData.quantity"
        placeholder="Quantity"
        class="w-full border px-3 py-2 rounded"
      />
      <div class="flex gap-2">
        <button
          @click="save"
          class="bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700"
        >
          💾 Save
        </button>
        <button
          @click="cancel"
          class="bg-gray-300 px-3 py-1 rounded hover:bg-gray-400"
        >
          ❌ Cancel
        </button>
      </div>
    </div>

    <div v-else class="flex justify-between items-center">
      <div>
        <p class="text-gray-800 font-medium">{{ ingredient.name }}</p>
        <p v-if="!ingredient.quantity || ingredient.quantity == 0" class="text-red-500 text-sm">
          🔴 Out of Stock
        </p>
        <p v-else class="text-green-600 text-sm">
          🟢 In Stock: {{ ingredient.quantity }}
        </p>
      </div>
      <div class="flex gap-2">
        <button
          @click="edit"
          class="text-blue-600 hover:text-blue-600 text-sm"
        >
          ✏️ Edit
        </button>
        <button
          @click="destroy"
          class="text-red-600 hover:text-red-600 hover:underline text-sm"
        >
          🗑 Delete
        </button>
      </div>
    </div>
  </li>
</template>

<script setup>
import { ref, inject } from 'vue';
import { defineProps, defineEmits } from 'vue';

const props = defineProps({
  ingredient: Object
});
const emit = defineEmits(['updated', 'deleted']);
const showToast = inject('showToast');

const isEditing = ref(false);
const editingData = ref({ name: '', quantity: '' });

const edit = () => {
  isEditing.value = true;
  editingData.value = { ...props.ingredient };
};

const cancel = () => {
  isEditing.value = false;
};

const save = async () => {
  try {
    const res = await fetch(`http://localhost:3000/ingredients/${props.ingredient.id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(editingData.value)
    });

    if (!res.ok) throw new Error('Failed to update ingredient');
    const updated = await res.json();

    emit('updated', updated);
    showToast?.(updated.message || 'Ingredient updated');
    isEditing.value = false;
  } catch (err) {
    console.error(err);
    alert('Failed to save ingredient.');
  }
};

const destroy = async () => {
  if (!confirm('Are you sure you want to delete this ingredient?')) return;

  try {
    const res = await fetch(`http://localhost:3000/ingredients/${props.ingredient.id}`, {
      method: 'DELETE'
    });

    if (!res.ok) throw new Error('Failed to delete ingredient');
    const deleted = await res.json();
    emit('deleted', deleted);
    showToast?.(deleted.message || 'Ingredient deleted');
  } catch (err) {
    console.error(err);
    alert('Failed to delete ingredient.');
  }
};
</script>
