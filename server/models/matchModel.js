import pool from '../config/database.js';

export async function participateInTournament(tournamentId, playerId) {
    try {
        const result = await pool.query(
            'CALL ParticipateInTournament(?, ?)', [tournamentId, playerId]
        );
        return { success: true, message: 'Participation enregistrée' };
    } catch (error) {
        console.error("Erreur lors de la participation au tournoi:", error);
        throw error; // Propager l'erreur pour la gérer dans le contrôleur
    }
}