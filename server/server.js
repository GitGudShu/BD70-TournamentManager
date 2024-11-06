import express from 'express';
import session from 'express-session';
import cors from 'cors';

import gameRoutes from './routes/gameRoutes.js';
import userRoutes from './routes/userRoutes.js';

const app = express();

// Manually handle CORS to ensure preflight requests work (worst thing ever)
app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "http://localhost:9000");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
    res.header("Access-Control-Allow-Headers", "Content-Type, Authorization");
    res.header("Access-Control-Allow-Credentials", "true");

    if (req.method === "OPTIONS") {
        return res.status(200).end();
    }
    next();
});

// Session configuration
app.use(session({
    secret: process.env.SESSION_SECRET || 'your_secret_key', 
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } // For development only
}));

app.use(express.json()); // JSON body parser

// Home route
app.get('/api', (req, res) => {
    res.send('Welcome to the Tournament Library API!');
});

// Routes
app.use(gameRoutes); // Game table routes
app.use(userRoutes); // User table routes

app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});

app.listen(5000, () => {
    console.log("Server is running on port 5000")
});