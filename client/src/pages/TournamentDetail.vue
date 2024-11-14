<template>
<q-page>
  <div class="wrapper">
    <div class="text-h3 text-center">Détails du tournoi</div>

    <div v-if="tournament" class="q-mb-md">
      <div class="text-h6">{{ tournament.tournament_name }}</div>
      <div class="text-subtitle1">
        Type : {{ getTournamentType(tournament.tournament_type) }}<br />
        Date de début : {{ tournament.start_date }}<br />
        Date de fin : {{ tournament.end_date }}<br />
        Nombre de participants : {{ tournament.nb_participants }}<br />
        Nombre d'équipes en playoff : {{ tournament.playoffTeams }}<br />
      </div>

      <TournamentTreeEdit
        v-if="tournament && tournament.rounds"
        :name="tournament.tournament_name"
        :rounds="tournament.rounds"
      />

      <TTP
        v-if="tournament && tournament.rounds"
        :name="tournament.tournament_name"
        :rounds="roundsTest"
      />


      <!-- <div v-for="round in tournament.rounds" :key="round.tournamentRound_id">
        <div class="text-h6">{{ getRoundName(round.round, tournament.rounds.length) }} - Section {{ round.section }}</div>

        <div v-if="round.matches.length > 0">
          <div v-for="match in round.matches" :key="match.match_id" class="q-mb-md">
          <q-card>
              <q-card-section>
              <div class="text-h6">Match ID: {{ match.match_id }}</div>
              <div>Date : {{ match.match_date }}</div>
              <div>Location : {{ match.location }}</div>
              <div>Status : {{ match.status }}</div>
              </q-card-section>
          </q-card>
          </div>
        </div>

        <div v-else>
            <div class="text-body1">Aucun match pour ce round.</div>
        </div>
      </div> -->

    </div>
    <div v-else>
        <q-spinner color="primary" />
    </div>
  </div>
</q-page>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import { api } from 'src/boot/axios';
import { useRoute, useRouter } from 'vue-router';
import TournamentTreeEdit from 'src/components/TournamentTreeEdit.vue';
import TTP from 'src/components/TournamentTreeProgress.vue';

const route = useRoute();
const router = useRouter();

const tournament = ref(null);

const tournamentTypes = [
    { label: 'Arbre unique', value: 1 },
    { label: 'Ronde suisse + élimination directe', value: 2 },
    { label: 'Winner/Looser bracket', value: 3 },
    { label: 'Championnat', value: 4 },
    { label: 'Championnat puis playoffs', value: 5 },
    { label: 'Phases de groupes', value: 6 },
];

const getRoundName = (roundNumber, totalRounds) => {
    const totalParticipants = tournament.value?.nb_participants || 0;
    const participantsInThisRound = totalParticipants / Math.pow(2, roundNumber - 1);

    if (participantsInThisRound >= 16) {
        return `${participantsInThisRound}èmes de finale`;
    } else if (participantsInThisRound === 8) {
        return "Quarts de finale";
    } else if (participantsInThisRound === 4) {
        return "Demi-finale";
    } else if (participantsInThisRound === 2) {
        return "Finale";
    } else {
        return `Round ${roundNumber}`;
    }
};


const getTournamentType = (typeId) => {
    const type = tournamentTypes.find(t => t.value === typeId);
    return type ? type.label : 'Type inconnu';
};

const fetchTournamentDetails = async () => {
    const tournamentId = route.params.tournamentId;
    try {
        const response = await api.get(`/getTournaments/${tournamentId}`);
        tournament.value = response.data;
        console.log("Fetched Tournament:", tournament.value);
        console.log("Rounds:", tournament.value.rounds);
    } catch (error) {
        console.error("Failed to fetch tournament details:", error);
    }
};

const roundsTest = [
  {
    matchs: [
      {
        id: 1,
        team1: { id: 1, name: "Team A", score: null },
        team2: { id: 2, name: "Team B", score: null },
        winner: null,
      },
      {
        id: 2,
        team1: { id: 3, name: "Team C", score: null },
        team2: { id: 4, name: "Team D", score: null },
        winner: null,
      },
    ],
  },
  {
    matchs: [
      {
        id: 3,
        team1: { id: 1, name: "Winner of Match 1", score: null },
        team2: { id: 3, name: "Winner of Match 2", score: null },
        winner: null,
      },
    ],
  },
];

onMounted(() => {
fetchTournamentDetails();
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
