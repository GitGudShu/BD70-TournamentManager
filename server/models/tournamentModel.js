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

// Fonction utilitaire pour obtenir le prochain match ID
function getNextMatchId(totalParticipants, match_id) {
    const totalRounds = Math.log2(totalParticipants);

    let currentRound = 1;
    let matchesInRound = totalParticipants / 2;
    let roundStartId = 1;
    let matchIndex = match_id - roundStartId;

    // Localiser le round du match actuel
    while (match_id >= roundStartId + matchesInRound) {
        roundStartId += matchesInRound;
        matchesInRound /= 2;
        currentRound++;
        matchIndex = match_id - roundStartId;
    }

    // Calculer l'ID du prochain match pour le round suivant
    if (currentRound < totalRounds) {
        const nextMatchIndex = Math.floor(matchIndex / 2);
        const nextRoundStartId = roundStartId + matchesInRound;
        return nextRoundStartId + nextMatchIndex;
    }
    return null;
}

export async function getFormattedTournamentDetails(tournamentId) {
    try {
        // Récupérer les informations du tournoi, y compris nb_participants
        const tournamentQuery = `
            SELECT nb_participants
            FROM Tournament
            WHERE tournament_id = ?
        `;
        const [tournamentResult] = await pool.query(tournamentQuery, [tournamentId]);
        const totalParticipants = tournamentResult[0].nb_participants;

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

                if (matchesRows.length === 0) return { ...round, matchs: [] };

                const matchesWithPlayers = await Promise.all(
                    matchesRows.map(async (match) => {
                        const playerMatchesQuery = `
                            SELECT pm.match_id, pm.player_id, pm.score
                            FROM PlayerMatch pm
                            WHERE pm.match_id = ?
                        `;
                        const [playerMatchesRows] = await pool.query(playerMatchesQuery, [match.match_id]);

                        const player1 = playerMatchesRows[0] || { player_id: null, score: null };
                        const player2 = playerMatchesRows[1] || { player_id: null, score: null };

                        const getPlayerInfo = async (playerId) => {
                            if (!playerId) return { name: "Non attribué", id: null };
                            const playerQuery = `
                                SELECT u.user_name, u.user_lastname
                                FROM Player p
                                JOIN Users u ON p.user_id = u.user_id
                                WHERE p.player_id = ?
                            `;
                            const [playerInfoRows] = await pool.query(playerQuery, [playerId]);
                            const player = playerInfoRows[0];
                            return {
                                name: `${player.user_name} ${player.user_lastname}`,
                                id: playerId
                            };
                        };

                        const team1 = await getPlayerInfo(player1.player_id);
                        const team2 = await getPlayerInfo(player2.player_id);

                        let winner = null;
                        if (player1.score > player2.score) {
                            winner = "player1";
                        } else if (player2.score > player1.score) {
                            winner = "player2";
                        }

                        const nextMatchID = getNextMatchId(totalParticipants, match.match_id);

                        return {
                            id: match.match_id,
                            team1: {
                                id: team1.id,
                                name: team1.name,
                                score: player1.score,
                            },
                            team2: {
                                id: team2.id,
                                name: team2.name,
                                score: player2.score,
                            },
                            winner: winner,
                            nextMatchID: nextMatchID
                        };
                    })
                );

                round.matchs = matchesWithPlayers;
                return round;
            })
        );

        return roundsWithMatches;
    } catch (error) {
        console.error(error);
        throw new Error('An error occurred while fetching tournament details');
    }
}

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
