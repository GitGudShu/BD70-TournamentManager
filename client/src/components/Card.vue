<template>
  <div class="card-wrapper">
    <q-card class="main-container" flat bordered>
      <q-card-section horizontal class="container">
        <q-card-section>
          <template v-if="type === 'tournament' || type === 'tournament-details'">
            <div class="text-overline text-secondary"> {{ state }}</div>
          </template>
          <div class="text-h5 q-mt-sm q-mb-xs text-accent"> {{ title }}</div>
          <div class="text-caption text-accent" v-html="content"></div>
        </q-card-section>

        <q-card-section class="col-5 flex flex-center" v-if="image">
          <q-img
            class="rounded-borders card-image"
            :src="image"
          />
        </q-card-section>
      </q-card-section>

      <template v-if="type === 'tournament' || type === 'tournament-details'">
        <q-separator color="accent" />

        <q-card-actions style="display: flex; justify-content: space-between;">
          <div>
            <q-btn flat round icon="event" class="text-accent" />
            <q-btn flat class="text-accent">
              {{ dates }}
            </q-btn>
          </div>

          <template v-if="userRole === 'Joueur'">
            <template v-if="type === 'tournament'">
              <div style="display: flex; gap: 1em;">
                <q-btn flat color="primary" class="bg-accent" @click="participateInTournament(xid)">
                  Participer
                </q-btn>
                <q-btn flat color="primary" class="bg-accent" @click="goToTournamentDetails(xid)">
                  Voir les détails
                </q-btn>
              </div>
            </template>
            <template v-else>
              <q-btn flat color="primary" class="bg-accent" @click="goToTournamentDetails(xid)">
                Voir les détails
              </q-btn>
            </template>
          </template>
          <template v-else>
            <q-btn flat color="primary" class="bg-accent" @click="goToTournamentDetails(xid)">
              Configuration
            </q-btn>
          </template>
        </q-card-actions>
      </template>


    </q-card>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { api } from 'src/boot/axios';
import { useAuthStore } from 'src/stores/authStore';
import { useRouter } from 'vue-router';

const router = useRouter();

const authStore = useAuthStore();
const playerId = computed(() => authStore.playerId);
const userRole = computed(() => authStore.userRole);

const props = defineProps({
  title: String,
  state: String,
  type: String,
  dates: String,
  xid: Number,
  content: {
    type: String,
    default: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut purus eget sapien. Tempor nec, auctor a, ultrices nec, pellentesque eu, massa. Donec nec massa."
  },
  image: {
    type: String,
    default: "placeholder.png"
  }
})

// Participer à un tournoi
const participateInTournament = async (tournamentId) => {
  try {
    const response = await api.post(`/participateInTournament/${tournamentId}/${playerId.value}`);
    console.log("Participation réussie :", response.data);
    // Mettre à jour l'état du tournoi ou afficher une confirmation si nécessaire
  } catch (error) {
    console.error("Erreur de participation", error);
    // Gestion d'erreur : afficher un message d'erreur à l'utilisateur
  }
};

const goToTournamentDetails = (tournamentId) => {
  // console.log(tournamentId)
  router.push(`/tournament/${tournamentId}`);
};


</script>

<style scoped>

.card-wrapper {
  display: flex;
  flex-direction: column;
  flex: 1 1 calc(50% - 1em);
  overflow: visible;
  transition: all 0.15s ease;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.card-wrapper:hover {
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
  transform: translateY(-5px);
}

.card-image {
  width: 150px;
  height: 150px;
}

.main-container {
  background-color: var(--sad-nightblue);
}

.main-container .container {
  display: flex;
  justify-content: space-between;
}

</style>
