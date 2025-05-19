<!-- src/components/ItemForm.vue -->
<template>
  <form @submit.prevent="submitForm" class="space-y-4 bg-gray-50 p-4 rounded shadow">
    <div>
      <label class="block text-sm font-medium text-gray-700">Name</label>
      <input
        v-model="form.name"
        type="text"
        required
        class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
    </div>
    <div>
      <label class="block text-sm font-medium text-gray-700">Price</label>
      <input
        v-model="form.price"
        type="number"
        step="0.01"
        required
        class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
    </div>

    <div>
      <label class="block text-sm font-medium text-gray-700">Description</label>
      <textarea
        v-model="form.description"
        required
        rows="3"
        class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
      ></textarea>
    </div>
    <button
      type="submit"
      class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 transition"
    >
      Add Item
    </button>
  </form>
</template>

<script setup>
import { reactive, toRefs, watch } from 'vue';
import { defineProps, defineEmits } from 'vue';

const props = defineProps({
  modelValue: Object,         // initial item data
  submitLabel: String         // label for button
});
const emit = defineEmits(['submit']);

const form = reactive({
  name: props.modelValue?.name || '',
  price: props.modelValue?.price || 0,
  description: props.modelValue?.description || ''
});

const errors = reactive({});

const validate = () => {
  errors.name = form.name.trim() === '' ? 'Name is required' : '';
  errors.price = form.price <= 0 ? 'Price must be greater than 0' : '';
  errors.description = form.description.trim() === '' ? 'Description is required' : '';
  return !errors.name && !errors.price && !errors.description;
};

const submitForm = () => {
  if (validate()) {
    emit('submit', { ...form });
  }
};
</script>

<style scoped>
.error {
  color: red;
  font-size: 0.9em;
}
</style>
