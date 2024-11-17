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

import { updateMatchScore } from '../models/tournamentModel.js';

import pool from '../config/database.js';

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

export const handleUpdateMatchScore = async (req, res) => {
    const { matchId, team1, team2 } = req.body;
  
    try {
      // Vérification des données envoyées
      if (!team1 || !team2) {
        return res.status(400).json({ success: false, message: "Données des équipes manquantes" });
      }
  
      // Récupération de l'ID du round et du tournoi
      const match = await pool.query('SELECT tournamentRound_id FROM Matchmaking WHERE match_id = ?', [matchId]);
      if (match.length === 0) {
        return res.status(404).json({ success: false, message: 'Match non trouvé' });
      }
      const tournamentRoundId = match[0][0]?.tournamentRound_id;
  
      const tournamentResult = await pool.query('SELECT tournament_id FROM TournamentRound WHERE tournamentRound_id = ?', [tournamentRoundId]);
      if (tournamentResult.length === 0) {
        return res.status(404).json({ success: false, message: 'Tournoi non trouvé' });
      }
      const tournamentId = tournamentResult[0][0]?.tournament_id;
  
      const participantsResult = await pool.query(
        'SELECT nb_participants FROM Tournament WHERE tournament_id = ?',
        [tournamentId]
      );
      if (participantsResult.length === 0) {
        return res.status(404).json({ success: false, message: 'Nombre de participants non trouvé' });
      }
      const totalParticipants = participantsResult[0][0]?.nb_participants;
  
      // Appel de la fonction updateMatchScore avec les données combinées
      const result = await updateMatchScore(
        matchId,
        team1.playerId,
        team1.score,
        team2.playerId,
        team2.score,
        totalParticipants
      );
  
      res.status(200).json(result);
    } catch (error) {
      console.error('Erreur lors de la mise à jour du score:', error);
      res.status(500).json({ success: false, message: 'Erreur lors de la mise à jour du score' });
    }
  };  

  export async function getPlayerTournaments(req, res) {
    const playerId = req.params.playerId;

    try {
        // Query to fetch tournaments a player participated in
        const query = `
            SELECT DISTINCT t.tournament_id, t.tournament_name, t.start_date, t.end_date
            FROM Tournament t
            JOIN TournamentRound tr ON t.tournament_id = tr.tournament_id
            JOIN Matchmaking m ON tr.tournamentRound_id = m.tournamentRound_id
            JOIN PlayerMatch pm ON m.match_id = pm.match_id
            WHERE pm.player_id = ?
        `;

        const [results] = await pool.query(query, [playerId]);

        if (results.length === 0) {
            return res.status(404).json({ error: 'No tournaments found for this player' });
        }

        res.status(200).json(results);
    } catch (error) {
        console.error('Error fetching tournaments for player:', error);
        res.status(500).json({ error: 'Failed to fetch tournaments for the player' });
    }
}
