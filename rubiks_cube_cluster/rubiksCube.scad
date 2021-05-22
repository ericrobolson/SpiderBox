// This is an experiment in crazy.;
// Basically a hitbox, in the form factor of a rubiks cube.
// 1 unit = 1mm

// -*- mode: c -*-
/* All distances are in mm. */

$fn=2000;

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

module switch_with_border(){
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

offset = 0.5 * switch_cutout_width;
MAX_X = 3;
MAX_Y = 3;

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
        cube_h = 100;
        translate([0,0,-cube_h / 2]){
          cube([cube_w, cube_w, cube_h]);
        }
      }
    }  
  }
}

key_layout();
