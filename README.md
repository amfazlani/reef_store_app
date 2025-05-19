# 🛒 Store Inventory CRUD App

This is a full-stack CRUD application for managing:

- **Stores**
- **Items per Store**
- **Ingredients per Item**

Built using:

- **Rails 8 API** (Ruby 3.3.0)
- **Vue 3 frontend**
- **PostgreSQL**
- **Docker + Docker Compose**
- Runs locally or via Docker Compose


## 📚 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [File Structure](#file-structure)
- [Installation](#installation)
  - [Local Setup](#local-setup)
  - [Docker Setup](#docker-setup)
- [API Reference](#api-reference)
  - [Stores](#stores)
  - [Items](#items)
  - [Ingredients](#ingredients)
- [License](#license)

---

## ✅ Features

- Create, read, update, delete (**CRUD**) for:
  - Stores
  - Items within each store
  - Ingredients within each item

---

## 🔧 Tech Stack

| Layer     | Tech       | Version |
|-----------|------------|---------|
| Backend   | Ruby       | 3.3.0   |
|           | Rails (API)| 8.x     |
| Frontend  | Vue        | 3.x     |
| Database  | PostgreSQL | 14+     |
| Runtime   | Docker     | Compose |

---

## 📂 File Structure

```text
reef_store_app/
├── app/                   # Rails API app code (root directory)
├── client/                # Vue 3 frontend
│   ├── public/
│   ├── src/
│   └── package.json
├── config/
├── db/
├── docker-compose.yml
├── Dockerfile
├── Gemfile
├── Gemfile.lock
└── README.md
```

## ⚙️ Installation

### 🔧 Local Setup

#### 1. Clone the repo

```bash
git clone https://github.com/amfazlani/reef_store_app.git
cd reef_store_app
```

# Install Ruby and dependencies
rbenv install 3.3.0
rbenv local 3.3.0
bundle install

# Setup database
rails db:create db:migrate db:seed

# Start Rails server
rails server

# Start frontend
cd client
npm install
npm run dev

App runs at: http://localhost:3001

API runs at: http://localhost:3000

# Docker setup

docker-compose up --build

docker-compose exec web rails db:create db:migrate db:seed

# API Reference

| Method | Endpoint                  | Description             |
| ------ | ------------------------- | ----------------------- |
| GET    | `/stores/:store_id/items` | List items for a store  |
| POST   | `/stores/:store_id/items` | Create item for a store |
| GET    | `/items/:id`              | Show an item            |
| PATCH  | `/items/:id`              | Update an item          |
| DELETE | `/items/:id`              | Delete an item          |
| Method | Endpoint                      | Description               |
| ------ | ----------------------------- | ------------------------- |
| GET    | `/items/:item_id/ingredients` | List ingredients for item |
| POST   | `/items/:item_id/ingredients` | Create an ingredient      |
| GET    | `/ingredients/:id`            | Show an ingredient        |
| PATCH  | `/ingredients/:id`            | Update an ingredient      |
| DELETE | `/ingredients/:id`            | Delete an ingredient      |
| Method | Endpoint                      | Description               |
| ------ | ----------------------------- | ------------------------- |
| GET    | `/items/:item_id/ingredients` | List ingredients for item |
| POST   | `/items/:item_id/ingredients` | Create an ingredient      |
| GET    | `/ingredients/:id`            | Show an ingredient        |
| PATCH  | `/ingredients/:id`            | Update an ingredient      |
| DELETE | `/ingredients/:id`            | Delete an ingredient      |

## 🧪 Running Tests

The backend uses [RSpec](https://rspec.info/) for testing.

To run the test suite:

```bash
bundle exec rspec
```

This will run all unit, request, and model tests in the spec/ directory.

Make sure your database is set up for test:


```bash
RAILS_ENV=test rails db:create db:migrate
```
