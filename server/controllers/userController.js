import { createUserWithPlayer } from '../models/userModel.js';

export async function registerUser(req, res) {
    try {
        const { userName, userLastname, email, password, playerBio } = req.body;
        const avatar = req.file ? req.file.buffer : null; // Handle avatar file upload (if any)

        const userId = await createUserWithPlayer({
            userName,
            userLastname,
            email,
            password,
            playerBio,
            avatar
        });

        res.status(201).json({ userId });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to create user and player (boo)' });
    }
}
