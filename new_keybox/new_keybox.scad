// 1 unit = 1mm

// -*- mode: c -*-
/* All distances are in mm. */

$fn=2000;

module screw(trans, rot, length = screw_len, color = [1,1,0]) {        
    screw_diameter = 6;
    screw_len = 500;
    
    translate(trans)
    rotate(rot)
    color(color)
    cylinder(h = length, d = screw_diameter, center = true);
}


module switch_hole(position, height=20) {
  // https://github.com/technomancy/atreus/blob/master/case/openscad/atreus_case.scad
  /* Cherry MX switch hole with the center at `position`. Sizes come
      from the ErgoDox design. */
  hole_size    = 13.97;
  notch_width  = 3.5001;
  notch_offset = 4.2545;
  notch_depth  = 0.8128;

  // Convert from 2d to 3d
  linear_extrude(height=height, center=true) {
    square([hole_size, hole_size], center=true);

    translate([0, notch_offset]) {
      square([hole_size+2*notch_depth, notch_width], center=true);
    }
    translate([0, -notch_offset]) {
      square([hole_size+2*notch_depth, notch_width], center=true);
    }  
  }   
};

switch_cutout_width = 20;
switch_cutout_height = 5;
module switch_cutout(position) {
    w = switch_cutout_width;
    h = switch_cutout_height;
  translate(position) {
    difference() {
      cube([w, w, h], true);
      switch_hole([0], height = 200);
    }
  }
}

module switch_with_border(invert = false){
  module normal_switch() {
      switch_cutout([0,0,2.5]);
      difference() {
        translate([0,0,5]) {
          cube([30,30,10], true);
        }
        translate([0,0,5]){
          cube([20, 20, 10], true);
        }
      }  
  }
  
  if (!invert) {
    normal_switch();
  } else {
    
    normal_switch();
  }
  
}

offset = 0.5 * switch_cutout_width;
MAX_X = 2;
MAX_Y = 1;

// A blank side
module blank_plate(height_scalar=1){
  // NOTE: for screws, make them offset on each side.
  // E.g.:
  // Top side:    x0xxxx0x
  // Right side:  xx0xx0xx

  translate([-offset, -offset,0]){
    cube_w = (MAX_X + 2) * switch_cutout_width;
    cube([cube_w,cube_w, switch_cutout_height * height_scalar]);
  }
}

module key_layout() {

  // Flip it to make it easier to deal with
  {
    // Generate the keyslots
    for (x = [0:MAX_X]) {
        for (y = [0:MAX_Y]){
            // Draw the cutout
            new_x = x * switch_cutout_width + offset;
            new_y = y * switch_cutout_width + offset;
            switch_cutout([new_x,new_y,switch_cutout_height / 2]);
        }
    }

    // Create the border
    difference() {
      // This represents the border volume
      { 
        blank_plate(height_scalar=2);
      }

      // This represents the switches volume
      {
        cube_w = (MAX_X + 1) * switch_cutout_width;
        cube_d = 100;
        cube_h = (MAX_Y + 1) * switch_cutout_width;
        translate([0,0,-cube_d / 2]){
          cube([cube_w, cube_h, cube_d]);
        }
      }
    }  
  }
}

//key_layout();



module key() {
   // switch_cutout([new_x,new_y,switch_cutout_height / 2]);
    switch_with_border(true);
}

key();