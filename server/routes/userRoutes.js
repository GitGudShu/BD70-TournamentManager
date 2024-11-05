import express from 'express';
import multer from 'multer';
import { registerUser } from '../controllers/userController.js';

const router = express.Router();
const upload = multer(); // Handle file uploads

router.post('/api/register', upload.single('avatar'), registerUser);

export default router;
