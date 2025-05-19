<!-- src/components/IngredientItem.vue -->
<template>
  <li>
    <template v-if="isEditing">
      <input v-model="localIngredient.name" placeholder="Name" />
      <input v-model="localIngredient.quantity" placeholder="Quantity" />
      <button @click="saveEdit">💾 Save</button>
      <button @click="cancelEdit">✖ Cancel</button>
    </template>
    <template v-else>
      <strong>{{ ingredient.name }}</strong>: {{ ingredient.quantity }}
      <button @click="startEdit">✏️ Edit</button>
      <button @click="deleteIngredient">🗑 Delete</button>
    </template>
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
const localIngredient = ref({ ...props.ingredient });

const startEdit = () => {
  localIngredient.value = { ...props.ingredient };
  isEditing.value = true;
};

const cancelEdit = () => {
  isEditing.value = false;
};

const saveEdit = async () => {
  try {
    const res = await fetch(`http://localhost:3000/ingredients/${props.ingredient.id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(localIngredient.value)
    });
    if (!res.ok) throw new Error('Update failed');
    const updated = await res.json();
    emit('updated', updated);
    isEditing.value = false;

    showToast(updated.message)
  } catch (error) {
    alert('Failed to update ingredient.');
    console.error(error);
  }
};

const deleteIngredient = async () => {
  if (!confirm('Delete this ingredient?')) return;
  try {
    const res = await fetch(`http://localhost:3000/ingredients/${props.ingredient.id}`, {
      method: 'DELETE'
    });
    const deleted = await res.json();
    if (!res.ok) throw new Error('Delete failed');

    showToast(deleted.message)
    emit('deleted', props.ingredient.id);
  } catch (error) {
    alert('Failed to delete ingredient.');
    console.error(error);
  }
};
</script>

<style scoped>
input {
  margin: 0.2rem 0.5rem 0.2rem 0;
  padding: 0.3rem;
}
button {
  margin-left: 0.4rem;
  cursor: pointer;
}
</style>
