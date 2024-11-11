<template>
  <div class="tree-wrapper">
    <div class="title text-h5">{{ name }}</div>
    <div class="tree-container">
      <div v-for="(round, tournamentRound_id) in rounds" :key="tournamentRound_id" class="round">
        <div v-for="(match, match_id) in round.matches" :key="match_id" class="match">
          <div class="match-line">
            <div class="team">
              <span>Team 1</span>
            </div>
            <div class="team">
              <span>Team 2</span>
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
  </style>
