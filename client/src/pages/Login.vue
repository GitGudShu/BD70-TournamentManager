<template>
  <q-layout view="hHh lpR fFf">
    <q-page-container>
      <q-page class=" window-height window-width row justify-center items-center">
        <div class="column">
          <div class="row">
            <div class="logo">
              <img src="logo.png" alt="" class="logo-img">
            </div>
          </div>
          <div class="row">
            <q-card square bordered class="q-pa-lg shadow-1">
              <q-card-section>
                <q-form class="q-gutter-md">
                  <q-input square filled clearable v-model="email" type="email" label="Email" />
                  <q-input square filled clearable v-model="password" type="password" label="Mot de passe" />
                </q-form>
              </q-card-section>
              <q-card-actions class="q-px-md">
                <q-btn unelevated color="primary" size="lg" class="full-width" label="Se connecter" @click="loginUser" />
              </q-card-actions>
              <q-card-section class="text-center q-pa-none">
                <p class="text-grey-6">
                  Pas encore inscrit ?
                  <router-link to="/create_player" class="text-primary" style="text-decoration: underline;">
                    Créez un compte
                  </router-link>
                </p>
              </q-card-section>
            </q-card>
          </div>
        </div>
      </q-page>
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from 'src/stores/authStore';

const email = ref('');
const password = ref('');

const router = useRouter();
const authStore = useAuthStore();

const loginUser = async () => {
  try {
    await authStore.login(email.value, password.value);
    router.push('/home');
  } catch (error) {
    console.error("Login failed", error);
  }
}

</script>

<style scoped>
.q-card {
  width: 360px;
}

.logo {
  margin: 1em auto;
  background: white;
  border-radius: 10px;
  padding-top: 8px;
  padding-bottom: 5px;
  padding-right: 15px;
  padding-left: 10px;
}

.logo-img {
  max-width: 230px;
}
</style>
