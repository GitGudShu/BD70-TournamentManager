import MainLayout from 'layouts/MainLayout.vue';
import Home from 'pages/Home.vue';
import Login from 'pages/Login.vue';
import CreatePlayer from 'pages/forms/CreatePlayer.vue';
import UpdateProfile from 'pages/forms/UpdateProfile.vue';
import Statistics from 'src/pages/Statistics.vue';
import Tournament from 'src/pages/Tournament.vue';
import Match from 'src/pages/Match.vue';

const routes = [
  {
    path: '/',
    component: MainLayout,
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        component: Home
      },
      {
        path: 'home',
        component: Home
      },
      {
        path: 'update_player',
        component: UpdateProfile
      },
      {
        path: 'stats',
        component: Statistics
      },
      {
        path: 'tournament',
        component: Tournament
      },
      {
        path: 'match',
        component: Match
      }
    ]
  },
  {
    path: '/login',
    component: Login
  },
  {
    path: '/create_player',
    component: CreatePlayer
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue')
  }
]

export default routes
