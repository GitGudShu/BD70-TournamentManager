<template>
  <nav class="navbar">
      <router-link to="/" class="logo-link" exact>
          <span style="margin-left: 1em; font-size: 20px;">Optimops</span>
      </router-link>

      <div class="nav-links" v-if="!isMobile">
          <router-link class="nav-link" to="/parametres" exact active-class="navbar-active"><q-icon name="img:settings_white.svg" size="xs" style="margin-right: 0.4em;"></q-icon>Paramètres</router-link>
          <button @click="logout" class="nav-link logout logout-mobile"><q-icon name="img:logout_white.svg" size="xs" style="margin-right: 0.4em;"></q-icon>Déconnexion</button>
      </div>

      <q-btn color="primary" v-if="isMobile" round icon="menu" flat push text-color="white">
      <q-menu>
        <q-list style="min-width: 100px; color: black">
          <q-item clickable v-close-popup>
            <router-link class="nav-link" to="/parametres" exact active-class="navbar-active"><q-icon name="img:settings_black.svg" size="xs" style="margin-right: 0.4em;"></q-icon>Paramètres</router-link>
          </q-item>
          <q-item clickable v-close-popup>
            <button @click="logout" class="nav-link logout logout-mobile"><q-icon name="img:logout_black.svg" size="xs" style="margin-right: 0.4em;"></q-icon>Déconnexion</button>
          </q-item>

        </q-list>
      </q-menu>
    </q-btn>

  </nav>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { api } from 'src/boot/axios'


const router = useRouter()
const route = useRoute()

const windowWidth = ref(window.innerWidth)
const isMobile = computed(() => windowWidth.value <= 768)

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
}

.logo {
  max-width: 175px;
  min-width: 100px;
  margin-left: 15px;
  max-height: 100%;
  width: clamp(100px, 10vw, 175px);
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
  background-color: inherit;
  color: inherit;
  font-size: inherit;
  border: none;
  display: flex;
  align-items: center;
  padding: 0;
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
