<template>
  <q-layout view="hHh lpR fFf">
    <q-page-container>
      <q-page class="bg-primary window-height window-width row justify-center items-center">
        <div class="column">
          <div class="row">
            <q-card square bordered class="q-pa-lg shadow-1 q-mb-lg">
              <q-card-section>
                <q-form class="q-gutter-md">
                  <!-- User Information -->
                  <div class="text-h6">Vos informations</div>
                  <q-input square filled clearable v-model="email" type="email" label="Email*" maxlength="100" />
                  <q-input square filled clearable v-model="password" type="password" label="Créez votre mot de passe*" maxlength="255" />
                  <q-input square filled clearable v-model="userName" label="Nom*" maxlength="50" />
                  <q-input square filled clearable v-model="userLastname" label="Prénom*" maxlength="50" />

                  <!-- Separator -->
                  <q-separator spaced />

                  <!-- Player Information (Optional) -->
                  <div class="text-h6">A propos de vous (Facultatif)</div>
                  <q-input filled clearable v-model="playerBio" label="Biographie du Joueur" type="textarea" maxlength="2000"/>
                  <input type="file" @change="onFileChange" />
                  <!-- Submit Button -->
                  <q-btn unelevated color="primary" size="lg" class="full-width" label="Créer votre compte" @click="submitForm" />
                </q-form>
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

const userName = ref('');
const userLastname = ref('');
const email = ref('');
const password = ref('');
const playerBio = ref('');
const avatar = ref(null);

const onFileChange = (event) => {
  avatar.value = event.target.files[0];
};


const submitForm = async () => {
  const formData = new FormData();
  formData.append('userName', userName.value);
  formData.append('userLastname', userLastname.value);
  formData.append('email', email.value);
  formData.append('password', password.value);
  formData.append('playerBio', playerBio.value);
  if (avatar.value) formData.append('avatar', avatar.value);

  try {
    const response = await axios.post('/api/register', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    });
    console.log('User created with ID:', response.data.userId);
  } catch (error) {
    console.error('Failed to create account:', error);
  }
};
</script>

<style scoped>
.q-card {
  width: 500px; /* Wider form */
}

.logo {
  margin: 1em auto;
  background: white;
  border-radius: 10px;
  padding: 8px 15px;
}

.logo-img {
  max-width: 230px;
}
</style>
