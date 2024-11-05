import { defineStore } from 'pinia';
import { api } from 'src/boot/axios'; // Use the configured Axios instance
import { ref } from 'vue';
import { useRouter } from 'vue-router';

export const useAuthStore = defineStore('auth', () => {
  const isAuthenticated = ref(false);
  const router = useRouter();

  const login = async (email, password) => {
    try {
      const response = await api.post('/login', { email, password });
      isAuthenticated.value = true;
      router.push('/home');
      console.log('Login successful:', response.data);
    } catch (error) {
      isAuthenticated.value = false;
      console.error('Login failed:', error);
    }
  };

  const logout = async () => {
    try {
      await api.post('/logout');
      isAuthenticated.value = false;
      router.push('/login');
      console.log('Logout successful');
    } catch (error) {
      console.error('Logout failed:', error);
    }
  };

  return { isAuthenticated, login, logout };
});
