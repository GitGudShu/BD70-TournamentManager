import express from 'express';
import { handleCreateTournament } from '../controllers/tournamentController.js'; 

const router = express.Router();

router.post('/api/tournaments', handleCreateTournament);
// router.get('/api/gettournaments', getAllTournaments);  A FAIRE
// router.put('/api/tournaments/:id', updateTournament);  A FAIRE

export default router;