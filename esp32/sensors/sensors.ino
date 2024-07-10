#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <WebServer.h>
#include <DHTesp.h>
using namespace std;

//definitions for pin numbers 
const int soilHumidityPin = 34; // Define the analog pin for the soil moisture sensor
const int atmTemp = 5;
const int dryValue = 2000; // Define the analog value when the soil is dry
const int wetValue = 1000; // Define the analog value when the soil is wet
typedef int se_p;

DHTesp dht;

const char* ssid = "Test";
const char* password = "Welcome@123";
const char* serverUrl = "http://172.168.3.5:64000/"; // Adjust the server URL
const unsigned long sendDataInterval = 5000; // Interval for sending data to server (milliseconds)

// Variables to store sensor data
float sensorData[6] = {0}; // Change the size and type according to your sensor data
WebServer server(30000); // Define a WebServer instance listening on port 80
// Function to format data into JSON


//function prototypes
float handleMoisturePer(float);

class SensorValues {
  private:se_p moisture_pin;
  private:se_p temperature_pin;

  public:SensorValues(se_p humidity_pin, se_p temperature_pin) {
    this->moisture_pin = moisture_pin;
    this->temperature_pin = temperature_pin;
  }

  float getTemperature() {
    return dht.getTemperature();
  }

  int getSoilMoisture(){
    return analogRead(soilHumidityPin);
  }

};

String formatData(float N, float P, float K, float temp, float humidity, float pH) {
  StaticJsonDocument<200> doc;
  doc["N"] = N;
  doc["P"] = P;
  doc["K"] = K;
  doc["temperature"] = temp;
  doc["humidity"] = humidity;
  doc["pH"] = pH;
  String jsonString;
  serializeJson(doc, jsonString);
  return jsonString;
}



// Function to send data to server
void sendDataToServer() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(serverUrl);
    http.addHeader("Content-Type", "application/json");

    String jsonData = formatData(sensorData[0], sensorData[1], sensorData[2], sensorData[3], sensorData[4], sensorData[5]);

    int httpResponseCode = http.POST(jsonData);

    if (httpResponseCode > 0) {
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
    } else {
      Serial.print("Error sending HTTP request: ");
      Serial.println(httpResponseCode);
    }

    http.end();
  }
}
SensorValues sens_vals(soilHumidityPin, atmTemp);


void handleGetRequest(){
  String responseMessage = "This is a GET request!";

  String jsonData = formatData(sensorData[0], sensorData[1], sensorData[2], sens_vals.getTemperature(), handleMoisturePer(sens_vals.getSoilMoisture()), sensorData[5]);
  server.send(200, "application/json", jsonData);
}

float handleMoisturePer(float val) {

  int moisturePercentage = map(val, dryValue, wetValue, 0, 100);
  moisturePercentage = constrain(moisturePercentage, 0, 100); // Ensure the percentage stays within 0-100

  return moisturePercentage;

}

void setup() {
  Serial.begin(115200);
  dht.setup(atmTemp, DHTesp::DHT22); // Connect DHT sensor to GPIO 5
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
    Serial.println("Connected to WiFi");
    Serial.print("ESP32 IP Address: ");
    Serial.println(WiFi.localIP());
      
    server.on("/get-data", HTTP_GET, handleGetRequest);
  // Start the HTTP server
    server.begin();
    
    
}


void loop() {

  float temperature = sens_vals.getTemperature();
  int soilMoisture = sens_vals.getSoilMoisture();

  int moisturePercentage = map(soilMoisture, dryValue, wetValue, 0, 100);
  moisturePercentage = constrain(moisturePercentage, 0, 100); // Ensure the percentage stays within 0-100

  // Update sensor data array
  sensorData[3] = temperature; // Assuming temperature is stored at index 3
  sensorData[4] = moisturePercentage; // Assuming soil moisture is stored at index 4
  // Send data to server periodically
  static unsigned long lastSendTime = 0;
  unsigned long currentTime = millis();
  if (currentTime - lastSendTime >= sendDataInterval) {
    sendDataToServer();
    lastSendTime = currentTime;
  }

  server.handleClient();  
// Other code here as needed
}