<template>
  <div ref="chartRef" id="chart"></div>
</template>

<script setup>
import { onMounted, nextTick, ref, watch, onBeforeUnmount } from 'vue';
import ApexCharts from 'apexcharts';

const chartRef = ref(null);
const chartInstance = ref(null);

const props = defineProps({
  series: {
    type: Array,
    default: () => []
  },
  labels: {
    type: Array,
    default: () => []
  },
  image_paths: {
    type: Array,
    default: () => []
  }
});

const renderChart = () => {
  if (!chartRef.value) {
    console.error('Chart element not found!');
    return;
  }

  if (chartInstance.value) {
    chartInstance.value.destroy(); // Clean up any existing chart instance
  }

  const options = {
    series: props.series,
    labels: props.labels,
    chart: {
      width: 500,
      type: 'pie',
    },
    fill: {
      type: 'image',
      opacity: 0.85,
      image: {
        src: props.image_paths
      },
    },
    dataLabels: {
      enabled: true,
      style: {
        colors: ['#111']
      },
      background: {
        enabled: true,
        foreColor: '#fff',
        borderWidth: 2
      }
    }
  };

  chartInstance.value = new ApexCharts(chartRef.value, options);
  chartInstance.value.render();
};

onMounted(() => {
  nextTick(() => {
    renderChart();
  });
});

onBeforeUnmount(() => {
  if (chartInstance.value) {
    chartInstance.value.destroy();
    chartInstance.value = null;
    console.log('Chart instance destroyed.');
  }
});

// Watch for prop changes to update the chart
watch(() => [props.series, props.labels, props.image_paths], ([newSeries, newLabels, newImagePaths]) => {
  if (newSeries.length && newLabels.length && newImagePaths.length) {
    renderChart();
  }
}, { immediate: true });
</script>
