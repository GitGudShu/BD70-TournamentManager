<template>
    <q-page>
      <div class="wrapper">
        <div class="text-h3 text-center">Tournois</div>

        <div class="text-subtitle1 text-center welcome-message">
          Découvrez tous nos tournois et rejoignez la compétition !
        </div>

        <div class="text-h5 text-center tournament-section-title">
          Nos Tournois Disponibles
        </div>

        <div class="row">
          <template v-for="tournament in allTournaments" :key="tournament.tournament_id">
            <q-card
              class="my-card"
              :flat="true"
              :bordered="true"
            >
              <q-card-section>
                <div class="text-h6">{{ tournament.tournament_name }}</div>
                <div class="text-subtitle2">{{ getTournamentType(tournament.tournament_type) }}</div>
                <div class="text-body1">Participants: {{ tournament.nb_participants }}</div>
                <div class="text-body2">
                  <strong>Dates:</strong>
                  {{ new Date(tournament.start_date).toLocaleDateString() }} -
                  {{ new Date(tournament.end_date).toLocaleDateString() }}
                </div>
                <div class="text-body2">
                  <strong>Status:</strong> {{ getTournamentState(tournament.start_date, tournament.end_date) }}
                </div>
              </q-card-section>

              <q-card-actions>
                <q-btn
                  flat
                  label="Voir les détails"
                  @click="goToTournamentDetails(tournament.tournament_id)"
                />
              </q-card-actions>
            </q-card>
          </template>
        </div>
      </div>
    </q-page>
  </template>

<script setup>
import { onMounted, ref } from 'vue';
import { api } from 'src/boot/axios';
import { useRouter } from 'vue-router';

const router = useRouter();
const allTournaments = ref([]);

const tournamentTypes = [
  { label: 'Arbre unique', value: 1 },
  { label: 'Ronde suisse + élimination directe', value: 2 },
  { label: 'Winner/Looser bracket', value: 3 },
  { label: 'Championnat', value: 4 },
  { label: 'Championnat puis playoffs', value: 5 },
  { label: 'Phases de groupes', value: 6 },
];

const fetchTournaments = async () => {
  try {
    const response = await api.get('/getTournaments');
    allTournaments.value = response.data;
    // console.log(allTournaments.value);
  } catch (error) {
    console.error("Fetch tournaments failed", error);
  }
};

const getTournamentState = (startDate, endDate) => {
  const today = new Date();
  const start = new Date(startDate);
  const end = new Date(endDate);

  if (today < start) return "À venir";
  if (today > end) return "Terminé";
  return "En cours";
};

const getTournamentType = (typeId) => {
  const type = tournamentTypes.find(t => t.value === typeId);
  return type ? type.label : 'Type inconnu';
};

const goToTournamentDetails = (tournamentId) => {
  // console.log(tournamentId)
  router.push(`/tournament/${tournamentId}`);
};

onMounted(() => {
  fetchTournaments();
});
</script>

  <style scoped>
  .logo {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 300px;
  }

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
