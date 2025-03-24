const http = require('http');
function getFromEsp32(req,res) {
    const options = {
        hostname: '172.168.0.135',
        port: 30000,
        path: '/get-data',
        method: 'GET'
    };

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

}

module.exports.getFromEsp32 = getFromEsp32;