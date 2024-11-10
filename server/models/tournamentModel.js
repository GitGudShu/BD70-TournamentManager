import pool from '../config/database.js';

export const createTournament = async (tournament_name, tournament_type, start_date, end_date, playoffTeams, game_id, organizer_id) => {
    try {
    const query = `
        INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, playoffTeams, game_id, organizer_id)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    `;
    const values = [tournament_name, tournament_type, start_date, end_date, playoffTeams, game_id, organizer_id];
    const [result] = await pool.query(query, values);
    return result;
    } catch (error) {
    console.error("Erreur dans la création du tournoi:", error);
    throw error;
    }
};