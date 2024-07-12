const express  = require('express');
const router = express.Router();
const axios = require('axios');

router.post('/send-query-response', (req,res) => { 
    const question = req.body.question;
    axios.post('http://127.0.0.1:5000/predict' , {"question": question})
      .then((response) => { 
        if(response.data.prediction == 'real time sensor data') { 
          res.status(200).send('fetching real time data');
        } 
        else{
          res.status(200).send(response.data);
        
        }
      }) .catch((error) => { 
        res.status(500).send('Error getting response from model');
      });
  })

module.exports = router;