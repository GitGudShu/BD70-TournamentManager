import pool from '../config/database.js';

export async function getAllTournaments() {
    const [rows] = await pool.query('SELECT * FROM Tournament');
    return rows;
}

export async function getTournamentDetails(tournamentId) {
    try {
        const tournamentQuery = `
            SELECT * FROM Tournament
            WHERE tournament_id = ?
        `;
        const [tournamentRows] = await pool.query(tournamentQuery, [tournamentId]);

        if (tournamentRows.length === 0) {
            throw new Error('Tournament not found');
        }

        const tournament = tournamentRows[0];

        const roundsQuery = `
            SELECT * FROM TournamentRound
            WHERE tournament_id = ?
        `;
        const [roundsRows] = await pool.query(roundsQuery, [tournamentId]);

        const roundsWithMatches = await Promise.all(
            roundsRows.map(async (round) => {
                const matchesQuery = `
                    SELECT * FROM Matchmaking
                    WHERE tournamentRound_id = ?
                `;
                const [matchesRows] = await pool.query(matchesQuery, [round.tournamentRound_id]);
                round.matches = matchesRows;
                return round;
            })
        );

        tournament.rounds = roundsWithMatches;
        return tournament;
    } catch (error) {
        console.error(error);
        throw new Error('Error fetching tournament details');
    }
}

export const createTournament = async (tournament_name, tournament_type, start_date, end_date, nb_participants, playoffTeams, game_id, organizer_id) => {
    try {
        const query = `
            INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, playoffTeams, game_id, organizer_id)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `;
        const values = [tournament_name, tournament_type, start_date, end_date, nb_participants, playoffTeams, game_id, organizer_id];
        const [result] = await pool.query(query, values);
        return result.insertId;
    } catch (error) {
        console.error("Erreur dans la création du tournoi:", error);
        throw error;
    }
};

export async function generateTournamentRounds(tournamentId, participantCount) {
    try {
        console.log("Début génération des rounds...");
        console.log(`Nombre de participants: ${participantCount}`);
        
        const totalRounds = Math.log2(participantCount);
        console.log(`Total rounds nécessaires: ${totalRounds}`);

        let currentMatchCount = participantCount / 2;
        console.log(`Nombre de matchs au premier round: ${currentMatchCount}`);

        for (let round = 1; round <= totalRounds; round++) {
            console.log(`Création du round ${round}`);

            await pool.query(
                'INSERT INTO TournamentRound (round, section, tournament_id) VALUES (?, ?, ?)',
                [round, 1, tournamentId]
            );

            for (let match = 1; match <= currentMatchCount; match++) {
                await pool.query(
                    'INSERT INTO Matchmaking (match_date, location, status, tournamentRound_id) VALUES (?, ?, ?, ?)',
                    [null, null, 0, round]
                );
            }
            currentMatchCount /= 2;
        }
        return { success: true, message: 'Rounds et matchs générés avec succès' };
    } catch (error) {
        console.error('Erreur lors de la génération des rounds:', error);
        throw error;
    }
}