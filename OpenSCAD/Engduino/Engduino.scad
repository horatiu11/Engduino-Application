//This OpenSCAD code creates an Engduino stand that looks like a Star Wars spaceship and has a support at the bottom

//Spiff.scad document is used in order to display text properly
use <Spiff.scad>;

//USB SOCKET DIMENSIONS
USB_X = 4.6;
USB_Y = 12.1;
USB_Z = 15.5;

//TEXT HEIGHT VALUE
TEXT_HEIGHT = 5;

//DIMENSIONS OF THE GUNS
GUN_SPHERE = 5;
GUN_CYLINDER_H = 10;
GUN_CYLINDER_R = 1.5;

//DIMENSIONS OF THE SUPPORT SHAPES
SUPPORT_CYLINDER_H = 24;
SUPPORT_CYLINDER_R = 2.3;
SUPPORT_CUBE_X = 135;
SUPPORT_CUBE_Y = 90;
SUPPORT_CUBE_Z = 4;

//DIMENSIONS OF THE ANTENNA
ANTENNA_CUBE_X = 8;
ANTENNA_CUBE_Y = 15;
ANTENNA_CUBE_Z = 23;
ANTENNA_SPHERE_R = 8;

//DIMENSIONS OF THE TOP BLOCKS
TOP_CUBE_X = 35;
TOP_CUBE_Y = 34;
TOP_CUBE_Z = 10;

//DIMENSIONS OF THE BOTTOM SPHERE
BOTTOM_R = 11;

//DIMENSIONS OF THE ENGINES
ENGINE_SPHERE_R = 6;
ENGINE_CYLINDER_H = 10; 
ENGINE_CYLINDER_R = 7;

//Creating the body shape
module body(){
    //Using polyhderon to specify points and faces of a complex shape
    //Points order matters when specifying faces and the count starts from 0
    polyhedron( 
        points = [ 
                [10, 0, 15], [30, 60, 2.5], [150, 0, 2],
                [30,-60, 2.5], [15, 0, 0], [30, 60, 0],
                [150, 0, 0], [30, -60, 0]
                 ],
    
        faces = [ 
                [0, 1, 2], [0, 2, 3], [1, 5, 6, 2], 
                [2, 6, 7, 3], [4, 5, 1], [0, 4, 1], 
                [0, 3, 4], [4, 3, 7], [7, 6, 5, 4], 
                ]
    );
        
}

//Creating the engines at the back of the spaceship
module engines(){
    
    //Each instruction takes a given cylinder, rotates it to the horizontal, then it substracts a sphere from it and translates it at the proper position
    
    translate([11, 11, 0]){
        
        difference(){
            
            rotate([0, 90, 0])
                cylinder(ENGINE_CYLINDER_H, ENGINE_CYLINDER_R, ENGINE_CYLINDER_R);
            
            sphere(ENGINE_SPHERE_R);
        }
    
    }
    
    translate([16, 30, 0]){
        
        difference(){
            
            rotate([0, 90, 0])
                cylinder(ENGINE_CYLINDER_H, ENGINE_CYLINDER_R - 2, ENGINE_CYLINDER_R - 2);
            
            sphere(ENGINE_SPHERE_R - 2);
        }
    
    }
    
    translate([20, 45, 0]){
        
        difference(){
            
            rotate([0, 90, 0])
                cylinder(ENGINE_CYLINDER_H, ENGINE_CYLINDER_R - 4, ENGINE_CYLINDER_R - 4);
            
            sphere(ENGINE_SPHERE_R - 4);
        }
    
    }
}

//Creating the bootom sphere and translating at the needed position
module bottom_sphere(){
    
    translate([50, 0, -5])
        sphere(BOTTOM_R);
}

//Making half of the two top blocks of the ship
module top_blocks(){
    
    //Using minkowski() between the cube and a cylinder to round the shape 
    minkowski(){
        translate([27, -5, 12])
            rotate([350, 5, 0])
                cube([TOP_CUBE_X, TOP_CUBE_Y, TOP_CUBE_Z]);
        cylinder(r=2,h=1);
    }
    
    minkowski(){
        translate([28, -5, 20])
            rotate([350, 5, 0])
                cube([TOP_CUBE_X - 7, TOP_CUBE_Y - 7, TOP_CUBE_Z]);
        cylinder(r=2,h=1);
    }
}

//Creating the antenna from a cube and a rounded shape made of 2 spheres
module top_antenna(){
    
