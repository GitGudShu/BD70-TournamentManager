<template>
  <div class="tree-wrapper">
    <div class="title text-h5">{{ name }}</div>
    <div class="tree-container">
      <div v-for="(round, roundIndex) in reactiveRounds" :key="roundIndex" class="round">
        <div v-for="(match, matchIndex) in round.matchs" :key="match.id" class="match">
          <div class="match-container">
            <div class="match-line">
              <div class="team" :class="{ 'winner': match.winner === match.team1.id }">
                <span>{{ match.team1.name }}</span>
                <input
                  v-model.number="match.team1.score"
                  class="score-input"
                  type="number"
                  min="0"
                  :disabled="roundIndex + 1 !== activeRound"
                />
              </div>
              <div class="team" :class="{ 'winner': match.winner === match.team2.id }">
                <span>{{ match.team2.name }}</span>
                <input
                  v-model.number="match.team2.score"
                  class="score-input"
                  type="number"
                  min="0"
                  :disabled="roundIndex + 1 !== activeRound"
                />
              </div>
            </div>
            <q-btn
              :disabled="roundIndex + 1 !== activeRound"
              class="update-winner-button"
              icon="check"
              size="sm"
              @click="updateWinner(match, roundIndex)"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, watch, onMounted } from 'vue';
import { api } from 'src/boot/axios';

const props = defineProps({
  name: String,
  rounds: {
    type: Array,
    required: true,
  },
});

const activeRound = ref(1);
const reactiveRounds = reactive(JSON.parse(JSON.stringify(props.rounds)));

const emit = defineEmits(['requestRoundsUpdate']);

// Watch for changes in the rounds prop
watch(
  () => props.rounds,
  (newRounds) => {
    // Update reactiveRounds with the new schema
    reactiveRounds.splice(0, reactiveRounds.length, ...JSON.parse(JSON.stringify(newRounds)));
    console.log('reactiveRounds updated:', reactiveRounds);
  },
  { deep: true } // Ensures nested changes are tracked
);

const requestRoundsUpdate = () => {
  emit('requestRoundsUpdate'); // Emit the event to the parent file using the component
};

const updateWinner = (match, roundIndex, skipApiUpdate = false) => {
  if (match.team1.score > match.team2.score) {
    match.winner = match.team1.id;
  } else if (match.team2.score > match.team1.score) {
    match.winner = match.team2.id;
  } else {
    match.winner = null;
  }

  // Skip API call if it's during initialization
  if (!skipApiUpdate) {
    updateScore(match, roundIndex).then(() => {
      requestRoundsUpdate();
    });
  }

  // Check if all matches are complete
  const allMatchesComplete = reactiveRounds[roundIndex].matchs.every(m => m.winner !== null);

  // Enable the next round if all matches are complete
  if (allMatchesComplete && roundIndex + 1 === activeRound.value) {
    activeRound.value += 1;
  }
};

const updateScore = async (match) => {
  try {
    const payload = {
      matchId: match.id,
      team1: {
        playerId: match.team1.id,
        score: match.team1.score,
      },
      team2: {
        playerId: match.team2.id,
        score: match.team2.score,
      },
    };

    console.log('Payload (scores) :', payload);
    const response = await api.post('/update-match-score', payload);

    if (response.status === 200) {
      console.log('Scores updated successfully!');
    }
  } catch (error) {
    console.error('Error updating match score:', error);
  }
};

const initializeWinners = () => {
  reactiveRounds.forEach((round, roundIndex) => {
    round.matchs.forEach((match) => {
      if (match.team1.score != null && match.team2.score != null) {
        updateWinner(match, roundIndex, true);
      }
    });
  });
};

onMounted(() => {
  initializeWinners();
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

.match-container {
  display: flex;
  flex-direction: row;
  gap: 1em;
  align-items: center;
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
  align-items: center;
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

.score-input {
  width: 3em;
  text-align: center;
  margin-left: 1em;
  background-color: #dddddd;
}

.update-winner-button {
  padding: 0.5em 1em;
  background-color: var(--sad-orange);
  border: none;
  color: white;
  border-radius: 5px;
  cursor: pointer;
  height: 2em;
}
.update-winner-button:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}
</style>
