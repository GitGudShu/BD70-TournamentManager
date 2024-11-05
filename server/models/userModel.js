import pool from '../config/database.js';

export async function createUserWithPlayer(userData) {
    const { userName, userLastname, email, password, playerBio, avatar } = userData;

    const [result] = await pool.query(
        'CALL CreateUserAndPlayer(?, ?, ?, ?, ?, ?)',
        [userName, userLastname, email, password, playerBio || null, avatar || null]
    );

    return result.insertId;
}
