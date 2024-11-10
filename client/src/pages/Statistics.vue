<template>
  <q-page>
    <div class="wrapper">

      <PieChart
        :series="mostPlayedGames.map(game => game.plays)"
        :labels="mostPlayedGames.map(game => game.name)"
        :image_paths="mostPlayedGames.map(game => game.image_path)"
      />

    </div>
  </q-page>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import PieChart from 'src/components/stats/Piechart.vue';
import { api } from 'src/boot/axios';

const mostPlayedGames = ref([]);

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

onMounted(() => {
  try {
    fetchMostPlayedGames();
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
