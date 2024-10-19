import mysql from 'mysql2';
import dotenv from 'dotenv';

dotenv.config();

const pool = mysql.createPool({
    host: process.env.MYSQL_HOST || 'localhost',
    user: process.env.MYSQL_USER || 'root',
    password: process.env.MYSQL_PASSWORD || 'password',
    database: process.env.MYSQL_DATABASE || 'tournamend_db',
}).promise()

export async function getJeux() {
    const [rows] = await pool.query('SELECT * FROM Jeux');
    return rows;
}

export async function getJeu(id) {
    const [rows] = await pool.query(`
        SELECT * FROM Jeux
        WHERE id = ?
    `, [id]);
    return rows[0]; // To avoid returning an array
}

// TODO: I do not handle the image here, maybe I can add it now but I'm unsure ? We will see
async function createJeu(name, min_players, max_players, type, rules) {
    const [result] = await pool.query(`
        INSERT INTO Jeux (name, min_players, max_players, type, rules)
        VALUES (?, ?, ?, ?, ?)
    `, [name, min_players, max_players, type, rules]);
    return result.insertId; // Only info I care about, and avoid leaking the rest
}