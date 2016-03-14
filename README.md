# Engduino-Application

This is an application that uses Engduino's sensors and Processing IDE to display sensor data in real-time and to plot graphs.

My Engduino application for the C coursework consists of two programs: one written in Arduino-Engduino IDE and one written in Processing IDE. 
It takes sensor values from Engduino and displays them in several ways, in real-time. 
The application written in Arduino-Engduino uses C/C++ as a programming language and, once uploaded to the Engduino, it takes severaldata from it like temperature, light level, accelerometer data and magnetometer data, using special libraries. 
My program takes only one type of data at one time. 
The code switches between the types of values which are to be displayed by pressing the Engduino button. 
All of these are sent through the serial port in the laptop/PC, being preceded by a code which tells what sensor was used. 
Moreover, there is a light show using the LEDs which moves at the rate at which the values are printed. 
The application in Processing IDE is more complex. 
Firstly, it looks at which port the Engduino is printing the data and then starts to read this data.  
After that, by the preceding code received from Engduino, it knows what sensor was used. 
Moreover, it reads the desired values and displays graphs and values to the screen, corresponding to a certain sensor.

More details in the documentation of the repository.
 
