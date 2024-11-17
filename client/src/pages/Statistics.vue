<template>
  <q-page>
    <div class="wrapper">

      <div class="text-h4 graph-title text-bold">Les jeux populaires !</div>
      <PieChart
        :series="mostPlayedGames.map(game => game.plays)"
        :labels="mostPlayedGames.map(game => game.name)"
        :image_paths="mostPlayedGames.map(game => game.image_path)"
      />

      <div class="text-h4 graph-title text-bold">Historique récent de vos parties, {{ userName }} !</div>
      <MixChart
        v-if="playerStats.length"
        :series="playerStats"
        :categories="playerStatsCategories"
        :colors="['#9B5DE5', '#D9AFFD', '#8E44AD', '#BB8FCE', '#D0A9F5']"
      />

    </div>
  </q-page>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue';
import PieChart from 'src/components/stats/Piechart.vue';
import MixChart from 'src/components/stats/Mixchart.vue';
import { useAuthStore } from 'src/stores/authStore';
import { api } from 'src/boot/axios';

const authStore = useAuthStore();
const userName = computed(() => authStore.userName);
const playerId = computed(() => authStore.playerId);

const mostPlayedGames = ref([]);
const playerStats = ref([]);
const playerStatsCategories = ref([]);

const fetchMostPlayedGames = async () => {
  try {
    const response = await api.get('/popular-games');
    mostPlayedGames.value = response.data;
  } catch (error) {
    console.error("Fetch failed", error);
  }
}

// Fetch data to get player's participation and performance over time
const fetchPlayerParticipationNPerformance = async () => {
  try {
    const response = await api.get(`/player-stats/${playerId.value}`);
    playerStatsCategories.value = response.data.months;
    playerStats.value = [
      {
        name: 'Matchs joués',
        type: 'column',
        data: response.data.matchesPlayed,
      },
      {
        name: 'Matchs gagnés',
        type: 'column',
        data: response.data.matchesWon,
      },
      {
        name: 'Meilleur joueur',
        type: 'line',
        data: response.data.topPlayerMatchesWon,
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
