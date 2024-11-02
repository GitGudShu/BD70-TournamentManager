<template>
  <q-page>
    <div class="wrapper">
      <q-card square bordered class="q-pa-lg shadow-1">
        <q-card-section>
          <div class="avatar-placeholder">
            <img :src="avatar" alt="Avatar Placeholder" class="avatar-img" />
          </div>

          <q-form class="q-gutter-md">
            <div class="text-h6 text-primary text-bold">Mettre à jour votre profil</div>

            <!-- User Information -->
            <div class="row">
              <q-input
                square
                filled
                clearable
                v-model="userName"
                label="Nom"
                :placeholder="userData.userName"
                maxlength="50"
              />
              <q-input
                square
                filled
                clearable
                v-model="userLastname"
                label="Prénom"
                :placeholder="userData.userLastname"
                maxlength="50"
              />
            </div>
            <q-input
              square
              filled
              clearable
              v-model="email"
              type="email"
              label="Email"
              :placeholder="userData.email"
              maxlength="100"
            />

            <q-uploader
              style="max-width: 300px"
              label="Avatar"
              auto-upload
              accept=".jpg, image/png, image/jpeg"
              @rejected="onRejected"
            />

            <q-input
              square
              filled
              clearable
              v-model="playerBio"
              label="Biographie du Joueur"
              :placeholder="userData.playerBio"
              type="textarea"
              maxlength="50"
            />

            <!-- Submit Button -->
            <q-btn unelevated color="primary" size="lg" class="full-width q-my-md" label="Mettre à jour" @click="updateProfile" />
          </q-form>
        </q-card-section>
      </q-card>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const userName = ref('');
const userLastname = ref('');
const email = ref('');
const playerBio = ref('');
const avatar = ref('placeholder.png');

const uploader = ref(null);

const userData = ref({
  userName: '',
  userLastname: '',
  email: '',
  playerBio: '',
  avatar: null,
});

const fetchUserData = async () => {
  // Fetch the user's current data from the database and set as placeholders
  // Simulate a fetch request - replace this with an actual API call
  const response = await new Promise(resolve =>
    resolve({
      userName: 'Jean',
      userLastname: 'Dupont',
      email: 'jean.dupont@example.com',
      playerBio: 'Avid board game player',
    })
  );

  userData.value = response;
};

const updateProfile = () => {
  // Form submission logic to update profile
  const formData = new FormData();
  formData.append('userName', userName.value || userData.value.userName);
  formData.append('userLastname', userLastname.value || userData.value.userLastname);
  formData.append('email', email.value || userData.value.email);
  formData.append('playerBio', playerBio.value || userData.value.playerBio);
  if (avatar.value) formData.append('avatar', avatar.value);

  console.log('Profile updated with:', formData);
  // Send formData to the API for updating the profile
};

onMounted(fetchUserData);
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
}

.row {
  display: flex;
  flex-direction: row;
  gap: 1em;
  align-items: center;
}

.avatar-placeholder {
  position: absolute;
  top: 0;
  right: 0;
  cursor: pointer;
  border-radius: 50%;
  overflow: hidden;
  width: 120px;
  height: 120px;
  border: 0 solid var(--sad-nightblue);
}

.avatar-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>
