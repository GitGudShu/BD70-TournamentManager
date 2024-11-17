import { Router } from 'express';
import { showMostPopularGames, getPlayerStatsByMonth } from '../controllers/statsController.js';

const router = Router();

router.get('/api/popular-games', showMostPopularGames);
router.get('/api/player-stats/:playerId', getPlayerStatsByMonth);

export default router;
