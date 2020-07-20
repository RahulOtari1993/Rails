$(document).ready(function () {
  var $primary = '#7367F0',
    $success = '#28C76F',
    $danger = '#EA5455',
    $warning = '#FF9F43',
    $info = '#00cfe8',
    $label_color_light = '#dae1e7';

  var themeColors = [$primary, $success, $danger, $warning, $info];

  // RTL Support
  var yaxis_opposite = false;
  if($('html').data('textdirection') == 'rtl'){
    yaxis_opposite = true;
  }

  // Line-Chart For Shares Per day
  // ----------------------------------
  var lineChartOptionsForShares = {
    chart: {
      height: 350,
      type: 'line',
      zoom: {
        enabled: false
      }
    },
    colors: themeColors,
    dataLabels: {
      enabled: false
    },
    stroke: {
      curve: 'straight'
    },
    series: [{
      name: "Shares",
      data: [10, 41, 35, 51, 49, 62, 69, 91, 148],
    }],
    title: {
      text: 'Shares',
      align: 'left'
    },
    grid: {
      row: {
        colors: ['#f3f3f3', 'transparent'], // takes an array which will be repeated on columns
        opacity: 0.5
      },
    },
    xaxis: {
      categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'],
      minValue: 0,
      maxValue: 160
    },
    yaxis: {
      tickAmount: 10,
      opposite: yaxis_opposite
    }
  }
  var shareLineChart = new ApexCharts(
    document.querySelector("#share-per-day-line-chart"),
    lineChartOptionsForShares
  );
  shareLineChart.render();

  // Getting Data For Graphs & Charts And Updating Them 
  var campaignId = $('#gender-pie-chart').attr('campaign_id');
  if (campaignId != undefined) {
    var url = "/admin/campaigns/" + campaignId + "/users/get_data_for_chart_graph";
    $.getJSON(url, function(response) {
      ageBarChart.updateOptions({
        series: [{
          data: response.ageElementCount  // Updating Age Options
        }]
      });
      genderPieChart.updateOptions({
        series: response.genderElementCount // Updating Gender Options
      });
      completedChallengeBarChart.updateOptions({
        series: [{
          data: response.completedChallengesElementCount  // Updating Completed Challenges / Platform Options
        }]
      });
      connectedPlatformBarChart.updateOptions({
        series: [{
          data: response.connectedPlatformElementCount  // Updating Completed Challenges / Platform Options
        }]
      });
    });
  }

  // Bar Chart For Age Breakdown
  // ----------------------------------
  var ageBarChartOptions = {
    chart: {
      height: 350,
      type: 'bar',
      toolbar: {
        show: false
      }
    },
    colors: themeColors,
    plotOptions: {
      bar: {
        horizontal: true,
      }
    },
    dataLabels: {
      enabled: false
    },
    series: [{
      name: 'No of Users',
      data: [20, 150, 50, 100, 20, 40]
    }],
    xaxis: {
      categories: ['Above 100','81 - 100', '61 - 80', '41 - 60', '21 - 40', '0 - 20'],
      tickAmount: 5,
      labels: {
        formatter: function(val) {
          return val.toFixed(0);
        }
      }
    },
    yaxis: {
      opposite: yaxis_opposite
    },
    tooltip: {
      y: {
        formatter: function(value, { series, seriesIndex, dataPointIndex, w }) {
          return parseInt(value)
        }
      }
    }
  }
  var ageBarChart = new ApexCharts(
    document.querySelector("#age-bar-chart"),
    ageBarChartOptions
  );
  ageBarChart.render();


  // Pie Chart For Gender Breakdown
  // ----------------------------------
  var genderPieChartOptions = {
    chart: {
      type: 'pie',
      height: 350
    },
    colors: themeColors,
    labels: ['other', 'female', 'male'],
    series: [45,12,34],
    legend: {
      itemMargin: {
        horizontal: 2
      },
    },
    responsive: [{
      breakpoint: 480,
      options: {
        chart: {
          width: 350
        },
        legend: {
          position: 'bottom'
        }
      }
    }]
  }
  var genderPieChart = new ApexCharts(
    document.querySelector("#gender-pie-chart"), genderPieChartOptions
  );
  genderPieChart.render();


  // Bar Chart For Completed Challenges / Platform
  // ----------------------------------
  var completedChallengeBarChartOptions = {
    chart: {
      height: 350,
      type: 'bar',
      toolbar: {
        show: false
      }
    },
    colors: themeColors,
    plotOptions: {
      bar: {
        horizontal: true,
      }
    },
    dataLabels: {
      enabled: false
    },
    series: [{
      name: 'Completed Challenges',
      data: [10, 9, 7, 15]
    }],
    xaxis: {
      categories: ['Twitter', 'Facebook', 'Google', 'Email'],
      tickAmount: 5
    },
    yaxis: {
      opposite: yaxis_opposite
    },
    tooltip: {
      y: {
        formatter: function(value, { series, seriesIndex, dataPointIndex, w }) {
          return parseInt(value)
        }
      }
    }
  }
  var completedChallengeBarChart = new ApexCharts(
    document.querySelector("#completed-challenge-bar-chart"),
    completedChallengeBarChartOptions
  );
  completedChallengeBarChart.render();


  // Bar Chart For Connected Platforms
  // ----------------------------------
  var connectedPlatformBarChartOptions = {
    chart: {
      height: 350,
      type: 'bar',
    },
    colors: themeColors,
    plotOptions: {
      bar: {
        horizontal: true,
      }
    },
    dataLabels: {
      enabled: false
    },
    series: [{
      name: 'Connected Platforms',
      data: [10, 12, 9]
    }],
    xaxis: {
      categories: ['Twitter', 'Facebook', 'Google'],
      tickAmount: 5
    },
    yaxis: {
      opposite: yaxis_opposite
    },
    tooltip: {
      y: {
        formatter: function(value, { series, seriesIndex, dataPointIndex, w }) {
          return parseInt(value)
        }
      }
    }
  }
  var connectedPlatformBarChart = new ApexCharts(
    document.querySelector("#connected-platform-bar-chart"),
    connectedPlatformBarChartOptions
  );
  connectedPlatformBarChart.render();

  // Heat Map Chart
  // -----------------------------
  function generateData(count, yrange) {
    var i = 0,
      series = [];
    while (i < count) {
      var x = 'w' + (i + 1).toString(),
        y = Math.floor(Math.random() * (yrange.max - yrange.min + 1)) + yrange.min;

      series.push({
        x: x,
        y: y
      });
      i++;
    }
    return series;
  }
  var heatChartOptions = {
    chart: {
      height: 350,
      type: 'heatmap',
    },
    dataLabels: {
      enabled: false
    },
    colors: [$primary],
    series: [{
      name: 'Metric1',
      data: generateData(18, {
        min: 0,
        max: 90
      })
    },
    {
      name: 'Metric2',
      data: generateData(18, {
        min: 0,
        max: 90
      })
    },
    {
      name: 'Metric3',
      data: generateData(18, {
        min: 0,
        max: 90
      })
    },
    {
      name: 'Metric4',
      data: generateData(18, {
        min: 0,
        max: 90
      })
    },
    {
      name: 'Metric5',
      data: generateData(18, {
        min: 0,
        max: 90
      })
    },
    {
      name: 'Metric6',
      data: generateData(18, {
        min: 0,
        max: 90
      })
    },
    {
      name: 'Metric7',
      data: generateData(18, {
        min: 0,
        max: 90
      })
    },
    {
      name: 'Metric8',
      data: generateData(18, {
        min: 0,
        max: 90
      })
    },
    {
      name: 'Metric9',
      data: generateData(18, {
        min: 0,
        max: 90
      })
    }
    ],
    yaxis: {
      opposite: yaxis_opposite
    }
  }
  var heatChart = new ApexCharts(
    document.querySelector("#heat-map-chart"),
    heatChartOptions);
  heatChart.render();
});
