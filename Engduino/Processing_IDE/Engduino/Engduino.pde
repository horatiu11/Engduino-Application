//This application uses a program created in Processing IDE in order to receive data from 
//an Engduino through serial port. Depending on the type of data received(temperature, light level,
//accelerometer data, magnetometer data), it displays some certain values and figures using a real-time
//drawing.

//Using serial library from processing in order to use functions and types
//for reading from the serial port
import processing.serial.*;

//Defining variables and arrays of different types that we will use
//further in the program

String lastCase = null;

//Variables used for iterating through the graph display
float xTemp = 0, yTemp = 360;
float xLight = 0, yLight = 360;
float xAcc = 0, yAcc = 360;
float xMagnet = 0, yMagnet = 360;

//----------->Variables storing data atfer reading values from serial port
float tempCelsius;
float maxTemperature = -300, minTemperature = 300;

int lightLevel;
int maxLight = 0, minLight = 1025;

float[] accelerations = new float[3];
final float step = 0.2;

float[] magnetometer = new float[3];
float maxX = 0;
//<--------------------------

int endChar=32; //'Space' character in ASCII will be used to mark the end of a value 

Serial myPort;  //The port variable in which we will store the serial port's details

//In this function we search through the list of ports and find the one who receives
//data from the Engduino
void findSerialPort()
{
  //Get a list of the serial ports
  String[] listPorts = Serial.list();
  
  for (int i = 0; i < listPorts.length; i++)
  {
    //Iterating through serial ports and trying to find the correct one
    try
    {
      
      if (!listPorts[i].contains("cu.usbmodem"))
      {
        //If a port is a proper one(USB), we try to connect to it
        myPort = new Serial(this, listPorts[i], 9600);
        
        delay(10);      //delay used to assure time for connection
        
        //If the port is available, we have found the correct port
        if (myPort.available() > 0)
        {
          if (myPort.readStringUntil('.').equals("OFF."))
          {
            break;
          }
        }
      }
    }
    catch(RuntimeException e)
    {
      //An error occured!
    }
  }
}

//The setup function is specific and it is used once to initialise basic tools
// and variables, before anything else in the program
void setup()
{
  //Setting background size and colour
  size(640, 360); //width = 640, height = 360 
  background(0);  //colour is set to black
  
  //Setting app's text size to 18
  textSize(18);
  
  //Finding the used serial port by calling findSerialPort() function
  findSerialPort();
  
  // If there is an active port, throw out the first reading, in case 
  // we started reading in the middle of a string from the sender.
  if(myPort != null)
    myPort.clear();
  
}
 
