$fn = 64; // Set the arc

cube_w = 40;
cube_h = 4;

small_btn_diameter = 25; // mm
large_btn_diameter = 32; // mm

small_btn_radius = sqrt(small_btn_diameter);
large_btn_radius = sqrt(large_btn_diameter);


module btn(x,y,z, dia) {
    translate([x,y,z])
    cylinder(h = 16, d = dia);
}

translate([-cube_w, 0, 0]){
difference() {
cube(size = [cube_w, cube_w, cube_h], center = true);
cylinder(h = 16, d = large_btn_diameter, center = true);
}
}

difference() {
cube(size = [cube_w, cube_w, cube_h], center = true);
    
cylinder(h = 16, d = small_btn_diameter, center = true);
}



btn(1,2,30, 30);