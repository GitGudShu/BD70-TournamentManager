<template>
  <q-page>
    <div class="wrapper">
      <div ref="mixChartRef" id="mix-chart"></div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted, watch, onBeforeUnmount, nextTick } from 'vue';
import ApexCharts from 'apexcharts';

const mixChartRef = ref(null);
let chart = null;

const props = defineProps({
  series: {
    type: Array,
    required: true,
  },
  categories: {
    type: Array,
    required: true,
  },
  colors: {
    type: Array,
    default: () => ['#008FFB', '#00E396', '#FEB019', '#FF4560', '#775DD0'],
  },
});

const createChart = async () => {
  await nextTick(); // Ensure the DOM is updated

  console.log('Starting createChart function...');
  console.log('Props series:', props.series);
  console.log('Props categories:', props.categories);

  if (!mixChartRef.value) {
    console.error('Chart element not found!');
    return;
  }

  if (!props.series?.length || !props.categories?.length) {
    console.error('Insufficient data to create chart');
    return;
  }

  console.log('Chart element found, creating/updating chart...');

  const options = {
    series: props.series,
    chart: {
      height: 350,
      type: 'line',
      stacked: false,
    },
    colors: props.colors,
    xaxis: {
      categories: props.categories,
    },
    stroke: {
      width: props.series.map((s) => (s.type === 'line' ? 4 : 1)),
    },
    tooltip: {
      shared: true,
      intersect: false,
    },
  };

  if (chart) {
    console.log('Updating existing chart with options:', options);
    chart.updateOptions(options, false, true).catch((error) => {
      console.error('Error updating chart:', error);
    });
  } else {
    console.log('Creating new chart with options:', options);
    chart = new ApexCharts(mixChartRef.value, options);
    chart.render().catch((error) => {
      console.error('Error rendering chart:', error);
    });
  }
};

onMounted(() => {
  console.log('onMounted lifecycle hook called.');
  nextTick(() => {
    if (mixChartRef.value) {
      console.log('MixChart element found during mounted lifecycle.');
      createChart();
    } else {
      console.error('MixChart element not found during mounted lifecycle');
    }
  });
});

watch(() => [props.series, props.categories, props.colors], () => {
  console.log('Watch triggered: series or categories or colors changed.');
  if (props.series?.length && props.categories?.length) {
    createChart();
  }
});

onBeforeUnmount(() => {
  console.log('onBeforeUnmount lifecycle hook called. Destroying chart...');
  if (chart) {
    chart.destroy();
    chart = null;
    console.log('Chart destroyed.');
  }
});
</script>

<style scoped>
</style>
