import { getPopularGames, getPlayerMonthlyStats } from '../models/statsModel.js'; // Import the model function

export const showMostPopularGames = async (req, res) => {
    try {
        const games = await getPopularGames();
        res.status(200).json(games);
    } catch (error) {
        console.error('Error fetching popular games:', error);
        res.status(500).json({ success: false, message: 'Error fetching popular games' });
    }
};

export const getPlayerStatsByMonth = async (req, res) => {
    const { playerId } = req.params;

    try {
        const stats = await getPlayerMonthlyStats(playerId);
        res.status(200).json(stats);
    } catch (error) {
        console.error('Error fetching player stats by month:', error);
        res.status(500).json({ success: false, message: 'Error fetching player stats by month' });
    }
};
