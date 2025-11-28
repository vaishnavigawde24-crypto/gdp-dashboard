<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Weather Dashboard</title>
  <link rel="stylesheet" href="style.css" />
</head>
<body>
  <div class="container">
    <h1>Weather Dashboard</h1>

    <div class="search">
      <input type="text" id="cityInput" placeholder="Enter city name">
      <button id="searchBtn">Search</button>
    </div>

    <div id="weatherCard" class="weather-card hidden">
      <h2 id="cityName"></h2>
      <p id="description"></p>
      <p><strong>Temperature:</strong> <span id="temp"></span>°C</p>
      <p><strong>Humidity:</strong> <span id="humidity"></span>%</p>
      <p><strong>Wind Speed:</strong> <span id="wind"></span> m/s</p>
    </div>

    <div id="error" class="error hidden"></div>
  </div>

  <script src="app.js"></script>
</body>
</html>
