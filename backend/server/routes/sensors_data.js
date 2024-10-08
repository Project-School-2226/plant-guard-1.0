const express  = require('express');
const router = express.Router();
const  {getFromEsp32} = require('../utils/sensorFunctions');
const http = require('http');

router.post('/post-data-to-server' , (req,res) => {
	const data = req.body;
	console.log("Data received " + data.N,data.P,data.K,data.temperature,data.soilMoisture,data.humidity);
	res.status(200);
})

router.get('/get-from-esp32', (req, res) => {
    try {
      getFromEsp32(req,res);
    }
    catch (error) {
      console.error(`Error getting data from ESP32: ${error}`);
      res.status(500).send('Error getting data from ESP32.');
    }
  });

module.exports = router;