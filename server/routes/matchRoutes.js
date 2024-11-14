import express from 'express';
import { handleParticipateInTournament } from '../controllers/matchController.js';

const router = express.Router();

router.post('/api/participateInTournament/:tournamentId/:playerId', handleParticipateInTournament);

export default router;