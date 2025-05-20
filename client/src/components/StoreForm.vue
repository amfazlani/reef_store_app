<template>
  <div class="max-w-xl mx-auto mt-16 px-4">
    <h2 class="text-2xl font-bold mb-6 text-center">
      {{ mode === 'edit' ? '✏️ Edit Store' : '🏪 Add New Store' }}
    </h2>

    <form @submit.prevent="handleSubmit" class="bg-white shadow-md rounded-lg p-6 space-y-4">
      <div>
        <label for="name" class="block font-medium mb-1">Store Name</label>
        <input
          v-model="name"
          type="text"
          id="name"
          class="w-full border border-gray-300 rounded px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
          required
        />
      </div>

      <div>
        <label for="address" class="block font-medium mb-1">Address</label>
        <input
          v-model="address"
          type="text"
          id="address"
          class="w-full border border-gray-300 rounded px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
          required
        />
      </div>

      <div>
        <label for="description" class="block font-medium mb-1">Description</label>
        <textarea
          v-model="description"
          id="description"
          class="w-full border border-gray-300 rounded px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
        ></textarea>
      </div>

      <div class="flex justify-end space-x-4">
        <router-link
          :to="mode === 'edit' ? `/stores/${route.params.id}` : '/'"
          class="bg-red-600 hover:bg-red-700 text-white hover:text-white font-medium py-2 px-4 rounded"
        >
          Cancel
        </router-link>
        <button
          type="submit"
          class="bg-blue-600 text-white font-semibold px-6 py-2 rounded hover:bg-blue-700 transition"
        >
          {{ mode === 'edit' ? 'Update Store' : 'Create Store' }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from 'vue';
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const showToast = inject('showToast');

const name = ref('')
const address = ref('')
const description = ref('')

const mode = route.query.mode || 'create'
const storeId = route.params.id

onMounted(async () => {
  if (mode === 'edit' && storeId) {
    try {
      const res = await fetch(`http://localhost:3000/stores/${storeId}`)
      if (!res.ok) throw new Error('Failed to fetch store')
      const data = await res.json()
      name.value = data.data.name
      address.value = data.data.address
      description.value = data.data.description
    } catch (error) {
      showToast(error, 'error');
    }
  }
})

const handleSubmit = async () => {
  const url = mode === 'edit'
    ? `http://localhost:3000/stores/${storeId}`
    : 'http://localhost:3000/stores'

  const method = mode === 'edit' ? 'PATCH' : 'POST'

  try {
    const res = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        name: name.value,
        address: address.value,
        description: description.value
      })
    })
    const redData = await res.json()

    if (!res.ok) throw new Error(redData.errors)

    router.push({
      path: `/stores/${redData.data.id}`,
      query: {
        success: mode === 'edit' ? 'Store updated successfully!' : 'Store created successfully!'
      }
    })

    showToast(redData.message)
  } catch (error) {
    showToast(error, 'error');
  }
}
</script>
