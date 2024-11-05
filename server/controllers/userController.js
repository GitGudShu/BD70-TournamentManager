import bcrypt from 'bcrypt';
import { createUserWithPlayer, findUserByEmail } from '../models/userModel.js';

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
