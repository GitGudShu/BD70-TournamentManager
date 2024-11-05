import pool from '../config/database.js';

export async function getAllGames() {
    const [rows] = await pool.query('SELECT * FROM Jeux');
    return rows;
}

export async function getGameById(id) {
    const [rows] = await pool.query('SELECT * FROM Jeux WHERE id = ?', [id]);
    return rows[0];
}

export async function insertGame(name, min_players, max_players, type, rules) {
    const [result] = await pool.query(
        'INSERT INTO Jeux (name, min_players, max_players, type, rules) VALUES (?, ?, ?, ?, ?)',
        [name, min_players, max_players, type, rules]
    );
    return result.insertId;
}
