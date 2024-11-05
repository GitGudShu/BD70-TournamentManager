import pool from '../config/database.js';

export async function getAllGames() {
    const [rows] = await pool.query('SELECT * FROM Game');
    return rows;
}

export async function getGameById(id) {
    const [rows] = await pool.query('SELECT * FROM Game WHERE id = ?', [id]);
    return rows[0];
}