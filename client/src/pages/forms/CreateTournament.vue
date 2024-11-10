<template>
    <div class="tournament-creation-wrapper">
      <h1 class="title text-h5">Créer un Tournoi</h1>
      <form @submit.prevent="createTournament">
        <div class="form-group">
          <label for="tournament_name">Nom du Tournoi</label>
          <input type="text" id="tournament_name" v-model="tournament.tournament_name" required />
        </div>
  
        <div class="form-group">
          <label for="tournament_type">Type de Tournoi</label>
          <select id="tournament_type" v-model="tournament.tournament_type" @change="onTypeChange">
            <option value="1">Arbre unique</option>
            <option value="2">Ronde suisse puis élimination directe</option>
            <option value="3">Winner et Looser Bracket</option>
            <option value="4">Championnat</option>
            <option value="5">Championnat avec Playoffs</option>
          </select>
        </div>
  
        <div class="form-group">
          <label for="start_date">Date de début</label>
          <input type="date" id="start_date" v-model="tournament.start_date" required />
        </div>
  
        <div class="form-group">
          <label for="end_date">Date de fin</label>
          <input type="date" id="end_date" v-model="tournament.end_date" required />
        </div>
  
        <div class="form-group">
          <label for="game_id">Jeu</label>
          <select id="game_id" v-model="tournament.game_id">
            <option v-for="game in games" :key="game.game_id" :value="game.game_id">
              {{ game.name }}
            </option>
          </select>
        </div>  
        <button type="submit" class="submit-button">Créer le Tournoi</button>
      </form>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  
  const tournament = ref({
    tournament_name: '',
    tournament_type: 1,
    start_date: '',
    end_date: '',
    game_id: null,
  });
  
  const games = ref([
    { game_id: 1, name: 'Football' },
    { game_id: 2, name: 'Basketball' },
    { game_id: 3, name: 'Tennis' },
    // ajouter d'autres jeux au besoin
  ]);
  
  const roundSwissSettings = ref({
    rounds_count: 3,
  });
  
  const doubleBracketSettings = ref({
    bracket_format: 'double',
  });
  
  const championshipSettings = ref({
    teams_count: 8,
  });
  
  const playoffsSettings = ref({
    format: 'knockout',
  });
  
  function onTypeChange() {
    // Réinitialiser les paramètres spécifiques en fonction du type de tournoi choisi
    if (tournament.value.tournament_type === 2) {
      roundSwissSettings.value.rounds_count = 3;
    } else if (tournament.value.tournament_type === 3) {
      doubleBracketSettings.value.bracket_format = 'double';
    } else if (tournament.value.tournament_type === 4) {
      championshipSettings.value.teams_count = 8;
    } else if (tournament.value.tournament_type === 5) {
      playoffsSettings.value.format = 'knockout';
    }
  }
  
  function createTournament() {
    // Logique pour envoyer les données du tournoi au backend pour sauvegarde dans la BDD
    console.log('Tournoi créé avec les informations:', tournament.value);
  }
  </script>
  
  <style scoped>
  .tournament-creation-wrapper {
    max-width: 600px;
    margin: 0 auto;
    padding: 2em;
    background-color: #f5f5f5;
    border-radius: 8px;
  }
  
  .title {
    text-align: center;
    margin-bottom: 1em;
  }
  
  .form-group {
    margin-bottom: 1.5em;
  }
  
  label {
    display: block;
    font-weight: bold;
    margin-bottom: 0.5em;
  }
  
  input,
  select {
    width: 100%;
    padding: 0.5em;
    font-size: 1em;
    border-radius: 4px;
    border: 1px solid #ddd;
  }
  
  button.submit-button {
    width: 100%;
    padding: 0.75em;
    font-size: 1.1em;
    background-color: var(--sad-nightblue);
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }
  
  button.submit-button:hover {
    background-color: #4a4a7d;
  }
  
  .special-settings {
    margin-top: 1em;
    padding: 1em;
    background-color: #f0f0f8;
    border: 1px solid #ddd;
    border-radius: 4px;
  }
  </style>  