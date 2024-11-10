<template>
  <q-page>
    <div class="wrapper">

      <div class="text-h4 text-center text-primary text-bold">TOURNOIS</div>

      <div class="tree-container">
        <TournamentTree name="Tournoi de test" :rounds="testRounds"/>
      </div>

      <div class="row">
        <template v-for="game in allGames">
          <Card :title="game.game_name" state="En cours..." :content="game.game_rules"/>
        </template>
      </div>

    </div>
  </q-page>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import { api } from 'src/boot/axios';
import Card from 'src/components/Card.vue';
import TournamentTree from 'src/components/TournamentTree.vue';

const allGames = ref([]);
const testRounds = [
//Quarter
  {
    matchs: [
      {
        id: "match1",
        winner: "1",
        team1: { id: "1", name: "Competitor 1", score: 2 },
        team2: { id: "2", name: "Competitor 2", score: 1 },
      },
      {
        id: "match2",
        winner: "4",
        team1: { id: "3", name: "Competitor 3", score: 0 },
        team2: { id: "4", name: "Competitor 4", score: 2 },
      },
      {
        id: "match3",
        winner: "5",
        team1: { id: "5", name: "Competitor 5", score: 2 },
        team2: { id: "6", name: "Competitor 6", score: 1 },
      },
      {
        id: "match4",
        winner: "8",
        team1: { id: "7", name: "Competitor 7", score: 0 },
        team2: { id: "8", name: "Competitor 8", score: 2 },
      },
    ],
  },
  //Semi
  {
    matchs: [
      {
        id: "match5",
        winner: "4",
        team1: { id: "1", name: "Competitor 1", score: 1 },
        team2: { id: "4", name: "Competitor 4", score: 2 },
      },
      {
        id: "match6",
        winner: "8",
        team1: { id: "5", name: "Competitor 5", score: 1 },
        team2: { id: "8", name: "Competitor 8", score: 2 },
      },
    ],
  },
  //Final
  {
    matchs: [
      {
        id: "any_match_id",
        winner: "8",
        team1: { id: "4", name: "Competitor 4", score: 1 },
        team2: { id: "8", name: "Competitor 8", score: 3 },
      },
    ],
  },
];

const fetchGames = async () => {
  try {
    const response = await api.get('/games');
    allGames.value = response.data;
    console.log(allGames.value);
  } catch (error) {
    console.error("Fetch games failed", error);
  }
}

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
