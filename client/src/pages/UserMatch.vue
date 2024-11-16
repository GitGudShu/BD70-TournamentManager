<template>
  <q-page>
    <div class="wrapper">

      <div class="text-h3 text-center">Mes tournois</div>
      <div class="text-subtitle1 text-center welcome-message">
        Découvrez les détails des tournois auxquels vous participez !
      </div>

      <template v-if="yourTournaments && yourTournaments.length === 0">
        <div class="huh">
          <img src="nothing.png" alt="confused cat" class="huh-img">
          <div class="huh-message text-primary">Tu ne t'es inscrit à aucun tournoi, meow...</div>
        </div>
      </template>
      <template v-else>

        <div class="row">
          <template v-for="tournament in yourTournaments" :key="tournament.tournament_id">
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
              type="tournament-details"
              style="max-width: 50%;"
            />
          </template>
        </div>

      </template>

    </div>
  </q-page>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import { api } from 'src/boot/axios';
import { useRouter } from 'vue-router';
import Card from 'src/components/Card.vue';

const router = useRouter();
const yourTournaments = ref([]);

const tournamentTypes = [
  { label: 'Arbre unique', value: 1 },
  { label: 'Ronde suisse + élimination directe', value: 2 },
  { label: 'Winner/Looser bracket', value: 3 },
  { label: 'Championnat', value: 4 },
  { label: 'Championnat puis playoffs', value: 5 },
  { label: 'Phases de groupes', value: 6 },
];

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

const fetchTournaments = async () => {
  try {
    const response = await api.get('/getTournaments');
    yourTournaments.value = response.data;
    console.log(yourTournaments.value);
  } catch (error) {
    console.error("Fetch tournaments failed", error);
  }
};

const getTournamentState = (startDate, endDate) => {
const today = new Date();
const start = new Date(startDate);
const end = new Date(endDate);

if (today < start) return "À venir";
if (today > end) return "Terminé";
return "En cours";
};

const getTournamentType = (typeId) => {
const type = tournamentTypes.find(t => t.value === typeId);
  return type ? type.label : 'Type inconnu';
};

const goToTournamentDetails = (tournamentId) => {
  // console.log(tournamentId)
  router.push(`/tournament/${tournamentId}`);
};

onMounted(() => {
  fetchTournaments();
});
</script>

<style scoped>
.logo {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 300px;
}

.wrapper {
  display: flex;
  justify-content: center;
  flex-direction: column;
  gap: 1em;
  width: 70%;
  margin: 1em auto;
  height: 100%;
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

/* HUH Image */

.huh {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 2em;
}

.huh-img {
  height: 200px;
}

.huh-message {
  margin-left: 1em;
  border: .2em solid var(--sad-nightblue);
  border-radius: .5em;
  padding: 1em;
  background-color: aliceblue;
  max-width: 200px;
}
</style>
