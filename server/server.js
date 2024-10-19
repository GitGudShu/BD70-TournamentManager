import express from 'express';
const app = express();

import { getJeux, getJeu } from './api/database.js';

app.get("/api", (req, res) => {
    res.json({"users": ["Idiot 1", "Idiot 2", "Idiot 3s"]}); // Test data
});

app.get("/api/get_jeux", async(req, res) => {
    const games = await getJeux();
    res.json(games);
})

app.get("/api/get_jeu/:id", async(req, res) => {
    const game = await getJeu(req.params.id);
    res.json(game);
})

app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});

app.listen(5000, () => {console.log("Server is running on port 5000")});