// read() is used for determining which type of application to run(temperature,
// light sensor, accelerometer, magnetometer) depending on a marker received from the Engduino
// It also initialises the global variables and arrays used later with the values read from serial.
int read()
{
  //Read until the end of the current value (until 'space' character is found)
  String myString = myPort.readStringUntil( endChar );
  int appID;
  
  //Switching bewtween the four types of applications depending on the first string received from
  //Engduino, which is used as a marker and has also four types("temp ", "light ", "acc ", "magnet ")
  switch(myString)
  {
    case "temp ":

      if( ! myString.equals(lastCase))
      {
        //If our current string(marker) is different from the previous string(marker), it shows
        //that we switched between two types of applications, so we reinitialise everything
        
        background(0);   //background is set to black
        
        //We display support text at certain (x, y) position using Processing's text() function
        fill(255);       //filling text with white colour
        text("Temperature:", 10, 20);
        text("Maximum Temperature:", 10, 50);
        text("Minimum Temperature:", 10, 80);
        text("Temperature Graph", 220, 110);
        
        //Initialising two values for the temperature graph display 
        xTemp = 0; yTemp = 360;

      }
      
      //Our last marker becomes the current marker for the next time we will receive data
      //We give a certain id for the app which will be returned to the main program
      lastCase = myString;
      appID = 0;
      
      //We read the value following the marker until the 'space' character is found in order to display it
      //If the read string is not null, it is converted to float and filled in the tempCelsius variable
      myString = myPort.readStringUntil( endChar );
      if(myString != null)
        tempCelsius = float(myString);
    
      //Update the maximum and minimum temperature if it is the case
      if(maxTemperature < tempCelsius) 
        maxTemperature = tempCelsius;
    
      if(minTemperature > tempCelsius) 
        minTemperature = tempCelsius;
      break;
     
    case "light ":
      
      if( ! myString.equals(lastCase))
      {
        //If our current string(marker) is different from the previous string(marker), it shows
        //that we switched between two types of applications, so we reinitialise everything
        
        background(0);    //background is set to black
        
        //We display support text at certain (x, y) position using Processing's text() function
        fill(255);        //filling text with white colour
        text("Light Level:", 10, 20);
        text("Maximum Light Level:", 10, 50);
        text("Minimum Light Level:", 10, 80);
        text("Light Graph", 250, 110);
        
        //Initialising two values for the light graph display 
        xLight = 0; yLight = 360;

      }
      
      //Our last marker becomes the current marker for the next time we will receive data
      //We give a certain id for the app which will be returned to the main program
      lastCase = myString;
      appID = 1;
      
      //We read the value following the marker until the 'space' character is found in order to display it
      //If the read string is not null, it is converted to int and filled in the lightLevel variable
      myString = myPort.readStringUntil( endChar );
      if(myString != null)
        lightLevel = (int) float( myString );
    
      //Update the maximum and minimum light level if it is the case
      if(maxLight < lightLevel) 
        maxLight = lightLevel;
    
      if(minLight > lightLevel) 
        minLight = lightLevel;
        
      break;
     
    case "acc ":
    
      if( ! myString.equals(lastCase))
      {
        //If our current string(marker) is different from the previous string(marker), it shows
        //that we switched between two types of applications, so we reinitialise everything
        
        background(0);    //background is set to black
        
        //We display support text at certain (x, y) position using Processing's text() function
        fill(255);        //filling text with white colour
        text("Acceleration X:", 10, 20);
        text("Acceleration Y:", 10, 50);
        text("Acceleration Z:", 10, 80);
        text("G-Force:", 10, 110);
        text("G-Force Graph", 230, 140);
        text("Tilting Direction", 290, 50);
        
        //Initialising two values for the accelerometer graph display 
        xAcc = 0; yAcc = 360;
      }
      
      //Our last marker becomes the current marker for the next time we will receive data
      //We give a certain id for the app which will be returned to the main program
      lastCase = myString;
      appID = 2;
      
      //We read the values following the marker until the 'space' character is found in order to display them
      //If the read strings are not null, they are converted to float and filled in the accelerations array
      myString = myPort.readStringUntil( endChar );
      if(myString != null)
        accelerations[0] = float( myString );                    //x value
      myString = myPort.readStringUntil( endChar );
      if(myString != null)
        accelerations[1] = float( myString );                    //y value
      myString = myPort.readStringUntil( endChar );
      if(myString != null)
        accelerations[2] = float( myString );                    //z value
      
      break;
      
    case "magnet ":
      if( ! myString.equals(lastCase))
      {
        //If our current string(marker) is different from the previous string(marker), it shows
        //that we switched between two types of applications, so we reinitialise everything
        
        background(0);    //background is set to black
        
        //We display support text at certain (x, y) position using Processing's text() function
        fill(255);        //filling text with white colour
        text("Magnetic Field X:", 10, 20);
        text("Magnetic Field Y:", 10, 50);
        text("Magnetic Field Z:", 10, 80);
        text("Magnitude:", 10, 110);
        text("Magnitude Graph", 220, 140);
        text("North Detector", 340, 55);
        
        //Initialising two values for the magnetometer graph display 
        xMagnet = 0; yMagnet = 360;
      }
      
      //Our last marker becomes the current marker for the next time we will receive data
      //We give a certain id for the app which will be returned to the main program
      lastCase = myString;
      appID = 3;
      
      //We read the values following the marker until the 'space' character is found in order to display them
      //If the read strings are not null, they are converted to float and filled in the magnetometer array
      myString = myPort.readStringUntil( endChar );
      if(myString != null)
        magnetometer[0] = float( myString );                    //x value
      myString = myPort.readStringUntil( endChar );
      if(myString != null)
        magnetometer[1] = float( myString );                    //y value
      myString = myPort.readStringUntil( endChar );
      if(myString != null)
        magnetometer[2] = float( myString );                    //z value
      
      break;
      
    default:
      //If the function finds another marker, it will return another id, which correpsonds to nothing
      appID = 4;
      break;
    
  }
  
  //Returning the appID which will decide which graph and data to display further
  return appID;
}

