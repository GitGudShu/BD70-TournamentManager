import pool from '../config/database.js';

export async function getTournamentRankings(req, res) {
    // console.log('----------------------------------------');
    const tournamentId = req.params.tournament_id;

    if (!tournamentId) {
        return res.status(400).json({ error: "Tournament ID is required" });
    }

    try {
        // console.log(`Starting rankings computation for Tournament ID: ${tournamentId}`);

        // Step 1: Fetch all matches for the tournament
        const matchesQuery = `
            SELECT pm.player_id, pm.match_id, pm.score, m.status AS match_status, tr.round
            FROM PlayerMatch pm
            JOIN Matchmaking m ON m.match_id = pm.match_id
            JOIN TournamentRound tr ON tr.tournamentRound_id = m.tournamentRound_id
            WHERE tr.tournament_id = ?
        `;
        const [matches] = await pool.query(matchesQuery, [tournamentId]);
        // console.log('Matches:', matches);

        // Step 2: Fetch all players participating in the tournament
        const playersQuery = `
            SELECT p.player_id, CONCAT(u.user_name, ' ', u.user_lastname) AS name
            FROM Player p
            JOIN Users u ON u.user_id = p.user_id
            WHERE p.player_id IN (
                SELECT DISTINCT player_id
                FROM PlayerMatch pm
                JOIN Matchmaking m ON pm.match_id = m.match_id
                JOIN TournamentRound tr ON tr.tournamentRound_id = m.tournamentRound_id
                WHERE tr.tournament_id = ?
            )
        `;
        const [players] = await pool.query(playersQuery, [tournamentId]);
        // console.log('Players:', players);

        // Step 3: Build player statistics
        const playerStats = {};
        players.forEach(player => {
            playerStats[player.player_id] = {
                name: player.name,
                wins: 0,
                status: 'En duel', // Default status
            };
        });

        // console.log('Initial Player Stats:', playerStats);

        // Step 4: Process matches to update player statistics
        matches.forEach(match => {
            const { player_id, match_id, score, match_status } = match;

            // Determine the maximum score for the match
            const maxScore = Math.max(
                ...matches.filter(m => m.match_id === match_id).map(m => m.score || 0)
            );

            if (match_status === 2) {
                // Completed matches
                if (score === maxScore) {
                    playerStats[player_id].wins += 1;
                } else {
                    playerStats[player_id].status = 'Perdu';
                }
            }
        });

        // console.log('Updated Player Stats After Match Processing:', playerStats);

        // Step 5: Identify the final match (latest by round and match_id)
        const finalMatchQuery = `
            SELECT m.match_id, m.status
            FROM Matchmaking m
            JOIN TournamentRound tr ON m.tournamentRound_id = tr.tournamentRound_id
            WHERE tr.tournament_id = ?
            ORDER BY tr.round DESC, m.match_id DESC
            LIMIT 1
        `;
        const [finalMatch] = await pool.query(finalMatchQuery, [tournamentId]);
        // console.log('Final Match:', finalMatch);

        if (finalMatch.length > 0) {
            const { match_id: finalMatchId, status: finalMatchStatus } = finalMatch[0];

            if (finalMatchStatus === 2) {
                // Determine the winner of the final match
                const winnerQuery = `
                    SELECT pm.player_id
                    FROM PlayerMatch pm
                    WHERE pm.match_id = ? AND pm.score = (
                        SELECT MAX(pm2.score)
                        FROM PlayerMatch pm2
                        WHERE pm2.match_id = ?
                    )
                    LIMIT 1
                `;
                const [winner] = await pool.query(winnerQuery, [finalMatchId, finalMatchId]);

                if (winner.length > 0) {
                    const championId = winner[0].player_id;
                    if (playerStats[championId]) {
                        playerStats[championId].status = 'Champion';
                    }
                }
            }
        }

        // Step 6: Mark remaining players
        matches
            .filter(match => match.match_status === 0)
            .forEach(match => {
                if (playerStats[match.player_id].status === 'Perdu') {
                    playerStats[match.player_id].status = 'En duel';
                }
            });

        // Step 7: Compute rankings based on wins
        const rankings = Object.entries(playerStats)
            .map(([player_id, stats]) => ({
                player_id: parseInt(player_id, 10),
                name: stats.name,
                wins: stats.wins,
                status: stats.status,
            }))
            .sort((a, b) => b.wins - a.wins);

        // Assign ranks
        let rank = 1;
        rankings.forEach((player, index) => {
            if (
                index > 0 &&
                player.wins < rankings[index - 1].wins
            ) {
                rank = index + 1;
            }
            player.rank = rank;
        });

        // console.log('Final Computed Rankings:', rankings);

        res.status(200).json(rankings);
    } catch (error) {
        console.error('Error computing tournament rankings:', error);
        res.status(500).json({ error: "An error occurred while computing rankings." });
    }
}
