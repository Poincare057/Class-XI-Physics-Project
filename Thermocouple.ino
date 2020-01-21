#include <max6675.h>

int soPin = 10;
int csPin = 7;
int sckPin = 4;


MAX6675 robojax(sckPin, csPin, soPin);
double temps[5][7];
int st = 0;
double temp1 = 0;
double temp2 = 0;
double calibrate_value;

void setup() {
  Serial.begin(9600);
  Serial.println("Robojax MAX6675");
  calibrate_value = robojax.readCelsius();
  Serial.println(calibrate_value);
    while (true){
      calibrate_value = robojax.readCelsius();
      Serial.println(calibrate_value);
        if ((calibrate_value >= 33) && (calibrate_value <= 35)){
            Serial.println("Start heating");
            break;
          }
          delay(500);
    }
  
  Serial.println("Start Heating now for 2 minutes 10 seconds");
  delay(130000);
  Serial.println("Stop Heating");
 
  
  for (int iter = 0; iter < 35; iter++){    
     Serial.print("Temperature at point = ");
     temp1 = robojax.readCelsius();
     Serial.println(temp1);
     temps[iter%5][st] = temp1;
     delay(24000);
     if (iter % 5 == 4){
        Serial.println("Cool the scale");
        st += 1;
        delay(120000);            // cooling time
        Serial.println(robojax.readCelsius());
        Serial.println("Start Heating now for 2 minutes 10 seconds");
        delay(130000);
     }
  }
  for (int i = 0; i <5; i++){
             for (int j = 0; j < 7; j++){
                Serial.print(temps[i][j]);
                Serial.print(" ");
              }
        Serial.println();
  }
  
}

void loop() {

}