//Function used to display the live, maximum and minimum temperatures 
//as text on the screen
void displayTemperature()
{
  //Clearing the rectangle areas where the temperature text values are displayed
  //We fill them with black, give them 'no stroke' and specify their x1, y1, x2, y2
  //coordinates using the processing's rect() function
  fill(0);
  stroke(0);
  rect(130, 0, 75, 25);
  rect(230, 30, 75, 25);
  rect(230, 60, 75, 25);
  
  //After clearing, we reset the colour to white and then display the
  //live, maximum and minimum temperature using the text() function
  fill(255);
  text(tempCelsius, 130, 20);
  text(maxTemperature, 230, 50);
  text(minTemperature, 230, 80);
}

//Function used to display the live temperature in a graph which is updated
//at every iteration of the draw() function
void displayTemperatureGraph()
{
  //In order to show the data at the proper scale, we multiply our result by 5
  //Reversing the Y axis is necessary since y = 0 is in the upper side of the screen
  yTemp = 360 - tempCelsius * 5;
  
  //If y value is lower than 130, we set it to 130 so that it won't interfere
  //with the text displayed above the graph
  if(yTemp < 130)
    yTemp = 130;
  
  //Setting the red colour in RGB - (255, 0, 0) - and drawing a temperature line for the graph 
  stroke(255, 0, 0);
  line(xTemp, 360, xTemp, yTemp);
  
  if(xTemp == 640)
  {
    //If we reach the end of the screen (x = 640), we start all over again by resetting the graph area
    //Else we keep drawing by iterating to the next x value
    xTemp = 0;
    stroke(0);
    fill(0);
    rect(0, 125, 640, 280);
  }
  else xTemp++;
}

//Function used to display the live, maximum and minimum light levels 
//as text on the screen
void displayLight()
{
  //Clearing the rectangle areas where the temperature text values are displayed
  //We fill them with black, give them 'no stroke' and specify their x1, y1, x2, y2
  //coordinates using the processing's rect() function
  fill(0);
  stroke(0);
  rect(130, 0, 75, 25);
  rect(230, 30, 75, 25);
  rect(230, 60, 75, 25);
  
  //After clearing, we reset the colour to white and then display the
  //live, maximum and minimum light level using the text() function
  fill(255);
  text(lightLevel, 130, 20);
  text(maxLight, 230, 50);
  text(minLight, 230, 80);
}

//Function used to display the live light level in a graph which is updated
//at every iteration of the draw() function
void displayLightGraph()
{
  //Reversing the Y axis is necessary since y = 0 is in the upper side of the screen
  yLight = 360 - lightLevel ;
  
  //If y value is lower than 130, we set it to 130 so that it won't interfere
  //with the text displayed above the graph
  if(yLight < 130)
    yLight = 130;
  
  //Setting the yellow colour in RGB (255, 255, 0) and drawing a light level line for the graph 
  stroke(255, 255, 0);
  line(xLight, 360, xLight, yLight);
  
  if(xLight == 640)
  {
    //If we reach the end of the screen (x = 640), we start all over again by resetting the graph area
    //Else we keep drawing by iterating to the next x value
    xLight = 0;
    stroke(0);
    fill(0);
    rect(0, 125, 640, 280);
  }
  else xLight++;
}

//Function used to display x, y, z accelerations and 
//the G-Force as text on the screen
void displayAccXYZ()
{
  //Clearing the rectangle areas where the temperature text values are displayed
  //We fill them with black, give them 'no stroke' and specify their x1, y1, x2, y2
  //coordinates using the processing's rect() function
  fill(0);
  stroke(0);
  rect(150, 0, 100, 25);
  rect(150, 30, 100, 25);
  rect(150, 60, 100, 25);
  rect(150, 90, 100, 25);
  
  //Calculating the G-Force as sqrt(x^2 + y^2 + z^2), where x, y, z are 
  //the values from the accelerometer
  float gForce = sqrt(accelerations[0] * accelerations[0] + accelerations[1] * accelerations[1] + accelerations[2] * accelerations[2]);
  
  //After clearing, we reset the colour to white and then display the
  //x, y, z acceleration values and the G-Force using the text() function
  fill(255);
  text(accelerations[0], 150, 20);
  text(accelerations[1], 150, 50);
  text(accelerations[2], 150, 80);
  text(gForce, 150, 110);
}

