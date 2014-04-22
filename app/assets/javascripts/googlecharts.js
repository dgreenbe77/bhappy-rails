google.load('visualization', '1', {'packages': ['geochart']});
google.setOnLoadCallback(drawWorldMarkersMap);

function drawWorldMarkersMap() {
var happiness_logs = gon.happiness_logs;
var data = google.visualization.arrayToDataTable([['Location']]);
data.addColumn('number', 'Happy Scale');

happiness_logs.forEach( function (arrayItem) {
   data.addRows([
     [arrayItem['address'], arrayItem['happy_scale']]
   ]);
});

var options = {
  region: gon.region,
  displayMode: 'markers',
  colorAxis: {colors: ['blue', 'red']}
};

var chart = new google.visualization.GeoChart(document.getElementById('world_map_div'));
chart.draw(data, options);
};


google.load('visualization', '1', {'packages':['annotatedtimeline']});
google.setOnLoadCallback(drawWorldChart);
function drawWorldChart() {
  var data = new google.visualization.DataTable();
  data.addColumn('datetime', 'Date');
  data.addColumn('number', 'Happiness');

  var date = gon.date;
  var happiness_log = gon.happiness_logs;
  happiness_log.forEach( function (arrayItem) {
    for (var i in date) {
      data.addRows([
       [new Date(Date.parse(date[i])), arrayItem['happy_scale']]
       ]);
    }
  });

  var options = {
    colors: ['#e0440e'],
    displayAnnotations: true,
    max: 10,
    wmode: 'opaque',
    fill: 50,
    thickness: 3,
  };

  var chart = new google.visualization.AnnotatedTimeLine(document.getElementById('world_chart_div'));

  chart.draw(data, options);
}


google.load('visualization', '1', {'packages':['annotatedtimeline']});
google.setOnLoadCallback(drawChart);
function drawChart() {
  var data = new google.visualization.DataTable();
  data.addColumn('datetime', 'Date');
  data.addColumn('number', 'Happiness');
  data.addColumn('number', 'Image Analysis');
  data.addColumn('string', 'Post');

  var date = gon.date;
  var happiness_log = gon.happiness_logs;
  happiness_log.forEach( function (arrayItem) {
    for (var i in date) {
      data.addRows([
       [new Date(Date.parse(date[i])), arrayItem['happy_scale'], arrayItem['smile_scale'], arrayItem['main_post']]
       ]);
    }
  });

  var options = {
    colors: ['#e0440e', '#FFCC00'],
    displayAnnotations: true,
    max: 10,
    fill: 10,
    wmode: 'opaque',
    thickness: 2
  };

  var chart = new google.visualization.AnnotatedTimeLine(document.getElementById('chart_div'));

  chart.draw(data, options);
}


google.load('visualization', '1', {'packages': ['geochart']});
google.setOnLoadCallback(drawMarkersMap);

function drawMarkersMap() {
var happiness_log = gon.happiness_logs;
var data = google.visualization.arrayToDataTable([['Location']]);
data.addColumn('number', 'Happy Scale');

happiness_log.forEach( function (arrayItem) {
   data.addRows([
     [arrayItem['address'], arrayItem['happy_scale']]
   ]);
});

var options = {
  region: gon.region,
  displayMode: 'markers',
  colorAxis: {colors: ['blue', 'red']}
};

var chart = new google.visualization.GeoChart(document.getElementById('map_div'));
chart.draw(data, options);
};


google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(drawPieChart);
function drawPieChart() {
  var data = google.visualization.arrayToDataTable(
    [['On a 0-10 scale, with 5 being your average mentions of the subject']]);
  data.addColumn('number', 'Scale');
  
  var happiness_log = gon.current_happiness_log;

  data.addRows([
    ['Health', happiness_log['health_scale']],
    ['Wealth', happiness_log['wealth_scale']],
    ['Culture', happiness_log['culture_scale']],
    ['Location', happiness_log['location_scale']],
    ['Spirituality', happiness_log['spirituality_scale']],
    ['Relationship', happiness_log['relationship_scale']],
    ['Activity', happiness_log['activity_scale']],
    ['Passion', happiness_log['passion_scale']],
    ['Satisfaction', happiness_log['satisfaction_scale']],
    ['Self-View', happiness_log['self_view_scale']]
  ]);

  var options = {
    title: 'On a 0-10 scale, with 5 being your average mentions of the subject',
    pieHole: 0.4,
  };

  var chart = new google.visualization.PieChart(document.getElementById('donutchart'));
  chart.draw(data, options);
}
