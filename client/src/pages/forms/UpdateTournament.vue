<template>
    <q-page>
      <div class="wrapper">
        <div class="text-h4 text-center text-primary text-bold">ÉDITER UN TOURNOI</div>

        <q-form @submit="updateTournament">
            <q-input v-model="tournamentName" label="Nom du tournoi" outlined dense required />

            <q-select
                v-model="selectedGame"
                :options="allGames.map(game => ({ label: game.game_name, value: game.game_id }))"
                label="Jeu"
                outlined
                dense
                required
            />

            <q-select
                v-model="selectedTournamentType"
                :options="tournamentTypes"
                label="Type de tournoi"
                outlined dense required
                @update:model-value="onTournamentTypeChange"
            />

            <q-input
                v-model.number="participantCount"
                type="number"
                label="Nombre de participants"
                outlined dense required
                :rules="participantRules"
            />

            <q-input
                v-if="requiresPlayoffTeams"
                v-model.number="playoffTeams"
                type="number"
                label="Nombres d'équipes/joueurs qualifiées pour les playoffs"
                outlined dense
                :rules="[isPowerOfTwo, val => val <= participantCount || 'Doit être inférieur au nombre de participants']"
            />

            <q-input
                v-model="startDate"
                type="date"
                label="Date de début"
                outlined dense required
                :rules="[val => val ? true : 'Veuillez sélectionner une date de début']"
            />

            <q-input
                v-model="endDate"
                type="date"
                label="Date de fin"
                outlined dense required
                :rules="[val => val ? true : 'Veuillez sélectionner une date de fin', val => new Date(val) >= new Date(startDate) || 'La date de fin doit être postérieure à la date de début']"
            />

            <q-btn type="submit" label="Mettre à jour le tournoi" color="primary" />
        </q-form>
      </div>
    </q-page>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { api } from 'src/boot/axios';
import { useRoute, useRouter } from 'vue-router';
import { useAuthStore } from 'src/stores/authStore';

const route = useRoute();
const router = useRouter();

const tournamentName = ref('');
const selectedTournamentType = ref(null);
const participantCount = ref(null);
const playoffTeams = ref(null);
const startDate = ref('');
const endDate = ref('');
const selectedGame = ref(null);

const authStore = useAuthStore();
const organizerId = computed(() => authStore.organizerId);

const tournamentTypes = [
  { label: 'Arbre unique', value: 1 },
  { label: 'Ronde suisse + élimination directe', value: 2 },
  { label: 'Winner/Looser bracket', value: 3 },
  { label: 'Championnat', value: 4 },
  { label: 'Championnat puis playoffs', value: 5 },
  { label: 'Phases de groupes', value: 6 },
];

const allGames = ref([]);
const fetchGames = async () => {
  try {
    const response = await api.get('/games');
    allGames.value = response.data;
  } catch (error) {
    console.error("Fetch games failed", error);
  }
};

onMounted(() => {
  fetchGames();
  fetchTournamentDetails(); 
});

const tournamentDetails = ref(null);

const fetchTournamentDetails = async () => {
  const tournamentId = route.params.tournamentId;  
  try {
    const response = await api.get(`/getTournaments/${tournamentId}`);
    tournamentDetails.value = response.data;

    tournamentName.value = tournamentDetails.value.tournament_name;
    selectedTournamentType.value = tournamentTypes.find(t => t.value === tournamentDetails.value.tournament_type);
    participantCount.value = tournamentDetails.value.nb_participants;
    playoffTeams.value = tournamentDetails.value.playoffTeams || null;
    startDate.value = tournamentDetails.value.start_date.split('T')[0];
    console.log(startDate.value)
    endDate.value = tournamentDetails.value.start_date.split('T')[0];
    selectedGame.value = tournamentDetails.value.game_id;
  } catch (error) {
    console.error("Failed to fetch tournament details:", error);
  }
};

const updateTournament = async () => {
  const tournamentData = {
    tournamentId: parseInt(route.params.tournamentId, 10),
    tournament_name: tournamentName.value,
    tournament_type: selectedTournamentType.value.value,
    start_date: startDate.value,
    end_date: endDate.value,
    nb_participants: participantCount.value,
    playoffTeams: playoffTeams.value || null,
    game_id: selectedGame.value,
    organizer_id: organizerId.value,
  };

  try {
    const tournamentId = route.params.tournamentId;
    console.log(tournamentData);
    const response = await api.put(`/tournaments/${tournamentId}`, tournamentData);
    console.log('Tournoi mis à jour avec succès', response.data);
    router.push('/tournament');
  } catch (error) {
    console.error('Erreur lors de la mise à jour du tournoi', error);
  }
};

const requiresPlayoffTeams = ref(false);
function onTournamentTypeChange(value) {
  requiresPlayoffTeams.value = value.value === 5;
  if (!requiresPlayoffTeams.value) {
    playoffTeams.value = null;
  }
}

function isPowerOfTwo(val) {
  return (val & (val - 1)) === 0 ? true : 'Doit être une puissance de 2';
}

const typesRequiringPowerOfTwo = [1, 2, 6];
const participantRules = computed(() => {
  const rules = [
    val => val > 1 || 'Doit être supérieur à 1'
  ];

  if (selectedTournamentType.value && typesRequiringPowerOfTwo.includes(selectedTournamentType.value.value)) {
    rules.push(isPowerOfTwo);
  }
  return rules;
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
</style>