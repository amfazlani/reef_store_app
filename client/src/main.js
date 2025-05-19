import { createApp } from "vue";
import { createRouter, createWebHistory } from "vue-router";
import './style.css'
import './assets/main.css';

import App from "./App.vue";

import Stores from "./components/Stores.vue";
import Store from "./components/Store.vue";
import StoreForm from "./components/StoreForm.vue";
import Item from "./components/Item.vue";


const routes = [
  {
    path: '/',
    name: 'Stores',
    component: Stores
  },
  {
    path: '/stores/:id',
    name: 'Store',
    component: Store
  },
  {
    path: '/stores/:id/edit',
    name: 'EditStore',
    component: StoreForm
  },
  {
    path: '/stores/new',
    name: 'NewStore',
    component: StoreForm
  },
  { 
    path: '/items/:id',
    name: 'Item',
    component: Item,
    props: true 
  }, // NEW
]

// Create the router instance
const router = createRouter({
  history: createWebHistory(),
  routes,
});

const app = createApp(App);

app.use(router);

app.mount('#app')
