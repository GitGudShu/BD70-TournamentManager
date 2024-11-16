<template>
  <div class="huh">
    <img src="nothing.png" alt="confused cat" class="huh-img">
    <div class="huh-message text-primary">{{ message }}</div>
  </div>
</template>

<script setup>

const props = defineProps({
  message: String,
})

</script>

<style scoped>

.huh {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 2em;
}

.huh-img {
  height: 200px;
}

.huh-message {
  margin-left: 1em;
  border: .2em solid var(--sad-nightblue);
  border-radius: .5em;
  padding: 1em;
  background-color: aliceblue;
  max-width: 200px;
}

</style>
