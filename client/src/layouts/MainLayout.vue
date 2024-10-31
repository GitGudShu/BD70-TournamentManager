<template>
  <q-layout view="hHh lpR fFf">
    <q-header>
        <Nav />
    </q-header>

    <q-page-container>
      <router-view />
    </q-page-container>

  </q-layout>
</template>

<script setup>
import Nav from 'src/components/Navbar.vue';

</script>
