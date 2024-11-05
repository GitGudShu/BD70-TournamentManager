import express from 'express';
import gameRoutes from './routes/gameRoutes.js';

const app = express();

// Home route
app.get('/api', (req, res) => {
    res.send('Welcome to the Tournament Library API!');
});

// Routes
app.use(gameRoutes); // Game table routes

app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});

app.listen(5000, () => {
    console.log("Server is running on port 5000")
});