<template>
  <q-page>
    <div class="wrapper">
      <q-card square bordered class="q-pa-lg shadow-1">
        <q-card-section>
          <div class="avatar-placeholder">
            <img :src="avatar" alt="Avatar Placeholder" class="avatar-img" />
          </div>

          <q-form class="q-gutter-md">
            <div class="text-h5 text-primary text-bold">Mettre à jour votre profil</div>

            <!-- User Information -->
            <div class="row">
              <q-input
                square
                filled
                clearable
                v-model="userName"
                label="Nom"
                maxlength="50"
              />
              <q-input
                square
                filled
                clearable
                v-model="userLastname"
                label="Prénom"
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
              maxlength="100"
            />

            <!-- Avatar Upload -->
            <div class="text-h6 text-primary text-bold"> Mettre à jour l'avatar </div>
            <input type="file" @change="onFileChange" />

            <q-input
              square
              filled
              clearable
              v-model="playerBio"
              label="Biographie du Joueur"
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
import { useAuthStore } from 'src/stores/authStore';

const userName = ref('');
const userLastname = ref('');
const email = ref('');
const playerBio = ref('');
const avatar = ref(null);

const authStore = useAuthStore();

const fetchUserData = () => {
  userName.value = authStore.userName;
  userLastname.value = authStore.userLastName;
  email.value = authStore.email;
  playerBio.value = authStore.bio || '';
  avatar.value = authStore.avatar || 'placeholder.png'; // Use avatar from store or fallback
};

const onFileChange = (event) => {
  const file = event.target.files[0];
  if (file) {
    avatar.value = URL.createObjectURL(file);
  }
};

const updateProfile = async () => {
  const updatedData = {
    userName: userName.value,
    userLastname: userLastname.value,
    email: email.value,
    playerBio: playerBio.value,
    avatar: avatar.value instanceof File ? avatar.value : null, // Check if avatar is a new file
  };

  await authStore.updateProfile(updatedData);
  console.log('Profile update request sent');
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
