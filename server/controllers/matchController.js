import { participateInTournament } from '../models/matchModel.js'; // Importation depuis le modèle

export const handleParticipateInTournament = async (req, res) => {
    const { tournamentId, playerId } = req.params; // Récupérer les paramètres de l'URL

    try {
        // Appel de la fonction qui gère la participation
        const result = await participateInTournament(tournamentId, playerId);

        // Envoie la réponse si la participation est enregistrée avec succès
        res.status(200).json(result);
    } catch (error) {
        console.error("Erreur lors de la participation:", error);
        
        // Envoie une réponse d'erreur si quelque chose a échoué
        res.status(500).json({ success: false, message: "Erreur lors de la participation au tournoi" });
    }
};