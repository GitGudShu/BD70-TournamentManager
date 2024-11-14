import { createTournament } from '../models/tournamentModel.js';
import { getFormattedTournamentDetails } from '../models/tournamentModel.js';
import { generateTournamentRoundsForType1 } from '../models/tournamentModel.js';
import { generateTournamentRoundsForType2 } from '../models/tournamentModel.js';
import { generateTournamentRoundsForType3 } from '../models/tournamentModel.js';
import { generateTournamentRoundsForType4 } from '../models/tournamentModel.js';
import { generateTournamentRoundsForType5 } from '../models/tournamentModel.js';
import { generateTournamentRoundsForType6 } from '../models/tournamentModel.js';

import { getAllTournaments } from '../models/tournamentModel.js';
import { getTournamentDetails } from '../models/tournamentModel.js';

export async function getTournaments(req, res) {
    try {
        const tournaments = await getAllTournaments();
        res.json(tournaments);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch tournaments' });
    }
}

export async function getTournamentDetailById(req, res) {
    const tournamentId = req.params.tournamentId;

    try {
        const tournament = await getTournamentDetails(tournamentId);
        res.json(tournament);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch tournament details' });
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
            console.log("Nombre de participants au tournoi: ", req.body.nb_participants);
            switch (tournament_type) {
                case 1:
                    console.log("Tournoi type 1");
                    await generateTournamentRoundsForType1(tournamentId, nb_participants);
                    break;
            
                case 2:
                    console.log("Tournoi type 2");
                    await generateTournamentRoundsForType2(tournamentId, nb_participants);
                    break;
            
                case 3:
                    console.log("Tournoi type 3");
                    await generateTournamentRoundsForType3(tournamentId, nb_participants);
                    break;
            
                case 4:
                    console.log("Tournoi type 4");
                    await generateTournamentRoundsForType4(tournamentId, nb_participants);
                    break;
            
                case 5:
                    console.log("Tournoi type 5");
                    await generateTournamentRoundsForType5(tournamentId, nb_participants);
                    break;
            
                case 6:
                    console.log("Tournoi type 6");
                    await generateTournamentRoundsForType6(tournamentId, nb_participants);
                    break;
            
                default:
                    console.log("Type de tournoi non supporté");
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


export async function getTournamentDetailsController(req, res) {
    const tournamentId = req.params.tournamentId;

    try {
        const tournamentDetails = await getFormattedTournamentDetails(tournamentId);
        if (!tournamentDetails) {
            return res.status(404).json({ error: 'Tournament not found' });
        }
        return res.status(200).json(tournamentDetails);
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'An error occurred while fetching tournament details' });
    }
}