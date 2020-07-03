$(document).ready(function () {
  // Line-Chart For Shares Per day
  google.charts.load("current", {packages:["corechart"]});
  google.charts.setOnLoadCallback(drawChartForShares);
  function drawChartForShares() {
    var data = new google.visualization.DataTable();
    data.addColumn('date', 'Time of Day');
    data.addColumn('number', 'Shares');
    data.addRows([
      [new Date(2020, 6, 1), 5],  [new Date(2020, 6, 2), 7],  [new Date(2020, 6, 3), 3],
      [new Date(2020, 6, 10), 8], [new Date(2020, 6, 11), 8], [new Date(2020, 6, 12), 10],
      [new Date(2020, 6, 13), 3], [new Date(2020, 6, 14), 2], [new Date(2020, 6, 15), 5],
      [new Date(2020, 6, 16), 7], [new Date(2020, 6, 17), 6], [new Date(2020, 6, 18), 6],
      [new Date(2020, 6, 22), 4], [new Date(2020, 6, 23), 6], [new Date(2020, 6, 24), 5]
    ]);

    var options = {
    	pointSize: 5,
      pointShape: 'circle',
      backgroundColor: '#262C49',
      legend: { position: 'top' },
      hAxis: {
        format: 'd/M/yy',
        gridlines: {color: 'none', count: 15},
        textStyle: {color: '#FFF'}
      },
      vAxis: {
        gridlines: {color: '#FFF',count: 15},
        minValue: 0,
        maxValue: 10,
        textStyle: {color: '#FFF'},
        ticks: [1, 2,3, 4,5, 6,7, 8,9, 10]
      },
      legendTextStyle: { color: '#FFF' }
    };

    var chartForShares = new google.visualization.LineChart(document.getElementById('share-per-day-line-chart'));
    chartForShares.draw(data, options);
	}

	// Google Geo-Chart For Users By Location
	google.charts.load('current', {
    'packages':['geochart'],
    // Note: you will need to get a mapsApiKey for your project.
    // See: https://developers.google.com/chart/interactive/docs/basic_load_libs#load-settings
    'mapsApiKey': 'AIzaSyD-9tSrke72PouQMnMX-a7eZSW0jkFMBWY'
  });
  google.charts.setOnLoadCallback(drawChartForUsers);

  function drawChartForUsers() {
    var data = google.visualization.arrayToDataTable([
      ['Country', 'Users'],
      ['Germany', 200],
      ['USA', 300],
      ['Brazil', 400],
      ['Canada', 500],
      ['France', 600],
      ['Italy', 125],
      ['China', 323],
      ['Russia', 725],
      ['Japan', 425],
      ['Hong Kong', 99],
      ['Australia', 289],
      ['New Zealand', 255]
    ]);

    var options = {
      backgroundColor: '#262C49'
    };

    var chartForUsers = new google.visualization.GeoChart(document.getElementById('user-by-location-geo-chart'));
    chartForUsers.draw(data, options);
  }
});