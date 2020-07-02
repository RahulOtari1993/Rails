$(document).ready(function () {
  // Line-Chart For Shares Per day
  google.charts.load("current", {packages:["corechart"]});
  google.charts.setOnLoadCallback(drawChartForShares);
  function drawChartForShares() {
    var data = new google.visualization.DataTable();
    data.addColumn('date', 'Time of Day');
    data.addColumn('number', 'Platform');
    data.addRows([
      [new Date(2020, 6, 1), 5],  [new Date(2020, 6, 2), 7],  [new Date(2020, 6, 3), 3],
      [new Date(2020, 6, 4), 1],  [new Date(2020, 6, 5), 3],  [new Date(2020, 6, 6), 4],
      [new Date(2020, 6, 7), 3],  [new Date(2020, 6, 8), 4],  [new Date(2020, 6, 9), 2],
      [new Date(2020, 6, 10), 5], [new Date(2020, 6, 11), 8], [new Date(2020, 6, 12), 6],
      [new Date(2020, 6, 13), 3], [new Date(2020, 6, 14), 3], [new Date(2020, 6, 15), 5],
      [new Date(2020, 6, 16), 7], [new Date(2020, 6, 17), 6], [new Date(2020, 6, 18), 6],
      [new Date(2020, 6, 19), 3], [new Date(2020, 6, 20), 1], [new Date(2020, 6, 21), 2],
      [new Date(2020, 6, 22), 4], [new Date(2020, 6, 23), 6], [new Date(2020, 6, 24), 5]
    ]);

    var options = {
      hAxis: {
        format: 'd/M/yy',
        gridlines: {color: 'none', count: 15},
        textStyle: {color: '#FFF'}
      },
      vAxis: {
        gridlines: {color: '#FFF',count: 15},
        minValue: 0,
        maxValue: 10,
        textStyle: {color: '#FFF'}
      }
    };

    var chartForShares = new google.visualization.LineChart(document.getElementById('share-per-day-line-chart'));
    chartForShares.draw(data, options);
	}

});