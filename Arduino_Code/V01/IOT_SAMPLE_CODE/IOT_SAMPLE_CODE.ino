#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

ESP8266WebServer server(80);

String ssid = "";
String password = "";

void handleRoot() {
  server.send(200, "text/html", "ESP is working");
}

void handleSendMessage() {
  if (server.hasArg("text")) {
    String msg = server.arg("text");
    Serial.println("Received: " + msg);
    server.send(200, "text/plain", "Hi Alireza");
  } else {
    server.send(400, "text/plain", "No message received");
  }
}

void handleSetWiFi() {
  if (server.hasArg("ssid") && server.hasArg("pass")) {
    ssid = server.arg("ssid");
    password = server.arg("pass");
    server.send(200, "text/plain", "Trying to connect to new WiFi...");
    delay(1000);
    WiFi.begin(ssid.c_str(), password.c_str());
    int count = 0;
    while (WiFi.status() != WL_CONNECTED && count < 20) {
      delay(500);
      Serial.print(".");
      count++;
    }
    if (WiFi.status() == WL_CONNECTED) {
      Serial.println("Connected to WiFi");
      Serial.println(WiFi.localIP());
    } else {
      Serial.println("Failed to connect");
    }
  } else {
    server.send(400, "text/plain", "Missing ssid or pass");
  }
}

void setup() {
  Serial.begin(115200);
  WiFi.softAP("ESP-Setup", "12345678");
  Serial.println("AP Mode Started. Connect to ESP-Setup");

  server.on("/", handleRoot);
  server.on("/message", handleSendMessage);
  server.on("/setwifi", handleSetWiFi);
  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  server.handleClient();
}
