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
  var ageBarChart = new ApexCharts(document.querySelector("#age-bar-chart"), ageBarChartOptions);
  ageBarChart.render();


  // Pie Chart For Gender Breakdown
  // ----------------------------------
  var genderPieChartOptions = {
    chart: {
      type: 'pie',
      height: 350
    },
    colors: themeColors,
    labels: ['Male', 'Female', 'Gender Diverse', 'No Answer'],
    series: [45,12,34,12],
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
  var genderPieChart = new ApexCharts(document.querySelector("#gender-pie-chart"), genderPieChartOptions);
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
  var completedChallengeBarChart = new ApexCharts(document.querySelector("#completed-challenge-bar-chart"), completedChallengeBarChartOptions);
  completedChallengeBarChart.render();


  // Bar Chart For Connected Platforms
  // ----------------------------------
  var connectedPlatformBarChartOptions = {
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
  var connectedPlatformBarChart = new ApexCharts(document.querySelector("#connected-platform-bar-chart"), connectedPlatformBarChartOptions);
  connectedPlatformBarChart.render();


  // Google Geo-Chart For Users By Location
  var campaignId = $('#user-by-location-geo-chart').attr('campaign_id');
  if (campaignId != undefined) {
    var url = "/admin/campaigns/" + campaignId + "/users/get_data_for_geochart_map";
    $.getJSON(url, function(response) {

      google.charts.load('current', {
        'packages':['geochart'],
        // Note: you will need to get a mapsApiKey for your project.
        // See: https://developers.google.com/chart/interactive/docs/basic_load_libs#load-settings
        'mapsApiKey': 'AIzaSyD-9tSrke72PouQMnMX-a7eZSW0jkFMBWY'
      });
      google.charts.setOnLoadCallback(drawRegionsMap);

      function drawRegionsMap() {
        var data = google.visualization.arrayToDataTable(response);

        var options = {
          region: 'US',
          displayMode: 'regions',
          resolution: 'provinces',
        };

        var chart = new google.visualization.GeoChart(document.getElementById('user-by-location-geo-chart'));
        chart.draw(data, options);
      }

    });
  }

});
