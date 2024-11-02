<template>
  <div class="card-wrapper">
    <q-card class="main-container" flat bordered>
      <q-card-section horizontal>
        <q-card-section>
          <div class="text-overline text-secondary"> {{ state }}</div>
          <div class="text-h5 q-mt-sm q-mb-xs text-accent"> {{ title }}</div>
          <div class="text-caption text-accent">
            {{ content }}
          </div>
        </q-card-section>

        <q-card-section class="col-5 flex flex-center" v-if="image">
          <q-img
            class="rounded-borders card-image"
            :src="image"
          />
        </q-card-section>
      </q-card-section>

      <q-separator color="accent" />

      <q-card-actions style="display: flex; justify-content: space-between;">
        <div>
          <q-btn flat round icon="event" class="text-accent" />
          <q-btn flat class="text-accent">
            13:00 - 15:00
          </q-btn>
        </div>

        <q-btn flat color="primary" class="bg-accent">
          Participer
        </q-btn>
      </q-card-actions>

    </q-card>
  </div>
</template>

<script setup>
const props = defineProps({
  title: String,
  state: String,
  content: {
    type: String,
    default: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut purus eget sapien. Tempor nec, auctor a, ultrices nec, pellentesque eu, massa. Donec nec massa."
  },
  image: {
    type: String,
    default: "placeholder.png"
  }
})
</script>

<style scoped>

.card-wrapper {
  display: flex;
  flex-direction: column;
  flex: 1 1 calc(50% - 1em);
  overflow: visible;
  transition: all 0.15s ease;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.card-wrapper:hover {
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
  transform: translateY(-5px);
}

.card-image {
  width: 150px;
  height: 150px;
}

.main-container {
  background-color: var(--sad-nightblue);
}

</style>
