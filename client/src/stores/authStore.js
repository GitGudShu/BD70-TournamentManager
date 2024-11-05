import { defineStore } from 'pinia';
import { api } from 'src/boot/axios'; // Use the configured Axios instance
import { ref } from 'vue';
import { useRouter } from 'vue-router';

export const useAuthStore = defineStore('auth', () => {
  const isAuthenticated = ref(false);
  const userName = ref('');
  const userLastName = ref('');
  const email = ref('');
  const userRole = ref('');
  const bio = ref('');
  const avatar = ref(null);
  const ranking = ref(null);
  const router = useRouter();

  const login = async (email, password) => {
    try {
      const response = await api.post('/login', { email, password });
      isAuthenticated.value = true;
      router.push('/home');
      console.log('Login successful:', response.data);

      await fetchUserDetails();
    } catch (error) {
      isAuthenticated.value = false;
      console.error('Login failed:', error);
    }
  };

  const logout = async () => {
    try {
      await api.post('/logout');
      isAuthenticated.value = false;

      // Clear user details upon logout
      userName.value = '';
      userLastName.value = '';
      userRole.value = '';
      email.value = '';
      bio.value = '';
      avatar.value = null;
      ranking.value = null;
      router.push('/login');
      console.log('Logout successful');
    } catch (error) {
      console.error('Logout failed:', error);
    }
  };

  const fetchUserDetails = async () => {
    try {
      const response = await api.get('/user/details');
      userName.value = response.data.name;
      userLastName.value = response.data.lastName;
      userRole.value = response.data.role;
      email.value = response.data.email;

      // Additional fields for players
      if (userRole.value === 'Joueur') {
        bio.value = response.data.bio;
        avatar.value = response.data.avatar;
        ranking.value = response.data.ranking;
      } else {
        // Clear player-specific fields if it's an organizer
        bio.value = '';
        avatar.value = null;
        ranking.value = null;
      }

      console.log('User details fetched:', response.data);
    } catch (error) {
      console.error('Failed to fetch user details:', error);
    }
  };

  return {
    isAuthenticated,
    login,
    logout,
    userRole,
    userName,
    userLastName,
    bio,
    avatar,
    ranking,
    fetchUserDetails,
    email
  };
});
