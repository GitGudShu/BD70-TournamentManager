<template>
  <q-table
    flat
    bordered
    class="statement-table"
    :title="title"
    :rows="rows"
    :hide-header="grid"
    :columns="columns"
    row-key="__index"
    :grid="grid"
    :filter="filter"
    virtual-scroll
    v-model:pagination="pagination"
    :rows-per-page-options="[0]"
  >
    <template v-slot:top-right="props">
      <q-input
        outlined
        dense
        debounce="300"
        v-model="filter"
        placeholder="Search"
      >
        <template v-slot:append>
          <q-icon name="search" />
        </template>
      </q-input>

      <q-btn
        flat
        round
        dense
        :icon="props.inFullscreen ? 'fullscreen_exit' : 'fullscreen'"
        @click="setFullscreen(props)"
      >
        <q-tooltip>{{
          props.inFullscreen ? "Exit Fullscreen" : "Toggle Fullscreen"
        }}</q-tooltip>
      </q-btn>

      <q-btn
        flat
        round
        dense
        :icon="grid ? 'list' : 'grid_on'"
        @click="grid = !grid"
      >
        <q-tooltip>{{ grid ? "List" : "Grid" }}</q-tooltip>
      </q-btn>
    </template>

    <!-- Conditional rendering for the "status" column -->
    <template #body-cell-status="props">
      <q-td :props="props">
        <q-chip
          :color="
            props.row.status === 'En attente du prochain round...' ? 'green' :
            props.row.status === 'Perdu' ? 'red' :
            props.row.status === 'Champion' ? 'blue' :
            props.row.status === 'En duel' ? 'orange' :
            'grey'
          "
          text-color="white"
          dense
          class="text-weight-bolder"
          square
        >
          {{ props.row.status }}
        </q-chip>
      </q-td>
    </template>

    <!-- Conditional rendering for the "action" column -->
    <template #body-cell-action="props">
      <q-td :props="props">
        <q-btn
          dense
          flat
          round
          color="blue"
          field="edit"
          icon="edit"
          @click="editItem(props.row)"
        />
      </q-td>
    </template>

    <!-- Grid view -->
    <template v-slot:item="props">
    <div
      class="q-pa-xs col-xs-12 col-sm-6 col-md-4 col-lg-3 grid-style-transition"
      :style="props.selected ? 'transform: scale(0.95);' : ''"
    >
      <q-card :class="props.selected ? 'bg-grey-2' : ''">
        <q-list dense>
          <q-item v-for="col in props.cols" :key="col.name">
            <q-item-section>
              <q-item-label>{{ col.label }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-chip
                v-if="col.name === 'status'"
                :color="
                  props.row.status === 'En attente du prochain round...' ? 'green' :
                  props.row.status === 'Perdu' ? 'red' :
                  props.row.status === 'Champion' ? 'blue' :
                  props.row.status === 'En duel' ? 'orange' :
                  'grey'
                "
                text-color="white"
                dense
                class="text-weight-bolder"
                square
              >
                {{ props.row.status }}
              </q-chip>
              <q-btn
                v-else-if="col.name === 'action'"
                dense
                flat
                color="primary"
                field="edit"
                icon="edit"
                @click="editItem(props.row)"
              />
              <q-item-label v-else caption :class="col.classes || ''">{{
                col.value
              }}</q-item-label>
            </q-item-section>
          </q-item>
        </q-list>
      </q-card>
    </div>
  </template>

  </q-table>
</template>

<script setup>
import { ref } from "vue";

const props = defineProps({
  title: String,
  columns: {
    type: Array,
    required: true,
  },
  rows: {
    type: Array,
    required: true,
  },
});

const grid = ref(false);
const filter = ref("");
const pagination = ref({ page: 1, rowsPerPage: 10 });

const setFullscreen = (props) => {
  props.inFullscreen = !props.inFullscreen;
};

const editItem = (row) => {
  console.log("Edit item:", row);
};

</script>

<style scoped>
.q-chip.green {
  background-color: green !important;
}

.q-chip.red {
  background-color: red !important;
}

.q-chip.orange {
  background-color: orange !important;
}

.q-chip.grey {
  background-color: grey !important;
}

</style>
