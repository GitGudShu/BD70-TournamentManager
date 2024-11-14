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
        const [result] = await pool.query(
            'CALL CreateTournament(?, ?, ?, ?, ?, ?, ?, ?, @new_tournament_id)',
            [tournament_name, tournament_type, start_date, end_date, nb_participants, playoffTeams, game_id, organizer_id]
        );

        const [tournamentIdRow] = await pool.query('SELECT @new_tournament_id as tournamentId');
        return tournamentIdRow[0].tournamentId;
    } catch (error) {
        console.error("Erreur dans la création du tournoi:", error);
        throw error;
    }
};

export async function generateTournamentRoundsForType1(tournamentId, participantCount) {
    try {
        const [result] = await pool.query(
            'CALL GenerateTournamentRoundsForType1(?, ?)',
            [tournamentId, participantCount]
        );
        return { success: true, message: 'Rounds et matchs générés avec succès' };
    } catch (error) {
        console.error('Erreur lors de la génération des rounds:', error);
        throw error;
    }
}

export async function generateTournamentRoundsForType2(tournamentId, participantCount) {
    try {

    } catch (error) {
        console.error('Erreur lors de la génération des rounds:', error);
        throw error;
    }
}

export async function generateTournamentRoundsForType3(tournamentId, participantCount) {
    try {

    } catch (error) {
        console.error('Erreur lors de la génération des rounds:', error);
        throw error;
    }
}

export async function generateTournamentRoundsForType4(tournamentId, participantCount) {
    try {

    } catch (error) {
        console.error('Erreur lors de la génération des rounds:', error);
        throw error;
    }
}

export async function generateTournamentRoundsForType5(tournamentId, participantCount) {
    try {

    } catch (error) {
        console.error('Erreur lors de la génération des rounds:', error);
        throw error;
    }
}

export async function generateTournamentRoundsForType6(tournamentId, participantCount) {
    try {

    } catch (error) {
        console.error('Erreur lors de la génération des rounds:', error);
        throw error;
    }
}
