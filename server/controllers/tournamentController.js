import { createTournament } from '../models/tournamentModel.js';

export const handleCreateTournament = async (req, res) => {
    const { tournament_name, tournament_type, start_date, end_date, playoffTeams, game_id, organizer_id } = req.body;

    if (!tournament_name || !tournament_type || !start_date || !end_date || !game_id || !organizer_id) {
        return res.status(400).json({ error: 'Tous les champs sont nécessaires' });
    }

    try {
    const result = await createTournament(tournament_name, tournament_type, start_date, end_date, playoffTeams, game_id, organizer_id);
    if (result) {   
        res.status(201).json({ message: 'Tournoi créé avec succès' });
    } else {
        res.status(500).json({ error: 'Échec de la création du tournoi' });
    }
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erreur interne du serveur' });
    }
};