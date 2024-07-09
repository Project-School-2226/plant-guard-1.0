const express = require('express')
require('dotenv').config();
const app = express();
const bodyParser = require('body-parser');
const http = require('http');
const mysql = require('mysql');
const cors = require('cors');
const { default: axios } = require('axios');


 
// Middleware to parse incoming request bodies
app.use(cors());
app.use(bodyParser.json());

app.post('/post-data-to-server' , (req,res) => {
	const data = req.body;
	console.log("Data received " + data.N,data.P,data.K,data.temperature,data.humidity,data.pH);
	res.status(200);
})

app.post('/send-query-response', (req,res) => { 
  const question = req.body.question;
  axios.post('http://127.0.0.1:5000/predict' , {"question": question})
    .then((response) => { 
      res.status(200).json(response.data);
    }) .catch((error) => { 
      res.status(500).send('Error getting response from model');
    });
})

app.get('/get-from-esp32', (req, res) => {
  const options = {
    hostname: '172.168.4.14',
    port: 30000,
    path: '/get-data',
    method: 'GET'
  };

  res.send(200).json({message: 'Request sent to ESP32.'});

  const reqToESP32 = http.request(options, (responseFromESP32) => {
    let data = '';

    responseFromESP32.on('data', (chunk) => {
      data += chunk;
    });

    responseFromESP32.on('end', () => {
      console.log(`Data received from ESP32: ${data}`);
      try {
        const parsedData = JSON.parse(data); // Parse the data to JSON
        res.json(parsedData); // Send the parsed data as JSON
      } catch (error) {
        console.error(`Error parsing data from ESP32: ${error}`);
        res.status(500).send('Error parsing data from ESP32.');
      }
    });
  });

  reqToESP32.on('error', (error) => {
    console.error(`Error sending request to ESP32: ${error}`);
    res.status(500).send('Error sending request to ESP32.');
  });

  reqToESP32.end();
});

const PORT = process.env.PORT || 3000;
const IP_ADDRESS = '172.168.3.5';
app.listen(PORT , IP_ADDRESS , () => {
  console.log(`Server is running on http://${IP_ADDRESS}:${PORT}`);
});
