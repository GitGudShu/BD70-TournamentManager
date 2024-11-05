import { getAllGames, getGameById } from '../models/gameModel.js';

export async function getGames(req, res) {
    try {
        const games = await getAllGames();
        res.json(games);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch games' });
    }
}

export async function getGame(req, res) {
    try {
        const game = await getGameById(req.params.id);
        if (!game) return res.status(404).json({ error: 'Game not found' });
        res.json(game);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch game' });
    }
}
