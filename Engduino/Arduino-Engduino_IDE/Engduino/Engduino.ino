//This Engduino app takes sensor data and outputs it through the serial port at certain amounts of time
//A single type of data is forwarded at one time and the switch between types is made by pressing the button
//A light show is made from the LEDs, which move around at the rate at which signals are sent through the port

//Libraries for sensor management and Engduino tools
#include <EngduinoButton.h>
#include <EngduinoThermistor.h>
#include <EngduinoLight.h>
#include <EngduinoAccelerometer.h>
#include <EngduinoMagnetometer.h>
#include <EngduinoLEDs.h>
#include <Wire.h>

const int appMaxID = 3; //A constant value which specifies the number of output types Engduino sends through the port 

int appID = 0;          //Used to monitor the current type of output sent through serial port
int firstLED = 2;       //Value used to monitor the first LED lit in the series

//Setup specific function, called once at the beginning of the program in order to set up the tools we will use
void setup() 
{
    //Starting the needed sensors and tools on Engduino
    EngduinoLEDs.begin();
    EngduinoButton.begin();
    EngduinoThermistor.begin();
    EngduinoLight.begin();
    EngduinoAccelerometer.begin();
    EngduinoMagnetometer.begin();
    //Starting serial port writing at a rate of 9600
    Serial.begin(9600);
}

//The function where the LED light show will be computed based on 3 LEDs
void showLED()
{
    //First, we set all the LEDs off
    EngduinoLEDs.setAll(OFF);
  
    int middleLED, lastLED;
    
    //Depending on the position of the first LED in the row, 
    //we compute the position of the second one
    if(firstLED > 0)
      middleLED = firstLED - 1;
    else 
      middleLED = 15;
    
    //Depending on the position of the first LED in the row, 
    //we compute the position of the last one
    if(firstLED > 1)
      lastLED = firstLED - 2;
    else if(firstLED == 1)
      lastLED = 15;
    else
      lastLED = 14;
      
    //We set a specific colour to each LED used
    EngduinoLEDs.setLED(firstLED, BLUE);
    EngduinoLEDs.setLED(middleLED, YELLOW);
    EngduinoLEDs.setLED(lastLED, RED);
    
    //We iterate firstLED to the next available LED
    firstLED++;
    if(firstLED == 16)
      firstLED = 0;
}

//The loop function is specific and will be repeated over and over until the program is closed
//Here, we will transmit all our data through the serial port and we will call the light show
void loop() 
{
 
    //Calling the function responsible for the light show
    showLED();
  
    //Declaring values which will be used to retreive the sensor data
    float tempCelsius;
    int lightValue;
    float acceleration[3];
    float magnetometer[3];
    
    //The switch statement decides which type of data should the Engduino transmit based on the appID
    //Every case has a special string which will pe printed before the vaules in order for them to be 
    //reconised in the desktop application
    switch(appID)
    {
      //TEMPERATURE - CASE 0
      case 0:
        //Taking the temperature from the sensor
        tempCelsius = EngduinoThermistor.temperature();
    
        //Printing the case special string and the temperature value to the serial port 
        Serial.print("temp ");
        Serial.print( tempCelsius );
        Serial.print(" ");
        
        //Including a short delay so that the desktop application will have time to read it
        delay(222);
        
        break;
        
      //LIGHT - CASE 1
      case 1:
        //Taking the temperature from the sensor 
        lightValue = EngduinoLight.lightLevel();
        
        //Printing the case special string and the light value to the serial port 
        Serial.print("light ");
        Serial.print( lightValue );
        Serial.print(" ");
        
        //Including a short delay so that the desktop application will have time to read it
        delay(222);
        
        break;
        
      //ACCELEROMETER - CASE 2
      case 2:
        //Taking the x, y, z values from the accelerometer and storing them in the 'acceleration' array
        EngduinoAccelerometer.xyz(acceleration);
        
        //Printing the case special string and the accelerometer values to the serial port 
        Serial.print("acc ");
        Serial.print( acceleration[0] );
        Serial.print(" ");
        Serial.print( acceleration[1] );
        Serial.print(" ");
        Serial.print( acceleration[2] );
        Serial.print(" ");
        
        //Including a short delay so that the desktop application will have time to read it
        //This is slightly more than the previous ones since Engduino has to output more values
        delay(300);
        
        break;
        
      case 3:
        //Taking the x, y, z values from the magnetometer and storing them in the 'magnetometer' array
        EngduinoMagnetometer.xyz(magnetometer);
        
        //Printing the case special string and the accelerometer values to the serial port 
        Serial.print("magnet ");
        Serial.print( magnetometer[0] );
        Serial.print(" ");
        Serial.print( magnetometer[1] );
        Serial.print(" ");
        Serial.print( magnetometer[2] );
        Serial.print(" ");
        
        //Including a short delay so that the desktop application will have time to read it
        //This is slightly more because Engduino has to output more values
        delay(300);
        
        break;
      
      default:
        //Printing an error if appID goes out of range
        Serial.print("Error! No application available!");
        
        //Including a short delay so that the desktop application will have time to read it
        delay(222);
        
        break;
    
    }
    
    if( EngduinoButton.wasPressed() )
    {
      //When button was pressed,
      //Go to the next application available in the range
      //Or start all over again
      if(appID < appMaxID)
        appID++;
      else appID = 0;
    }
   
}
