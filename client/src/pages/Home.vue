<template>
  <q-page>
    <div class="wrapper">

      <!-- Here's an example of how you can use the cards :) -->
      <!-- <div class="row">
        <Card title="Card 1" state="En cours..." />
        <Card title="Card 1" state="En cours..." />
      </div> -->

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


const allGames = ref([]);

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
}

.row {
  display: flex;
  flex-direction: row;
  gap: 1em;
  justify-content: space-evenly;
  align-items: center;
}

</style>
