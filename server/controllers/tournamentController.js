import { createTournament, generateTournamentRounds } from '../models/tournamentModel.js';
import { getAllTournaments } from '../models/tournamentModel.js';

export async function getTournaments(req, res) {
    try {
        const tournaments = await getAllTournaments();
        res.json(tournaments);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch tournaments' });
    }
}

export const handleCreateTournament = async (req, res) => {
    const { tournament_name, tournament_type, start_date, end_date, playoffTeams, game_id, organizer_id, nb_participants } = req.body;

    if (!tournament_name || !tournament_type || !start_date || !end_date || !game_id || !organizer_id || !nb_participants) {
        return res.status(400).json({ error: 'Tous les champs sont nécessaires' });
    }
    console.log(tournament_type);
    try {
        const tournamentId = await createTournament(tournament_name, tournament_type, start_date, end_date, nb_participants, playoffTeams, game_id, organizer_id);
        if (tournamentId) {   
            if (tournament_type === 1) {
                console.log("Nombre de participants au tournoi: ", req.body.nb_participants);
                await generateTournamentRounds(tournamentId, nb_participants);
            }
            res.status(201).json({ message: 'Tournoi créé avec succès', tournamentId });
        } else {
            res.status(500).json({ error: 'Échec de la création du tournoi' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erreur interne du serveur' });
    }
};