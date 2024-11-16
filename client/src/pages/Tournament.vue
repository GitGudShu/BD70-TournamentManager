<template>
  <q-page>
    <div class="wrapper">
      <div class="text-h3 text-center">Tournois</div>

      <div class="text-subtitle1 text-center welcome-message">
        Découvrez tous nos tournois et rejoignez la compétition !
      </div>

      <div class="text-h5 text-center tournament-section-title">
        Nos Tournois Disponibles
      </div>

      <template v-if="allTournaments && allTournaments.length === 0">
        <Impossible message="Aucun tournoi n'est disponible pour le moment..." />
      </template>

      <template v-else>
        <div class="row">
          <template v-for="tournament in allTournaments" :key="tournament.tournament_id">
            <Card
              :title="tournament.tournament_name"
              :state="getTournamentState(tournament.start_date, tournament.end_date)"
              :dates="`${new Date(tournament.start_date).toLocaleDateString()} - ${new Date(tournament.end_date).toLocaleDateString()}`"
              :xid="tournament.tournament_id"
              :content="`
                Jeu: ${getGameDetails(tournament.game_id).name} <br>
                Participants: ${tournament.nb_participants} <br>
                Type: ${getTournamentType(tournament.tournament_type)}
              `"
              :image="getGameDetails(tournament.game_id).image"
              type="tournament"
              style="max-width: 60%;"
            />
          </template>
        </div>
      </template>

    </div>
  </q-page>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue';
import { api } from 'src/boot/axios';
import Card from 'src/components/Card.vue';

const allTournaments = ref([]);

// Récupérer la liste des tournois
const fetchTournaments = async () => {
  try {
    const response = await api.get('/getTournaments');
    allTournaments.value = response.data;
  } catch (error) {
    console.error("Erreur lors de la récupération des tournois", error);
  }
};

// Obtenir l'état du tournoi
const getTournamentState = (startDate, endDate) => {
  const today = new Date();
  const start = new Date(startDate);
  const end = new Date(endDate);

  if (today < start) return "À venir";
  if (today > end) return "Terminé";
  return "En cours";
};

const upcomingTournaments = computed(() =>
  allTournaments.value.filter(tournament =>
    getTournamentState(tournament.start_date, tournament.end_date) === "À venir"
  )
);

const ongoingTournaments = computed(() =>
  allTournaments.value.filter(tournament =>
    getTournamentState(tournament.start_date, tournament.end_date) === "En cours"
  )
);

const completedTournaments = computed(() =>
  allTournaments.value.filter(tournament =>
    getTournamentState(tournament.start_date, tournament.end_date) === "Terminé"
  )
);

// Obtenir le type de tournoi
const getTournamentType = (typeId) => {
  const tournamentTypes = [
    { label: 'Arbre unique', value: 1 },
    { label: 'Ronde suisse + élimination directe', value: 2 },
    { label: 'Winner/Looser bracket', value: 3 },
    { label: 'Championnat', value: 4 },
    { label: 'Championnat puis playoffs', value: 5 },
    { label: 'Phases de groupes', value: 6 },
  ];
  const type = tournamentTypes.find(t => t.value === typeId);
  return type ? type.label : 'Type inconnu';
};

// Détails des jeux
const getGameDetails = (gameId) => {
  const gameImageMap = {
    1: { name: 'Les échecs', image: '/games/chess.jpg' },
    2: { name: 'Othello', image: '/games/othello.jpg' },
    3: { name: 'Catane', image: '/games/catan.jpg' },
    4: { name: 'Go', image: '/games/go.jpg' },
    5: { name: 'Shogi', image: '/games/shogi.jpg' },
    6: { name: 'Carcassonne', image: '/games/carcassone.jpg' },
    7: { name: 'Puissance 4', image: '/games/connect4.jpg' },
    8: { name: 'Risk', image: '/games/risk.jpg' },
    9: { name: 'Scrabble', image: '/games/scrabble.jpg' },
    10: { name: 'Dames', image: '/games/draughts.jpg' },
  };
  return gameImageMap[gameId] || { name: 'Unknown Game', image: '/placeholder.png' };
};

onMounted(() => {
  fetchTournaments();
});

</script>

<style scoped>
.wrapper {
  display: flex;
  justify-content: center;
  flex-direction: column;
  gap: 1em;
  width: 70%;
  margin: 1em auto;
  background-color: var(--sad-secondary);
  border-radius: .5em;
  padding: 1.5em;
}

.row {
  display: flex;
  flex-direction: row;
  gap: 1em;
  justify-content: space-evenly;
  align-items: center;
}

</style>
