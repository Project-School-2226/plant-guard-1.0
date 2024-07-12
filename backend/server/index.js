const express = require('express')
require('dotenv').config();
const app = express();
const bodyParser = require('body-parser');
const http = require('http');
const mysql = require('mysql');
const cors = require('cors');
const { default: axios } = require('axios');
const { connectToDatabase, pool } = require('./database/db');

const sensorDataRouter = require('./routes/sensors_data');
const userQueryHandlerRouter = require('./routes/user_query_handler');

const { connectToDatabase, pool } = require('./database/db');


// Middleware to parse incoming request bodies
app.use(cors());
app.use(bodyParser.json());

//sensor routes
app.use('/sensors-data', sensorDataRouter);
app.use('/query', userQueryHandlerRouter);

// Start the server
const PORT = process.env.PORT || 3000;
const IP_ADDRESS = '192.168.0.100';

connectToDatabase().then(() => {
  // Start the server after a successful database connection
  app.listen(PORT , IP_ADDRESS , () => {
    console.log(`Server is running on http://${IP_ADDRESS}:${PORT}`);
  });
}).catch(err => {
  console.error('Failed to connect to the database. Exiting...');
  process.exit(1);
});

app.get('/test-db-connection', async (req, res) => { 
  data = await pool().query("select * from sensordata limit 5");
  return res.json(data[0]);
})



