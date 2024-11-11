<template>
  <q-page>
    <div class="wrapper">

      <div class="text-h3 text-center">Bienvenue</div>

      <div class="text-subtitle1 text-center welcome-message">
        Découvrez un monde de compétitions palpitantes ! Participez à des tournois de vos jeux préférés et mesurez-vous aux autres passionnés de jeux de société. Rejoignez-nous pour des moments inoubliables et des défis captivants !
      </div>

      <div class="button-container text-center">
        <q-btn label="Voir les tournois" color="primary" @click="redirectToTournaments" />
      </div>

      <div class="text-h5 text-center game-section-title">
        Nos jeux disponibles
      </div>

      <div class="row">
        <template v-for="game in allGames" :key="game.game_id">
          <Card
            :title="game.game_name"
            state="En cours..."
            :content="game.game_rules"
            :image="getImagePath(game.game_name)"
          />
        </template>
      </div>

    </div>
  </q-page>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import { api } from 'src/boot/axios';
import Card from 'src/components/Card.vue';
import { useRouter } from 'vue-router';

const router = useRouter();

const allGames = ref([]);

// Mapping game names to image paths
const gameImageMap = {
  'Les échecs': '/games/chess.jpg',
  'Othello': '/games/othello.jpg',
  'Catane': '/games/catan.jpg',
  'Go': '/games/go.jpg',
  'Shogi': '/games/shogi.jpg',
  'Carcassonne': '/games/carcassone.jpg',
  'Puissance 4': '/games/connect4.jpg',
  'Risk': '/games/risk.jpg',
  'Scrabble': '/games/scrabble.jpg',
  'Dames': '/games/draughts.jpg',
};

const getImagePath = (gameName) => {
  return gameImageMap[gameName] || '/path/to/default-image.jpg'; // Replace with a default image path if necessary
};

const fetchGames = async () => {
  try {
    const response = await api.get('/games');
    allGames.value = response.data;
    // console.log(allGames.value);
  } catch (error) {
    console.error("Fetch games failed", error);
  }
};

const redirectToTournaments = () => {
  router.push('/tournament');
};

onMounted(() => {
  try {
    fetchGames();
  }
  catch (error) {
    console.log(error);
  }
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
</style>
