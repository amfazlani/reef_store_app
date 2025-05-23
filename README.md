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
- [Running Tests](#running-tests)
- [API Reference](#api-reference)
- [License](#license)

---

## Features

- Create, read, update, delete (**CRUD**) for:
  - Stores
  - Items within each store
  - Ingredients within each item

---

## Tech Stack

| Layer     | Tech       | Version |
|-----------|------------|---------|
| Backend   | Ruby       | 3.3.0   |
|           | Rails (API)| 8.x     |
| Frontend  | Vue        | 3.x     |
| Database  | PostgreSQL | 14+     |
| Runtime   | Docker     | Compose |

---

## File Structure

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

## Installation

#### 1. Clone the repo

```bash
git clone https://github.com/amfazlani/reef_store_app.git
cd reef_store_app
```

## Setup Environment Variables

To enable Google Maps features, you need to create a `.env` file in your frontend project and add your Google Maps API key.

Create a `.env` file in the root of your frontend project if it doesn't exist:

   ```bash
   touch .env
  ```

Open .env and add this line, replacing YOUR_GOOGLE_MAPS_API_KEY with your actual API key:

```bash
VITE_GOOGLE_MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY
```

#### How to Get Your Google Maps API Key:

1. Visit the Google Cloud Console Credentials page.

2. Create a new project or select an existing one.

3. Click Create Credentials and select API key.

4. Copy the generated API key.

5. Paste it into your .env file as shown above.

Ensure that the Google Maps JavaScript API (and other relevant APIs like Places API) are enabled for your project.

Restart your development server after creating or updating .env.

## 2. Docker Setup

Using **Docker** and **Docker Compose** simplifies the setup process by containerizing the application. Here’s how to run the app using Docker.

### Prerequisites

Ensure that you have **Docker** and **Docker Compose** installed on your machine. If not, follow these steps:

1. **Install Docker**: 
   - Visit the official [Docker installation page](https://www.docker.com/get-started) to download and install Docker for your operating system (Mac, Windows, or Linux).
   
2. **Install Docker Compose**:
   - Docker Compose is usually included with Docker Desktop (on Mac/Windows). If you're using Linux, follow the [Docker Compose installation guide](https://docs.docker.com/compose/install/).

### Running the Application with Docker Compose

Once you have Docker and Docker Compose installed, follow the steps below to get the app up and running.

#### 1. Build and Start Containers

Next, use Docker Compose to build and start the containers for the app. This will start both the Rails API backend and Vue.js frontend along with the PostgreSQL database.
```bash
docker-compose build

docker-compose up
```

These commands do the following:

  1. Builds the Docker images for the backend (Rails API) and frontend (Vue.js).

  2. Creates containers for each service (Rails API, PostgreSQL, Vue.js frontend).

  3. Starts the containers and sets up the app to run.

#### 2. Access the Application

Once the containers are up and running:

The Rails API will be available at http://localhost:3000.

The Vue.js frontend will be available at http://localhost:3001.


#### 3. Set Up the Database
```bash
docker-compose run api rails db:create

docker-compose run api rails db:migrate
```

This command will:

Create the PostgreSQL database.

Run any pending migrations to set up the necessary tables.


#### 4. Stopping the Containers
```bash
docker-compose down
```

This command will:

Stop and remove the containers that were created for the app.

Keep the volumes (databases) intact unless you add the --volumes flag, which will also remove the persistent data.

#### 5. Troubleshooting

If you encounter any issues while running the application with Docker, here are some common problems and solutions:

### 1. **Cannot Connect to the Frontend**
   - **Problem**: If you cannot access the Vue.js frontend at `http://localhost:8080`, the service might not be running properly.
   - **Solution**: Ensure that the Rails API backend is running and listening on port `3000`, as the frontend relies on the API for data. You can check the backend logs to see if it’s running correctly:
     ```bash
     docker-compose logs -f api
     ```
     If you see any errors related to the backend, try restarting the Docker containers:
     ```bash
     docker-compose down
     docker-compose up --build
     ```

### 2. **Database Connection Issues**
   - **Problem**: If you encounter errors related to the database, such as "cannot connect to the database" or "database not found", it might be a problem with the database setup.
   - **Solution**: Ensure that the database has been created and migrated. You can manually create and migrate the database by running:
     ```bash
     docker-compose run api rails db:create
     docker-compose run api rails db:migrate
     ```
     Check logs for more details: If any of the services fail to start, check their logs by running:
     ```bash
     docker-compose logs -f
     ```
#### 6. Local Installation ( if you are not using docker )

Before you can run this app, you need to install the following prerequisites:

### Install Ruby 3.3.0

1. **Install Homebrew** (if you don't have it):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```


2. **Install rbenv** to manage Ruby versions:
```bash
brew install rbenv
rbenv init
```

3. **Install Ruby 3.3.0**:
 ```bash
 rbenv install 3.3.0
 rbenv global 3.3.0
 ```

4. **Install Rails**:
Install Rails using the following command:
```bash
  gem install rails
```

5. **Install PostgreSQL**:
```bash
brew install postgresql
```

Start PostgreSQL service:
```bash
brew services start postgresql
```

Create a PostgreSQL user (if necessary):
```bash
psql postgres
CREATE USER your_username WITH PASSWORD 'your_password';
ALTER ROLE your_username SET client_encoding TO 'utf8';
ALTER ROLE your_username SET default_transaction_isolation TO 'read committed';
ALTER ROLE your_username SET timezone TO 'UTC';
ALTER ROLE your_username CREATEDB;
ALTER ROLE your_username LOGIN;
\q
```

6. **Set Up Backend (Rails API)**:
1. Install dependencies
```bash
bundle install
```
2. Set up PostgreSQL database:
```bash
rails db:create
rails db:migrate
```
3. Start the rails server:
```bash
rails s
```

7. **Set Up Frontend (Vue.js)**:
```bash
brew install node
npm install -g @vue/cli
```
1. Navigate to the client directory:
```bash
cd client
```
2. Install Vue.js dependencies:
```bash
npm install
```
3. Start the Vue.js development server:
```bash
npm run dev
```

## Running Tests

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

# API Reference

| Method | Endpoint         | Description          |
|--------|------------------|----------------------|
| GET    | `/stores`        | List all stores      |
| POST   | `/stores`        | Create a store       |
| GET    | `/stores/:id`    | Show a store         |
| PATCH  | `/stores/:id`    | Update a store       |
| DELETE | `/stores/:id`    | Delete a store       |
| GET    | `/stores/:store_id/items` | List items for a store        |
| POST   | `/stores/:store_id/items` | Create item for a store       |
| GET    | `/stores/:store_id/items/count` | List store's item count |
| GET    | `/items/:id`              | Show an item                  |
| PATCH  | `/items/:id`              | Update an item                |
| DELETE | `/items/:id`              | Delete an item                |
| GET    | `/items/:item_id/ingredients` | List ingredients for item |
| POST   | `/items/:item_id/ingredients` | Create an ingredient      |
| GET    | `/ingredients/:id`            | Show an ingredient        |
| PATCH  | `/ingredients/:id`            | Update an ingredient      |
| DELETE | `/ingredients/:id`            | Delete an ingredient      |

## License

This project is a take-home assignment and is not intended for public or commercial use. All rights reserved by the author.