//Function used to display the live G-Force in a graph which is updated
//at every iteration of the draw() function
void displayAccGraph()
{
  //Calculating the total G-Force as sqrt(x^2 + y^2 + z^2) and displaying it as graph
  float gForce = sqrt(accelerations[0] * accelerations[0] + accelerations[1] * accelerations[1] + accelerations[2] * accelerations[2]);
  
  //In order to show the data at the proper scale, we multiply our result by 100
  //Reversing the Y axis is necessary since y = 0 is in the upper side of the screen
  yAcc = 360 - gForce * 100;
  
  //If y value is lower than 150, we set it to 150 so that it won't interfere
  //with the text displayed above the graph
  if(yAcc < 150)
    yAcc = 150;
  
  //Setting the purple colour in RGB (128, 0, 128) and drawing a G-Force line for the graph 
  stroke(128, 0, 128);
  line(xAcc, 360, xAcc, yAcc);
  
  if(xAcc == 640)
  {
    //If we reach the end of the screen (x = 640), we start all over again by resetting the graph area
    //Else we keep drawing by iterating to the next x value
    xAcc = 0;
    stroke(0);
    fill(0);
    rect(0, 145, 640, 280);
  }
  else xAcc++;
}

//Function used to display the direction in which the Engduino is tilt at a certain moment
//based on the accelerometer values
void displayArrows()
{
  //Clearing the arrows(triangles) showing the direction by setting their colour to white and 'no stroke'
  //We use the triangle() function to specify the coordinates of the triangle's points
  stroke(0); 
  fill(255);
  triangle(520, 30, 540, 10, 560, 30);
  triangle(520, 70, 500, 50, 520, 30);
  triangle(560, 30, 580, 50, 560, 70);
  triangle(560, 70, 540, 90, 520, 70);
  
  float x = accelerations[0];
  float y = accelerations[1];
  
  //The if statements decide which arrow to light(colour in purple) to show the titlting direction
  if(abs(x) > step)
  {
    if(x < 0)
    {
      //When we have a negative x value with its module greater than 0.2, we light the down arrow
      stroke(0); 
      fill(128, 0, 128);
      triangle(560, 70, 540, 90, 520, 70);
    }
    else
    {
      //When we have a negative x value with its module greater than 0.2, we light the up arrow
      stroke(0); 
      fill(128, 0, 128);
      triangle(520, 30, 540, 10, 560, 30);
    }
    
  }
  
  if(abs(y) > step)
  {
    if(y < 0)
     {
       //When we have a negative y value with its module greater than 0.2, we light the left arrow
       stroke(0); 
       fill(128, 0, 128);
       triangle(520, 70, 500, 50, 520, 30);
     }
     else
     {
       //When we have a negative y value with its module greater than 0.2, we light the right arrow
       stroke(0); 
       fill(128, 0, 128);
       triangle(560, 30, 580, 50, 560, 70);
     }
  }
}

//Function used to display x, y, z magnetic field's components and 
//the magnitude as text on the screen
void displayMagnetXYZ()
{
  //Clearing the rectangle areas where the temperature text values are displayed
  //We fill them with black, give them 'no stroke' and specify their x1, y1, x2, y2
  //coordinates using the processing's rect() function
  fill(0);
  stroke(0);
  rect(170, 0, 150, 25);
  rect(170, 30, 150, 25);
  rect(170, 60, 150, 25);
  rect(170, 90, 150, 25);
  
  //Calculating the magnitude as sqrt(x^2 + y^2 + z^2), where x, y, z are 
  //the values from the magnetometer
  float magnitude = sqrt(magnetometer[0] * magnetometer[0] + magnetometer[1] * magnetometer[1] + magnetometer[2] * magnetometer[2]);
  
  //After clearing, we reset the colour to white and then display the
  //x, y, z magnetometer values and the magnitude using the text() function
  fill(255);
  text(magnetometer[0], 170, 20);
  text(magnetometer[1], 170, 50);
  text(magnetometer[2], 170, 80);
  text(magnitude, 170, 110);
}

