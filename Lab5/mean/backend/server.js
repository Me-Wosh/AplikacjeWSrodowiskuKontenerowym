const express = require('express');
const mongoose = require('mongoose');

const app = express();
const PORT = process.env.PORT || 3000;
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/mean_app';

// Nawiązanie połączenia z MongoDB
mongoose.connect(MONGO_URI)
  .then(() => console.log('Połączono z MongoDB'))
  .catch((err) => console.error('Błąd połączenia z MongoDB:', err));

// Healthcheck
app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'OK', uptime: process.uptime() });
});

// 2. Endpoint weryfikujący połączenie z bazą danych
app.get('/api/db-check', async (req, res) => {
  // mongoose.connection.readyState: 0 = disconnected, 1 = connected, 2 = connecting, 3 = disconnecting
  const isConnected = mongoose.connection.readyState === 1;

  if (!isConnected) {
    return res.status(503).json({
      database: 'disconnected',
      readyState: mongoose.connection.readyState
    });
  }

  try {
    await mongoose.connection.db.admin().ping();
    res.status(200).json({ database: 'connected', ping: 'pong' });
  } catch (error) {
    res.status(500).json({ database: 'error', message: error.message });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Serwer Express działa na porcie ${PORT}`);
});
