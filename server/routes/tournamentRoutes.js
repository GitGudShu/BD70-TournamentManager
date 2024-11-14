import express, { Router } from 'express';
import { handleCreateTournament } from '../controllers/tournamentController.js'; 
import { getTournaments } from '../controllers/tournamentController.js';
import { getTournamentDetailById } from '../controllers/tournamentController.js';
import { getTournamentDetailsController } from '../controllers/tournamentController.js';


const router = express.Router();

router.post('/api/tournaments', handleCreateTournament);
router.get('/api/getTournaments', getTournaments);
router.get('/api/getTournaments/:tournamentId', getTournamentDetailById);
router.get('/api/getFormattedTournaments/:tournamentId', getTournamentDetailsController);

export default router;