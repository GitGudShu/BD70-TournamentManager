import express from 'express';
import { getGames, getGame, createGame } from '../controllers/gameController.js';

const router = express.Router();

router.get('/api/games', getGames);
router.get('/api/games/:id', getGame);
router.post('/api/games', createGame);

export default router;
