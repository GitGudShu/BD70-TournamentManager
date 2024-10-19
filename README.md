# BD70 Tournament Manager

This project is a **Tournament Management System** for board games, composed of two main parts: the **client-side**, built with React, and the **server-side**, built with Node.js. The system allows users to create tournaments, register players, track match results, and generate leaderboards for various board games.

## Requirements

Before you start, ensure you have the following versions:
- **Node.js**: v18.18.0
- **npm**: v9.8.1

## Setup Instructions

### 1. Client (React)

The client-side is a React project. Follow these steps to set it up:

```bash
cd client
npm install
npm start
```

This will install the necessary dependencies and start the React development server.

### 2. Server (Node.js)

The server-side is built using Node.js. To set it up, go back to the root of project and then do:

```bash
cd server
npm install
npm run dev
```

This will install the server dependencies and start the Node.js server.

### 3. Database Setup (MySQL)

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
