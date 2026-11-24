const http = require('http');

const PORT = 8000;
const ENV = process.env.NODE_ENV || 'brak';
const DEBUG = process.env.DEBUG || 'false';

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify({
    message: 'Wersja 3: Działa!',
    environment: ENV,
    debugMode: DEBUG,
    timestamp: new Date().toISOString()
  }, null, 2));
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Serwer uruchomiony na porcie ${PORT} (ENV: ${ENV}, DEBUG: ${DEBUG})`);
});
