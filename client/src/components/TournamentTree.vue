<template>
  <div class="tree-wrapper">
    <div class="title text-h5">{{ name }}</div>
    <div class="tree-container">
      <div v-for="(round, roundIndex) in rounds" :key="roundIndex" class="round">
        <div v-for="match in round.matchs" :key="match.id" class="match">
          <div class="match-line">
            <!-- Team 1 -->
            <div
              class="team"
              :class="{
                'winner': match.winner === 'player1',
                'not-set': match.team1.name === 'Non attribué'
              }"
            >
              <span>{{ match.team1.name }}</span>
              <span
                :class="{
                  'score-winner': match.winner === 'player1',
                  'score-looser': match.winner !== 'player1',
                  'score-not-set': match.team1.name === 'Non attribué' || match.team1.score === null
                }"
              >
                {{ match.team1.score }}
              </span>
            </div>

            <!-- Team 2 -->
            <div
              class="team"
              :class="{
                'winner': match.winner === 'player2',
                'not-set': match.team2.name === 'Non attribué'
              }"
            >
              <span>{{ match.team2.name }}</span>
              <span
                :class="{
                  'score-winner': match.winner === 'player2',
                  'score-looser': match.winner !== 'player2',
                  'score-not-set': match.team2.name === 'Non attribué' || match.team2.score === null
                }"
              >
                {{ match.team2.score }}
              </span>
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

.not-set {
  background-color: #d3d3d3 !important; /* Light grey background */
  color: #a0a0a0; /* Grey text */
}

.score-not-set {
  background-color: #d3d3d3 !important; /* Light grey background */
}
</style>
