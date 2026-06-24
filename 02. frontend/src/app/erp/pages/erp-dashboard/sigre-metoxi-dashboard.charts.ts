/** Opciones ApexCharts del dashboard Metoxi (index.js). */
export const METOXI_CHART1_OPTIONS = {
  series: [{ name: 'Net Sales', data: [4, 10, 25, 12, 25, 18, 40, 22, 7] }],
  chart: { height: 105, type: 'area', sparkline: { enabled: true }, zoom: { enabled: false } },
  dataLabels: { enabled: false },
  stroke: { width: 1.7, curve: 'smooth' },
  fill: {
    type: 'gradient',
    gradient: {
      shade: 'dark',
      gradientToColors: ['#02c27a'],
      shadeIntensity: 1,
      type: 'vertical',
      opacityFrom: 0.5,
      opacityTo: 0,
    },
  },
  colors: ['#02c27a'],
  tooltip: { theme: 'dark', x: { show: false }, marker: { show: false } },
  xaxis: { categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'] },
};

export const METOXI_CHART2_OPTIONS = {
  series: [78],
  chart: { height: 180, type: 'radialBar', toolbar: { show: false } },
  plotOptions: {
    radialBar: {
      startAngle: -115,
      endAngle: 115,
      hollow: { margin: 0, size: '80%', background: 'transparent' },
      track: { background: 'rgba(0, 0, 0, 0.1)', strokeWidth: '67%' },
      dataLabels: {
        show: true,
        name: { show: false },
        value: { offsetY: 10, color: '#111', fontSize: '24px', show: true },
      },
    },
  },
  fill: {
    type: 'gradient',
    gradient: {
      shade: 'dark',
      type: 'horizontal',
      shadeIntensity: 0.5,
      gradientToColors: ['#0866ff'],
      inverseColors: true,
      opacityFrom: 1,
      opacityTo: 1,
      stops: [0, 100],
    },
  },
  colors: ['#fc185a'],
  stroke: { lineCap: 'round' },
  labels: ['Total Orders'],
};

export const METOXI_CHART3_OPTIONS = {
  series: [{ name: 'Net Sales', data: [8, 10, 25, 18, 38, 24, 20, 16, 7] }],
  chart: { height: 120, type: 'bar', sparkline: { enabled: true }, zoom: { enabled: false } },
  dataLabels: { enabled: false },
  stroke: { width: 1, curve: 'smooth', colors: ['transparent'] },
  fill: {
    type: 'gradient',
    gradient: { shade: 'dark', gradientToColors: ['#fc6718'], shadeIntensity: 1, type: 'vertical' },
  },
  colors: ['#fc185a'],
  plotOptions: {
    bar: {
      horizontal: false,
      borderRadius: 4,
      borderRadiusApplication: 'around',
      columnWidth: '45%',
    },
  },
  tooltip: { theme: 'dark', x: { show: false }, marker: { show: false } },
  xaxis: { categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'] },
};

export const METOXI_CHART4_OPTIONS = {
  series: [
    { name: 'Sales', data: [20, 5, 60, 10, 30, 20, 25, 15, 31] },
    { name: 'Views', data: [17, 10, 45, 15, 25, 15, 40, 10, 24] },
  ],
  chart: {
    foreColor: '#9ba7b2',
    height: 235,
    type: 'bar',
    toolbar: { show: false },
    sparkline: { enabled: false },
    zoom: { enabled: false },
  },
  dataLabels: { enabled: false },
  stroke: { width: 4, curve: 'smooth', colors: ['transparent'] },
  fill: {
    type: 'gradient',
    gradient: {
      shade: 'dark',
      gradientToColors: ['#0d6efd', '#6f42c1'],
      shadeIntensity: 1,
      type: 'vertical',
      stops: [0, 100, 100, 100],
    },
  },
  colors: ['#0d6efd', '#6f42c1'],
  plotOptions: {
    bar: {
      horizontal: false,
      borderRadius: 4,
      borderRadiusApplication: 'around',
      columnWidth: '55%',
    },
  },
  grid: { show: false },
  tooltip: { theme: 'dark', fixed: { enabled: true }, x: { show: true }, marker: { show: false } },
  xaxis: { categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'] },
};
