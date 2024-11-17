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


      <template v-if="userRole == 'Organisateur'">
        <div class="tournament-actions">
          <button @click="editTournament" class="btn-edit-tournament">
            Edit Tournament
          </button>

          <!-- Bouton Delete Tournament -->
          <button @click="deleteTournament" class="btn-delete-tournament">
            Delete Tournament
          </button>
        </div>
        <TTP
          v-if="rounds_mapped"
          :name="tournament.tournament_name"
          :xid="tournament.tournament_id"
          :rounds="rounds_mapped"
          @request-rounds-update="fetchMatchDetails"
        />
      </template>
      <template v-else>
        <Tree
          v-if="rounds_mapped"
          :name="tournament.tournament_name"
          :rounds="rounds_mapped"
        />
      </template>

      <Table
        v-if="rounds_mapped"
        :columns="rankingColumns"
        :rows="rankingData"
        title="Classement du tournoi"
      />

    </div>
    <div v-else>
        <q-spinner color="primary" />
    </div>
  </div>
</q-page>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue';
import { api } from 'src/boot/axios';
import { useRoute, useRouter } from 'vue-router';
import TTP from 'src/components/TournamentTreeProgress.vue';
import Tree from 'src/components/TournamentTree.vue';
import Table from 'src/components/Ranking.vue';
import { useAuthStore } from 'src/stores/authStore';

const route = useRoute();
const router = useRouter();

const authStore = useAuthStore();
const userRole = computed(() => authStore.userRole);

const tournament = ref(null);
const rounds_mapped = ref(null);

const tournamentTypes = [
    { label: 'Arbre unique', value: 1 },
    { label: 'Championnat', value: 2 },
    { label: 'Championnat puis playoffs', value: 3 },
    { label: 'Swiss stage', value: 4 },
    { label: 'Winner/Looser bracket', value: 5 },
    { label: 'Phases de groupes', value: 6 },
];


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
        // console.log("Rounds:", tournament.value.rounds);
    } catch (error) {
        console.error("Failed to fetch tournament details:", error);
    }
};

const fetchMatchDetails = async () => {
    const tournamentId = route.params.tournamentId;
    try {
        const response = await api.get(`/getFormattedTournaments/${tournamentId}`);
        rounds_mapped.value = response.data;
        console.log("Fetched Rounds:", rounds_mapped.value);

        // Get ranking data
        fetchRankings();
    } catch (error) {
        console.error("Failed to fetch round details:", error);
    }
};

const rankingData = ref([]);

// Method for you Bilel (fetch rankings)
const fetchRankings = async () => {
    const tournamentId = route.params.tournamentId;
    try {
        // Replace this with the actual endpoint to fetch the rankings
        const response = await api.get(`/getRanking/${tournamentId}`);
        rankingData.value = response.data;
        // console.log("Fetched Rankings:", rankingData.value);
    } catch (error) {
        console.error("Failed to fetch rankings:", error);
    }
};

const editTournament = () => {
  const tournamentId = route.params.tournamentId;
  router.push(`/edit_tournament/${tournamentId}`);
};

const deleteTournament = async () => {
    try {
        const tournamentId = route.params.tournamentId;
        const response = await api.delete(`/tournaments/${tournamentId}`);

        if (response.status === 200) {
            router.push({ path: '/tournament' });
        } else {
            console.error("Erreur lors de la suppression du tournoi:", response.data);
        }
    } catch (error) {
        console.error("Error deleting tournament:", error);
    }
};

onMounted(() => {
  fetchTournamentDetails();
  fetchMatchDetails();
});

const rankingColumns = [
  {
    name: "rank",
    align: "center",
    label: "Rang",
    field: "rank",
    sortable: true,
  },
  {
    name: "name",
    align: "left",
    label: "Joueur",
    field: "name",
    sortable: true,
  },
  {
    name: "wins",
    align: "center",
    label: "Victoires",
    field: "wins",
    sortable: true,
  },
  {
    name: "status",
    align: "center",
    label: "Status",
    field: "status",
    sortable: true,
  },
];


// Method to use if we have time
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
