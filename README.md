# BD70 Tournament Manager

This project is a **Tournament Management System** for board games, composed of two main parts: the **client-side**, built with Quasar (Vue.js framework), and the **server-side**, built with Node.js. The system allows users to create tournaments, register players, track match results, and generate leaderboards for various board games.

## Requirements

Before you start, ensure you have the following versions:
- **Node.js**: v18.18.0
- **npm**: v9.8.1
- **Quasar CLI**: See below

## Setup Instructions

### Database Setup (MySQL)

If MySQL is not installed, you will need to install it. Once installed, set up the database by following these steps:

1. Open the MySQL shell:

   ```bash
   mysql -u root -p
   ```

2. Create the `tournament_db` database:

   ```sql
   CREATE DATABASE tournament_db;
   ```

3. Load the data from the `data.sql` file into the database:

   ```sql
   SOURCE ./data.sql;
   ```

Make sure you are in the `server` directory when you run the `SOURCE` command, so the path to the `data.sql` file is correct.

### Server (Node.js)

The server-side is built using Node.js. To set it up, follow these steps:

1. Navigate to the `server` directory and install dependencies:

    ```bash
    cd server
    npm install
    ```

2. Create a `.env` file in the `server` directory with the following content:

    ```bash
    MYSQL_HOST='localhost'
    MYSQL_USER=your_user
    MYSQL_PASSWORD=your_password
    MYSQL_DATABASE="tournament_db"
    SESSION_SECRET="secret"
    ```

Replace `your_user` and `your_password` with your actual MySQL credentials. This configuration will allow the Node.js server to connect to the MySQL database.

3. Start the server:

    ```bash
    npm run dev
    ```

### Client (Quasar Vuejs)

The client-side is a Quasar project. Follow these steps to set it up:

1. Navigate to the `client` directory:

    ```bash
    cd client
    ```

2. Install dependencies:

    ```bash
    npm install
    ```

3. Install Quasar CLI globally (if not already installed):

    ```bash
    npm i -g quasar
    npm install -g @quasar/cli
    ```

4. Start the Quasar development server:

    ```bash
    quasar dev
    ```

---

Your **Tournament Management System** is now set up and ready to use!
