import express, { Router } from 'express';
import { getTournamentRankings } from '../controllers/rankingController.js';


const router = express.Router();

router.get('/api/getRanking/:tournament_id', getTournamentRankings);

export default router;