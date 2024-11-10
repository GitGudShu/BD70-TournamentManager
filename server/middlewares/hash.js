import bcrypt from 'bcrypt';

async function hashPassword() {
    const password = 'password';
    const hashedPassword = await bcrypt.hash(password, 10);
    console.log('Hashed password:', hashedPassword);
}

hashPassword().catch(console.error);