    //Make antenna support - round the shape using the minkowski() function between the cube and a cylinder
    color("DarkSlateGray"){
        rotate([0, 2, 0])
            translate([20, -7.5, 10])
                minkowski(){
                    cube([ANTENNA_CUBE_X, ANTENNA_CUBE_Y, ANTENNA_CUBE_Z]);
                    cylinder(r = 2, h = 1);
                }
    }
    
   //Make antenna - unite two Navy spheres using the hull() function
    color("Navy"){
          
        hull(){
            translate([25.5, 25, 38])
                sphere(ANTENNA_SPHERE_R);
            translate([25.5, -25, 38])
                sphere(ANTENNA_SPHERE_R);
        }
    }
}

//Adding some support material for the spaceship at a certain position
module support(){
    //Creating the base shape
    translate([10, -45, -27])
        cube([SUPPORT_CUBE_X, SUPPORT_CUBE_Y, SUPPORT_CUBE_Z]);
    
    //Creating front support cylinder
    translate([120, 0, -25])
        cylinder(SUPPORT_CYLINDER_H, SUPPORT_CYLINDER_R, SUPPORT_CYLINDER_R);
    
    //Creating one of the back support cylinders and reflecting it
    translate([40, 30, -25])
        cylinder(SUPPORT_CYLINDER_H, SUPPORT_CYLINDER_R, SUPPORT_CYLINDER_R);
    
    mirror([0, 1, 0])
        translate([40, 30, -25])
            cylinder(SUPPORT_CYLINDER_H, SUPPORT_CYLINDER_R, SUPPORT_CYLINDER_R); 
}

//Adding guns on a side of the spaceship
module details(){
    //Each gun is made by a sphere and a cylinder of given dimensions which are rotated and translated to a given position
    
    translate([35, 42, 6]){
        color("Red"){
            sphere(GUN_SPHERE);
        }
        color("Black"){
            rotate([0, 45, 0])
                cylinder(GUN_CYLINDER_H, GUN_CYLINDER_R, GUN_CYLINDER_R);
        }
    }
    
    translate([55, 40, 4]){
        color("Red"){
            sphere(GUN_SPHERE);
        }
        color("Black"){
            rotate([0, 45, 0])
                cylinder(GUN_CYLINDER_H, GUN_CYLINDER_R, GUN_CYLINDER_R);
        }
    }
    
}

//Adding text on the spaceship and on the support material
module addText(){
    
    //Writing text, giving it the desired height using linear_extrusion and placing it in the correct angle and position using rotate() and translate() functions
    
    translate([125, 11, 2])
        rotate([10, 0, 153.5])
            linear_extrude(height = TEXT_HEIGHT)
                write("ENGDUINO"); 
    
    translate([77, -34.5, 2])
        rotate([10, 0, 26.5])
            linear_extrude(height = TEXT_HEIGHT)
                write("ENGDUINO");
    
    translate([140, 21, -25])
        rotate([10, 0, 90])
            linear_extrude(height = TEXT_HEIGHT)
                write("UCL");
    
    translate([140, -40, -25])
        rotate([10, 0, 90])
            linear_extrude(height = TEXT_HEIGHT)
                write("UCL");
}

//The stand module containing all the other submodules used to create the shape of the stand
module stand(){
    
    //Using DarkSlateGrey colour for the body
    color("DarkSlateGray"){
        
        //Create half of the body and substract the USB shape
        difference(){
            
            body();
            
            //Translating USB shape at a wanted location [x, y, z]
            translate([80, 0, 1])
                cube([USB_X, USB_Y, USB_Z], true);
        }
        
        //Create a mirrored shape of the body
        mirror([0, 0, 1])
            body();
    }
    
    //Using Red colour for the engines
    color("Red"){
        
        //Create half of the engines and their mirrored shape
        engines();
        mirror([0, 1, 0])
            engines();
    }
    
    //Creating the sphere under the spaceship and the blocks upon the body in Navy colour
    color("Navy"){
        
        bottom_sphere();

        top_blocks();
        
        //Create mirrored shapes of the top blocks 
        mirror([0, 1, 0])
            top_blocks();
    }
    
    //Create the top antenna of the spaceship
    top_antenna();
    
    //Creating the support material for the stand in Black
    color("Black"){
        support();
    }
    
    //Create details (machine guns) and their mirrored shapes
    details();
    mirror([0, 1, 0])
        details();
    
    //Adding the text in Cyan colour
    color("Cyan"){
        addText();
    }
}

//Calling the stand module starts our program and creates the stand
stand();