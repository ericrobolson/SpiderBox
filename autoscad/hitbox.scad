$fn = 64; // Set the arc

small_btn_diameter = 25; // mm
large_btn_diameter = 31 ; // mm

btn_height = 32; // mm

module btn(x,y,z, dia, color = [1,0,0]) {
    translate([x,y,z])
    color(color)
    cylinder(h = btn_height, d = dia);
}

module hitbox_buttons() {
        
    vertical_spacing = 30; // vertical spacing between small buttons
    horz_spacing = 2;
    row1_spacing = 14;

    //
    // Buttons for hand
    //


    // row 1
    row1_horz = row1_spacing + horz_spacing;
    row1_vert = 25;
    btn(row1_horz, row1_vert, 0, small_btn_diameter);
    btn(row1_horz, row1_vert -vertical_spacing, 0, small_btn_diameter);

    // row 2
    row2_horz_offset = 25 + horz_spacing;
    row2_vert_offset = 14;

    row2_horz = row1_horz + row2_horz_offset;
    row2_vert = row1_vert + row2_vert_offset;

    btn(row2_horz, row2_vert, 0, small_btn_diameter);
    btn(row2_horz, row2_vert -vertical_spacing, 0, small_btn_diameter);


    // row 3
    row3_horz_offset = 29 + horz_spacing;
    row3_vert_offset = row2_vert_offset;

    row3_horz = row2_horz + row3_horz_offset;
    row3_vert = row1_vert + row3_vert_offset;

    btn(row3_horz, row3_vert, 0, small_btn_diameter);
    btn(row3_horz, row3_vert -vertical_spacing, 0, small_btn_diameter);


    // row 4
    row4_horz_offset = 28 + horz_spacing;
    row4_vert_offset = 7;

    row4_horz = row3_horz + row4_horz_offset;
    row4_vert = row1_vert + row4_vert_offset;

    btn(row4_horz, row4_vert, 0, small_btn_diameter);
    btn(row4_horz, row4_vert -vertical_spacing, 0, small_btn_diameter);


    //
    // Movement buttons
    //
    
    module move_buttons() {
        move1_horz = -row1_spacing;
        move1_vert = 10;
        btn(move1_horz, move1_vert, 0, small_btn_diameter);

        // move 2
        move2_horz_offset = -row2_horz_offset;
        move2_vert_offset = row2_vert_offset;

        move2_horz = move1_horz + move2_horz_offset;
        move2_vert = move1_vert + move2_vert_offset;

        btn(move2_horz, move2_vert, 0, small_btn_diameter);


        // move 3
        move3_horz_offset = -row3_horz_offset;
        move3_vert_offset = move2_vert_offset;

        move3_horz = move2_horz + move3_horz_offset;
        move3_vert = move1_vert + move3_vert_offset;

        btn(move3_horz, move3_vert, 0, small_btn_diameter);
    }
    
    move_buttons();
    
    // Start, select, home
    translate([0,row1_vert +5,0]){
        move_buttons();
    }

    

    // Large btn

    move0_horz = 0;
    move0_vert = -38;
    btn(move0_horz, move0_vert, 0, large_btn_diameter);
};



screw_diameter = 5;
screw_len = 500;

module screw(trans, rot, length = screw_len, color = [1,1,0]) {
    translate(trans)
    rotate(rot)
    color(color)
    cylinder(h = length, d = screw_diameter, center = true);
}



fp_inner_width = 240;
fp_inner_height = 165;
fp_inner_depth = 6;

fp_wall_thickness = 7;
fp_width = fp_inner_width + fp_wall_thickness;
fp_height = fp_inner_height + fp_wall_thickness;
fp_depth = 16;
fp_thickness = 6;

 module plate_screws(){
         // Screw definitions
        screw_height_offset = 0 + fp_depth / 2 + screw_diameter /2;
        horz_screw_rot = [0,0,0];
        vert_screw_rot = [0,0,0];
        
        // Horz screws
        offset = 10;
        
        module screw_row() {
            screw([fp_inner_width / 2 - offset,fp_inner_height / 2 - offset,0] , [0,0,0]);
            screw([0 / 2,fp_inner_height / 2 - offset,0] , [0,0,0]);
            screw([-fp_inner_width / 2 + offset,fp_inner_height / 2 - offset,0] , [0,0,0]);
        }
        
        
        screw_row();
        mirror([0,-1,0]) {
            screw_row();
        }


        
    };

module plate() { 
    // Final shape
    difference(){
        // this is the diff cube
        translate([0,0, fp_inner_depth / 2 + fp_thickness]) 
        cube([fp_inner_width,fp_inner_height,fp_inner_depth],center = true);
       
       // Screws
       plate_screws(); 
    }
    

};


////////////////////////////////////////////////
// RENDER
////////////////////////////////////////////////

// Button faceplate
difference() {
    translate([0,10,0])
    color([0,1,0])
    plate();

    btn_vert_offset = 10;

    mirror([1,0,0])
    translate([15,btn_vert_offset,-5])
    mirror([1,0,0])
    hitbox_buttons();
}
