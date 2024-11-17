import pool from '../config/database.js';

export const getPopularGames = async () => {
    const gameImageMap = {
        'Les échecs': '/games/chess.jpg',
        'Othello': '/games/othello.jpg',
        'Catane': '/games/catan.jpg',
        'Go': '/games/go.jpg',
        'Shogi': '/games/shogi.jpg',
        'Carcassonne': '/games/carcassone.jpg',
        'Puissance 4': '/games/connect4.jpg',
        'Risk': '/games/risk.jpg',
        'Scrabble': '/games/scrabble.jpg',
        'Dames': '/games/draughts.jpg',
    };

    try {
        const query = `
            SELECT g.game_name AS name, COUNT(t.tournament_id) AS plays
            FROM Game g
            LEFT JOIN Tournament t ON g.game_id = t.game_id
            GROUP BY g.game_id
            ORDER BY plays DESC
        `;

        const [rows] = await pool.query(query);

        const games = rows.map((row) => ({
            name: row.name,
            plays: row.plays,
            image_path: gameImageMap[row.name] || 'placeholder.png',
        }));

        return games;
    } catch (error) {
        console.error('Error fetching popular games:', error);
        throw error;
    }
};

export const getPlayerMonthlyStats = async (playerId) => {
    const queryMonths = `
        SELECT DISTINCT DATE_FORMAT(start_date, '%m/%y') AS month
        FROM Tournament
        ORDER BY DATE_FORMAT(start_date, '%m/%y') ASC
    `;

    const queryMatchesByMonth = `
        SELECT DATE_FORMAT(t.start_date, '%m/%y') AS month, COUNT(pm.match_id) AS matches
        FROM PlayerMatch pm
        JOIN Matchmaking m ON pm.match_id = m.match_id
        JOIN TournamentRound tr ON m.tournamentRound_id = tr.tournamentRound_id
        JOIN Tournament t ON tr.tournament_id = t.tournament_id
        WHERE pm.player_id = ?
        GROUP BY month
    `;

    const queryWinsByMonth = `
        SELECT DATE_FORMAT(t.start_date, '%m/%y') AS month, COUNT(pm.match_id) AS wins
        FROM PlayerMatch pm
        JOIN Matchmaking m ON pm.match_id = m.match_id
        JOIN TournamentRound tr ON m.tournamentRound_id = tr.tournamentRound_id
        JOIN Tournament t ON tr.tournament_id = t.tournament_id
        WHERE pm.player_id = ? AND pm.score > (
            SELECT MAX(pm2.score)
            FROM PlayerMatch pm2
            WHERE pm2.match_id = pm.match_id AND pm2.player_id != pm.player_id
        )
        GROUP BY month
    `;

    const queryTopPlayerWinsByMonth = `
        SELECT DATE_FORMAT(t.start_date, '%m/%y') AS month, COUNT(pm.match_id) AS wins
        FROM PlayerMatch pm
        JOIN Matchmaking m ON pm.match_id = m.match_id
        JOIN TournamentRound tr ON m.tournamentRound_id = tr.tournamentRound_id
        JOIN Tournament t ON tr.tournament_id = t.tournament_id
        WHERE pm.player_id = (
            SELECT pm.player_id
            FROM PlayerMatch pm
            GROUP BY pm.player_id
            ORDER BY COUNT(pm.match_id) DESC
            LIMIT 1
        ) AND pm.score > (
            SELECT MAX(pm2.score)
            FROM PlayerMatch pm2
            WHERE pm2.match_id = pm.match_id AND pm2.player_id != pm.player_id
        )
        GROUP BY month
    `;

    const [monthsRows] = await pool.query(queryMonths);
    const [matchesRows] = await pool.query(queryMatchesByMonth, [playerId]);
    const [winsRows] = await pool.query(queryWinsByMonth, [playerId]);
    const [topPlayerWinsRows] = await pool.query(queryTopPlayerWinsByMonth);

    const months = monthsRows.map(row => row.month);
    const matchesByMonth = Object.fromEntries(matchesRows.map(row => [row.month, row.matches]));
    const winsByMonth = Object.fromEntries(winsRows.map(row => [row.month, row.wins]));
    const topPlayerWinsByMonth = Object.fromEntries(topPlayerWinsRows.map(row => [row.month, row.wins]));

    return {
        months,
        matchesPlayed: months.map(month => matchesByMonth[month] || 0),
        matchesWon: months.map(month => winsByMonth[month] || 0),
        topPlayerMatchesWon: months.map(month => topPlayerWinsByMonth[month] || 0),
    };
};
