<template>
  <nav class="navbar">
      <router-link to="/" class="logo-link" exact>
        <img src="logo.png" alt="" class="logo">
      </router-link>

      <div class="nav-items">
        <router-link v-for="page in pages" :key="page.path" :to="page.path" class="nav-link"  exact>

          <template v-if="page.name === 'CREER UN TOURNOI'">
            <!-- Only display this section if userRole is "Organisateur" -->
            <q-item-section v-if="userRole === 'Organisateur'">
              {{ page.name }}
            </q-item-section>
          </template>

          <template v-else-if="page.name === 'VOS MATCHS'">
            <!-- Only display this section if userRole is "Joueur" -->
            <q-item-section v-if="userRole === 'Joueur'">
              {{ page.name }}
            </q-item-section>
          </template>

          <template v-else>
            <q-item-section>
              {{ page.name }}
            </q-item-section>
          </template>

        </router-link>
      </div>

      <div class="nav-links">
        <template v-if="userRole === 'Organisateur'">
          <div class="hero-container">
            <q-item clickable v-ripple>
              <q-item-section side>
                <q-avatar rounded size="50px">
                  <img :src="userAvatar" alt="user avatar" />
                </q-avatar>
              </q-item-section>
              <q-item-section>
                <q-item-label class="text-h6 text-accent">{{ fullName }}</q-item-label>
                <q-item-label caption class="text-caption text-secondary">{{ userRole }}</q-item-label>
              </q-item-section>
            </q-item>
          </div>
        </template>
        <template v-else>
          <router-link class="nav-link" to="/update_player" exact>
            <div class="hero-container">
              <q-item clickable v-ripple>
                <q-item-section side>
                  <q-avatar rounded size="50px">
                    <img :src="userAvatar" alt="user avatar" />
                  </q-avatar>
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-h6 text-accent">{{ fullName }}</q-item-label>
                  <q-item-label caption class="text-caption text-secondary">{{ userRole }}</q-item-label>
                </q-item-section>
              </q-item>
            </div>
          </router-link>
        </template>
        <q-btn @click="logout" icon="logout" label="DÉCONNEXION" class="logout logout-mobile text-primary" />
      </div>

  </nav>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from 'src/stores/authStore';

const router = useRouter();
const authStore = useAuthStore();

const nav_items = [
  { name: 'ACCUEIL', path: '/home' },
  { name: 'VOS MATCHS', path: '/match' },
  { name: "TOURNOIS", path: '/tournament' },
  { name: "CREER UN TOURNOI", path: '/create_tournament' },
  { name: 'STATISTIQUES', path: '/stats' }
];

const pages = ref(nav_items);
const windowWidth = ref(window.innerWidth)

const updateWindowWidth = () => { windowWidth.value = window.innerWidth; }

onMounted(async () => {
  window.addEventListener('resize', updateWindowWidth);
})

onBeforeUnmount(() => { window.removeEventListener('resize', updateWindowWidth); })

const logout = async () => {
  try {
    await authStore.logout();
  } catch (error) {
    console.error("Logout failed", error);
  }
}

// Get user information
const fullName = computed(() => `${authStore.userName} ${authStore.userLastName}`);
const userRole = computed(() => authStore.userRole);
const userAvatar = computed(() => authStore.avatar || "placeholder.png");

</script>

<style scoped>
.navbar {
  height: 72px;
  padding: 0;
  background-color: var(--sad-nightblue);
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 500;
}

.logo-link {
  display: flex;
  align-items: center;
  background-color: var(--sad-secondary);
  border-radius: 10px;
  padding: 5px 10px;
  height: calc(100% - 2em);
  margin-left: 1em;
}

.nav-items {
  display: flex;
  gap: 2em;
  margin-left: 1em;
}

.logo {
  max-width: 175px;
  min-width: 100px;
  margin-left: 15px;
  max-height: 100%;
  width: clamp(100px, 10vw, 175px);
  margin: 0 auto;
}

.nav-text {
  text-align: center;
}

.nav-links {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  gap: 2em;
  margin-right: 1em;
}

.nav-link {
display: flex;
align-items: center;
position: relative;
}

.nav-link::before {
transition: 300ms;
height: 5px;
content: "";
position: absolute;
background-color: var(--sad-orange);
width: 0%;
top: 100%;
}

.nav-link:hover::before {
width: 100%;
}

.logout {
  background-color: var(--sad-secondary);
  color: inherit;
  font-size: inherit;
  border: none;
  display: flex;
  align-items: center;
  padding: .5em 1em;
  cursor: pointer;
}


.last-update {
  height: -moz-min-content;
  height: min-content;
  font-weight: bold;
  align-items: center;
  display: flex;
  max-width: 100%;
  font-size: clamp(12px, 2vw, 20px);
  gap: 0.5em;
}


</style>
