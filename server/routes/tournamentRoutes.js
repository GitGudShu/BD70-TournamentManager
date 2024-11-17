import express, { Router } from 'express';
import { 
    handleCreateTournament,
    getTournaments,
    getTournamentDetailsController,
    getTournamentDetailById,
    handleUpdateMatchScore,
    getPlayerTournaments
} from '../controllers/tournamentController.js';


const router = express.Router();

router.post('/api/tournaments', handleCreateTournament);
router.post('/api/update-match-score', handleUpdateMatchScore);

router.get('/api/getTournaments', getTournaments);
router.get('/api/getTournaments/:tournamentId', getTournamentDetailById);
router.get('/api/getFormattedTournaments/:tournamentId', getTournamentDetailsController);
router.get('/api/getPlayerTournaments/:playerId', getPlayerTournaments);

export default router;