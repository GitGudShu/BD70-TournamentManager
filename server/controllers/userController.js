import bcrypt from 'bcrypt';
import { createUserWithPlayer, findUserByEmail } from '../models/userModel.js';
import pool from '../config/database.js';

export async function registerUser(req, res) {
    try {
        const { userName, userLastname, email, password, playerBio } = req.body;
        const avatar = req.file ? req.file.buffer : null;

        const userId = await createUserWithPlayer({
            userName,
            userLastname,
            email,
            password,
            playerBio,
            avatar
        });

        console.log(`User created: Name=${userName} ${userLastname}, Email=${email}`);
        res.status(201).json({ userId });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to create user and player' });
    }
}

export async function loginUser(req, res) {
    const { email, password } = req.body;

    try {
        console.log('Login attempt for email:', email);

        const user = await findUserByEmail(email);
        if (!user) {
            console.log('User not found for email:', email); 
            return res.status(401).json({ message: 'User not found' });
        }

        const passwordMatch = await bcrypt.compare(password, user.user_password);
        console.log('Password match:', passwordMatch);

        if (!passwordMatch) {
            console.log('Incorrect password for email:', email);
            return res.status(401).json({ message: 'Incorrect password' });
        }

        // Create session
        req.session.userId = user.user_id;
        req.session.userRole = user.user_role;
        console.log(`Login successful for user ID: ${user.user_id}, role: ${user.user_role}`);

        res.json({ message: 'Login successful' });
    } catch (error) {
        console.error('Error in loginUser:', error);
        res.status(500).json({ message: 'Login failed' });
    }
}

export function logoutUser(req, res) {
    req.session.destroy((err) => {
        if (err) {
            return res.status(500).json({ message: 'Failed to log out' });
        }
        res.clearCookie('connect.sid'); // Clears the session cookie
        res.json({ message: 'Logout successful' });
    });
}

export async function getUserDetails(req, res) {
    try {
        const userId = req.session.userId;

        console.log('Fetching user details for user ID:', userId);

        if (!userId) {
            return res.status(401).json({ message: 'Unauthorized' });
        }

        // Retrieve user’s general details from the Users table
        const [userRows] = await pool.query(`
            SELECT user_id, user_name, user_lastname, user_email 
            FROM Users 
            WHERE user_id = ?
        `, [userId]);

        if (userRows.length === 0) {
            return res.status(404).json({ message: 'User not found' });
        }

        const user = userRows[0];
        let role = 'Organisateur'; // Default role is Organizer
        let playerDetails = {};

        // Check if the user is a player by looking for an entry in the Player table
        const [playerRows] = await pool.query(`
            SELECT player_bio, avatar, ranking 
            FROM Player 
            WHERE user_id = ?
        `, [userId]);

        if (playerRows.length > 0) {
            role = 'Joueur'; // Update role if the user is found in the Player table
            const player = playerRows[0];

            // Convert avatar (BLOB) to Base64 if it exists
            const avatarBase64 = player.avatar ? `data:image/png;base64,${Buffer.from(player.avatar).toString('base64')}` : null;

            playerDetails = {
                bio: player.player_bio,
                avatar: avatarBase64,
                ranking: player.ranking
            };
        }

        res.json({
            userId: user.user_id,
            name: user.user_name,
            lastName: user.user_lastname,
            email: user.user_email,
            role,
            ...playerDetails // Spread player details if the user is a player
        });
    } catch (error) {
        console.error('Failed to fetch user details:', error);
        res.status(500).json({ message: 'Server error' });
    }
}
