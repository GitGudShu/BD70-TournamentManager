import pool from '../config/database.js';
import bcrypt from 'bcrypt';

export async function createUserWithPlayer(userData) {
    const { userName, userLastname, email, password, playerBio, avatar } = userData;

    const hashedPassword = await bcrypt.hash(password, 10);

    const [result] = await pool.query(
        'CALL CreateUserAndPlayer(?, ?, ?, ?, ?, ?)',
        [userName, userLastname, email, hashedPassword, playerBio || null, avatar || null]
    );

    return result.insertId;
}

export async function findUserByEmail(email) {
    const [rows] = await pool.query('SELECT * FROM Users WHERE user_email = ?', [email]);
    return rows[0]; // Return the first user found
}