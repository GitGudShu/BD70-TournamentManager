<template>
  <div class="tree-wrapper">
    <div class="title text-h5">{{ name }}</div>
    <div class="tree-container">
      <div v-for="(round, roundIndex) in rounds" :key="roundIndex" class="round">
        <div v-for="match in round.matchs" :key="match.id" class="match">
          <div class="match-line">
            <div class="team" :class="{ 'winner': match.winner === match.team1.id }">
              <span>{{ match.team1.name }}</span>
              <span :class="{ 'score-winner': match.winner === match.team1.id, 'score-looser': match.winner !== match.team1.id }">{{ match.team1.score }}</span>
            </div>
            <div class="team" :class="{ 'winner': match.winner === match.team2.id }">
              <span>{{ match.team2.name }}</span>
              <span :class="{ 'score-winner': match.winner === match.team2.id, 'score-looser': match.winner !== match.team2.id }">{{ match.team2.score }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  </template>

  <script setup>
  const props = defineProps({
    name: String,
    rounds: {
      type: Array,
      required: true,
    },
  });

  console.log(props.rounds[1]);
  console.log(props.rounds[2]);
  </script>

  <style scoped>
  .tree-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    padding: 2em;
  }

  .title {
    text-align: center;
    background-color: var(--sad-nightblue);
    padding: .2em 1em;
    color: white;
    border-radius: 5px 5px 0 0;
  }

  .tree-container {
    display: flex;
    gap: 20px;
    background-color: #6d6085;
    justify-content: space-around;
    padding: 2em;
    border-radius: 5px;
    border: .5em solid var(--sad-nightblue);
  }

  .round {
    display: flex;
    flex-direction: column;
    gap: 2em;
    justify-content: space-around;
  }

  .team {
    display: flex;
    justify-content: space-between;
    padding: 0.5em 1em;
    border-radius: 5px;
    background-color: #f5f5f5;
    border: 1.5px solid #e0e0e0;
  }

  .score-winner {
    margin-left: 1em;
    background-color: var(--sad-orange);
    padding: 0 .5em;
    border-radius: 5px;
  }

  .score-looser {
    margin-left: 1em;
    background-color: var(--sad-nightblue);
    padding: 0 .5em;
    border-radius: 5px;
    color: white;
  }

  .winner {
    font-weight: bold;
    background-color: var(--sad-nightblue);
    color: white;
  }

  </style>
