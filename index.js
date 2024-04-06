const express = require('express');
const os = require('os');

const app = express();

app.get('/', (req, res) => {
  const ipAddress = req.ip;
  const hostname = os.hostname();
  const version = process.env.VERSION;

  res.send(`
    <h1>Informacje o serwerze</h1>
    <p>Adres IP: ${ipAddress}</p>
    <p>Nazwa serwera: ${hostname}</p>
    <p>Wersja aplikacji: ${version}</p>
  `);
});

app.listen(3000, () => {
  console.log('App listening to 3000');
});