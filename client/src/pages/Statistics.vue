<template>
  <q-page>
    <div class="wrapper">

      <div class="text-h5 graph-title text-bold">Pie chart test</div>
      <PieChart
        :series="mostPlayedGames.map(game => game.plays)"
        :labels="mostPlayedGames.map(game => game.name)"
        :image_paths="mostPlayedGames.map(game => game.image_path)"
      />

      <div class="text-h5 graph-title text-bold">Group chart test</div>
      <MixChart
        :series="playerStats"
        :categories="['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug']"
        :colors="['#9B5DE5', '#D9AFFD', '#8E44AD', '#BB8FCE', '#D0A9F5']"
      />

    </div>
  </q-page>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import PieChart from 'src/components/stats/Piechart.vue';
import MixChart from 'src/components/stats/Mixchart.vue';
import { api } from 'src/boot/axios';

const mostPlayedGames = ref([]);
const playerStats = ref([]);

const fetchMostPlayedGames = async () => {
  try {
    // Test data
    mostPlayedGames.value = [
      { name: 'Go', plays: 44, image_path: 'games/go.jpg' },
      { name: 'Chess', plays: 33, image_path: 'games/chess.jpg' },
      { name: 'Draughts', plays: 54, image_path: 'games/draughts.jpg' },
      { name: 'Shogi', plays: 45, image_path: 'games/shogi.jpg' }
    ];
  } catch (error) {
    console.error("Fetch failed", error);
  }
}

// Fetch data to get player's participation and performance over time
const fetchPlayerParticipationNPerformance = async () => {
  try {
    // Test data
    playerStats.value = [
      {
        name: 'Matches Played',
        type: 'column',
        data: [5, 8, 7, 10, 12, 9, 11, 14],
      },
      {
        name: 'Win Rate',
        type: 'column',
        data: [55, 60, 65, 68, 72, 75, 78, 80],
      },
      {
        name: 'Win Rate',
        type: 'line',
        data: [55, 60, 65, 68, 72, 75, 78, 80],
      },
    ];
    if (!playerStats.value || !playerStats.value.length) {
      console.error('No data found');
    }
  } catch (error) {
    console.error("Fetch failed", error);
  }
}

onMounted(() => {
  try {
    fetchMostPlayedGames();
    fetchPlayerParticipationNPerformance();
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

.graph-title {
  margin-left: 1em;
}

</style>