//Function used to display the live magnitude in a graph which is updated
//at every iteration of the draw() function
void displayMagnetGraph()
{
  //Calculating the magnitude as sqrt(x^2 + y^2 + z^2) and displaying it in a graph
  float magnitude = sqrt(magnetometer[0] * magnetometer[0] + magnetometer[1] * magnetometer[1] + magnetometer[2] * magnetometer[2]);
  
  //Since the magnitude values are usually between 3000 and 4500, we consider 3000 as a starting
  //point by substracting it. Divind by 10 give the proper scale for better display
  //Reversing the Y axis since 0 is in the upper side of the screen and taking the maximum number
  yMagnet = 360 - (magnitude-3000) /10;
  
  //If y value is lower than 150, we set it to 150 so that it won't interfere
  //with the text displayed above the graph
  if(yMagnet < 150)
    yMagnet = 150;
  
  //Setting the blue colour in RGB (0, 0, 255) and drawing a magnitude line for the graph 
  stroke(0, 0, 255);
  line(xMagnet, 360, xMagnet, yMagnet);
  
  if(xMagnet == 640)
  {
    //If we reach the end of the screen (x = 640), we start all over again by resetting the graph area
    //Else we keep drawing by iterating to the next x value
    xMagnet = 0;
    stroke(0);
    fill(0);
    rect(0, 145, 640, 280);
  }
  else xMagnet++;
}

//Function used to display the direction in which the geographic North is, based on the magnetic X axis
void displayNorth()
{
  //Clearing the rectangle showing the North detection by setting their colour to white and 'no stroke'
  //We use the rect() function to specify the coordinates of the triangle's points
  stroke(0); 
  fill(255);
  rect(520, 30, 40, 40);
  
  float x = magnetometer[0];
  
  //We use a maximum absolute value( maxX ) for the X axis after the calibration
  //Therefore, when x is within a range of 50 from maxX, the North is found 
  if(abs(x) > maxX - 50)
  {
    //Colouring the rectangle in the blue colour
    fill(0, 0, 255);
    rect(520, 30, 40, 40);
  }
  
  //If we found a bigger maximum value, we update it
  maxX = max(maxX, abs(x));
  
  println(x);
  
}

//The draw function is specific and is repeated over and over until the end of the program
//We will use this repetition to read data over and over from the port in order to display it
void draw()
{
  //If we found a port, we verify if we have any incoming data available
  //Else we print an error message
  if(myPort != null)
  {
    if(myPort.available() > 0)
    {
      //If we receive data, we determine which application to run and we read and store 
      //in global variables and structures all the other data received
      //which is necessary for displaying data
      int appID  = read();
    
      //Do the right displaying depending on the application which is active at that moment
      //The switch, based on the returned appID, executes the corresponding code needed
      //for the type of data input
      switch(appID)
      {
        //Temperature app is identified for id 0, so we display what we need on the screen
        //through 2 functions which we call
        case 0:
          displayTemperature();            //Display temperature as simple text value
          displayTemperatureGraph();       //Display the light level in a real-time graph
          break;
        
        //Light sensor app is identified for id 1, so we display what we need on the screen
        //through 2 functions which we call
        case 1:
          displayLight();                  //Display light level as simple text value
          displayLightGraph();             //Display the light level in a real-time graph
          break;
        
        //Accelerometer app is identified for id 2, so we display what we need on the screen
        //through 3 functions which we call
        case 2:
          displayAccXYZ();                //Display accelerometer data as simple text values
          displayAccGraph();              //Display G-Force value in a real-time graph
          displayArrows();                //Show the tilting direction of the Engduino in real time
          break;
        
        //Accelerometer app is identified for id 3, so we display what we need on the screen
        //through 3 functions which we call
        case 3:
          displayMagnetXYZ();             //Display magnetometer data as simple text values
          displayMagnetGraph();           //Display magnitude value in a real-time graph
          displayNorth();                 //Show if Engduino is pointed to the geographic North Pole
          break;
        
        //In other cases, we just skip the values as they have no meaning for the program
      }
    }
  }
  else println("No port found. Please, turn on your Engduino and restart the Processing App");
  //If there is no port available, print an error message until the restart of the program!
    
  //Including a delay of 200 ms for the changes to be visible on the screen and 
  //for Processing to have time to read the input of data 
  delay(200);
  
}