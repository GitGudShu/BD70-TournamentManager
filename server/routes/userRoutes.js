import express from 'express';
import multer from 'multer';
import { registerUser, loginUser, logoutUser, getUserDetails, updateUserProfile } from '../controllers/userController.js';

const router = express.Router();
const upload = multer(); // Handle file uploads

router.post('/api/register', upload.single('avatar'), registerUser);
router.post('/api/login', loginUser);
router.post('/api/logout', logoutUser);

router.get('/api/user/details', getUserDetails);
router.put('/api/user/update', upload.single('avatar'), updateUserProfile);

export default router;
