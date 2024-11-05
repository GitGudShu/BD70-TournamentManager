import express from 'express';
import { getGames, getGame } from '../controllers/gameController.js';

const router = express.Router();

router.get('/api/games', getGames);
router.get('/api/games/:id', getGame);

export default router;
