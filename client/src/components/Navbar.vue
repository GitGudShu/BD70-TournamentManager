<template>
  <nav class="navbar">
      <router-link to="/" class="logo-link" exact>
        <img src="logo.png" alt="" class="logo">
      </router-link>

      <div class="nav-items">
        <router-link class="nav-link" to ="/" exact >ACCUEIL</router-link>
        <router-link class="nav-link" to ="/game" exact >JEUX</router-link>
        <router-link class="nav-link" to ="/tournament" exact >TOURNOIS</router-link>
        <router-link class="nav-link" to ="/space" exact >MON ESPACE</router-link>
      </div>

      <div class="nav-links">
          <router-link class="nav-link" to="/parametres" exact active-class="navbar-active">
            <div class="hero-container">
              <q-item clickable v-ripple>
                <q-item-section side>
                  <q-avatar rounded size="40px">
                    <img src="https://ui-avatars.com/api/?name=Thomas+Chu&background=random" alt="hero">
                  </q-avatar>
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-h6 text-accent">Thomas Chu</q-item-label>
                  <q-item-label caption class="text-caption text-secondary">Administrateur</q-item-label>
                </q-item-section>
              </q-item>
            </div>
          </router-link>
          <q-btn @click="logout" icon="logout" label="DÉCONNEXION" class="logout logout-mobile text-primary" />
      </div>

  </nav>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { api } from 'src/boot/axios'


const router = useRouter()
const route = useRoute()

const windowWidth = ref(window.innerWidth)

const updateWindowWidth = () => {
  windowWidth.value = window.innerWidth;
}

onMounted(() => {
  window.addEventListener('resize', updateWindowWidth);
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', updateWindowWidth);
})

const logout = async () => {
try {
  await api.post('/auth/logout');
  localStorage.clear()
  router.push("/login");
} catch (error) {
  console.error("Logout failed", error);
}
}

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

.navbar-active {
border-bottom: var(--sad-orange) 5px solid;
width: 100%;
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
