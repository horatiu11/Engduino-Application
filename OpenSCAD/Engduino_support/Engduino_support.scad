//This OpenSCAD code creates a support shape for an Engduino stand that looks like a StarWars spaceship

//Spiff.scad document is used in order to display text properly
use <Spiff.scad>;

//TEXT HEIGHT VALUE
TEXT_HEIGHT = 5;

//DIMENSIONS OF THE SUPPORT SHAPES
SUPPORT_CYLINDER_H = 24;
SUPPORT_CYLINDER_R = 2.3;
SUPPORT_CUBE_X = 135;
SUPPORT_CUBE_Y = 90;
SUPPORT_CUBE_Z = 4;

//Adding text on the support material
module addText(){
    
    //Writing text, giving it the desired height using linear_extrusion and placing it in the correct angle and position using rotate() and translate() functions
    
    translate([140, 21, 2])
        rotate([10, 0, 90])
            linear_extrude(height = TEXT_HEIGHT)
                write("UCL");
    
    translate([140, -40, 2])
        rotate([10, 0, 90])
            linear_extrude(height = TEXT_HEIGHT)
                write("UCL");
}

//Creating the support shape at a specific location
module support(){
    //Creating the base shape
    translate([10, -45, 0])
        cube([SUPPORT_CUBE_X, SUPPORT_CUBE_Y, SUPPORT_CUBE_Z]);
    
    //Creating front support cylinder
    translate([120, 0, 2])
        cylinder(SUPPORT_CYLINDER_H, SUPPORT_CYLINDER_R, SUPPORT_CYLINDER_R);
    
    //Creating one of the back support cylinders and reflecting it
    translate([40, 30, 2])
        cylinder(SUPPORT_CYLINDER_H, SUPPORT_CYLINDER_R, SUPPORT_CYLINDER_R);
    
    mirror([0, 1, 0])
        translate([40, 30, 2])
            cylinder(SUPPORT_CYLINDER_H, SUPPORT_CYLINDER_R, SUPPORT_CYLINDER_R); 
    
}

//Creating the support material for the stand in Black
color("Black"){
    
    support();

}

//Adding the text in Cyan colour
color("Cyan"){
    addText();
}