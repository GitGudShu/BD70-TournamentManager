import MainLayout from 'layouts/MainLayout.vue'
import Home from 'pages/Home.vue'
import Login from 'pages/Login.vue'
import CreatePlayer from 'pages/forms/CreatePlayer.vue'

const routes = [
  {
    path: '/',
    component: MainLayout,
    children: [
      {
        path: '',
        redirect: 'home'
      },
      {
        path: 'home',
        component: Home
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
