import pool from '../config/database.js';
import { getNextMatchId } from '../middlewares/nextMatchId.js';

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

export const editTournament = async (tournament_id, tournament_name, tournament_type, start_date, end_date, nb_participants, playoffTeams, game_id, organizer_id) => {
    try {
        const [rows] = await pool.query(`
            SELECT COUNT(*) AS participant_count
            FROM PlayerMatch
            WHERE match_id IN (
                SELECT match_id FROM Matchmaking
                WHERE tournamentRound_id IN (
                    SELECT tournamentRound_id FROM TournamentRound
                    WHERE tournament_id = ?
                )
            )
        `, [tournament_id]);

        if (rows[0].participant_count > 0) {
            throw new Error("Impossible de modifier le tournoi car des participants sont déjà inscrits");
        }

        const [result] = await pool.query(
            'CALL EditTournament(?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [tournament_id, tournament_name, tournament_type, start_date, end_date, nb_participants, playoffTeams, game_id, organizer_id]
        );

        return "Tournoi modifié avec succès";
    } catch (error) {
        if (error.message === "Impossible de modifier le tournoi car des participants sont déjà inscrits") {
            console.error("Erreur : Impossible de modifier le tournoi car des participants sont déjà inscrits");
            throw new Error("Impossible de modifier le tournoi car des participants sont déjà inscrits");
        } else {
            console.error("Erreur dans la modification du tournoi:", error);
            throw error;
        }
    }
};

export const deleteTournament = async (tournament_id) => {
    try {
        const [result] = await pool.query(
            'CALL DeleteTournament(?)',
            [tournament_id]
        );
        return "Tournoi supprimé avec succès";
    } catch (error) {
        console.error("Erreur dans la suppression du tournoi:", error);
        throw error;
    }
};

export async function getFormattedTournamentDetails(tournamentId) {
    try {
        console.log('----------------------------------------');
        console.log(`Fetching tournament details for Tournament ID: ${tournamentId}`);

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

        const startingMatchIdQuery = `
            SELECT MIN(match_id) as startingMatchId
            FROM Matchmaking
            WHERE tournamentRound_id IN (
                SELECT tournamentRound_id
                FROM TournamentRound
                WHERE tournament_id = ?
            )
        `;
        const [startingMatchIdResult] = await pool.query(startingMatchIdQuery, [tournamentId]);
        const startingMatchId = startingMatchIdResult[0].startingMatchId;

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
                            console.log('Player:', player);
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

                        const nextMatchID = getNextMatchId(totalParticipants, match.match_id, startingMatchId);

                        // console.log(`Next match ID for match ${match.match_id} is ${nextMatchID}`);

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

        console.log("Schema of the tournament details:");
        console.log(
            JSON.stringify(
                roundsWithMatches.map((round) => ({
                    Round: round.round,
                    Matches: round.matchs.map((match) => ({
                        Match: match.id,
                        Team1: match.team1,
                        Team2: match.team2,
                        Winner: match.winner,
                        NextMatchID: match.nextMatchID,
                    })),
                })),
                null,
                2
            )
        );

        return roundsWithMatches;
    } catch (error) {
        console.error(error);
        throw new Error('An error occurred while fetching tournament details');
    }
}


export async function updateMatchScore(matchId, player1Id, score1, player2Id, score2, totalParticipants, tournamentId) {
    try {
        // Fetch the startingMatchId dynamically
        const startingMatchIdQuery = `
            SELECT MIN(match_id) AS startingMatchId
            FROM Matchmaking
            WHERE tournamentRound_id IN (
                SELECT tournamentRound_id
                FROM TournamentRound
                WHERE tournament_id = ?
            )
        `;
        const [startingMatchIdResult] = await pool.query(startingMatchIdQuery, [tournamentId]);
        const startingMatchId = startingMatchIdResult[0].startingMatchId;

        console.log("Tournement ID", tournamentId);
        console.log("Starting match ID:", startingMatchId);
        const nextMatchId = getNextMatchId(totalParticipants, matchId, startingMatchId);

        console.log("Parameters sent to the procedure:", {
            matchId,
            player1Id,
            score1,
            player2Id,
            score2,
            nextMatchId,
        });

        const result = await pool.query(
            'CALL UpdateMatchResult(?, ?, ?, ?, ?, ?)', 
            [matchId, player1Id, score1, player2Id, score2, nextMatchId]
        );

        return { success: true, message: "Score updated successfully" };
    } catch (error) {
        console.error("Error while updating the score:", error);
        throw error;
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
