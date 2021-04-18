inch = 25.4;
clearance = 0.5;

big_flats = (1+7/16) * inch + clearance;
big_points = big_flats * 2/sqrt(3);
big_h = 1/2 * inch;

small_flats = 1 * inch + clearance;
small_points = small_flats * 2/sqrt(3);
small_h = 3/8 * inch;

axle_d = 1/2 * inch + clearance;

body_h = 4 * inch;
body_d = 2 * inch;

endmill_d = 1/8 * inch;
vmill_d = 1/16 * inch;

$fn=100;

module bolt_circle(d, h, n) {
    for(i=[0:n-1])
        rotate(60*i)
        translate([d/sqrt(3) - endmill_d/2,0,0])
        cylinder(d=endmill_d, h=h);
}

module hex_pocket(d, h) {
    cylinder(d=d*2/sqrt(3), h=h, $fn=6);
    bolt_circle(d, h, 6);
}

//module sine_wave(x, z, n, r) {
//    step = 1;
//    for(i=[0:step:360*n]) {
//        rotate([0,0,-i/x])
//        translate([0, r-vmill_d, z/2*sin(i)])
//        rotate([-90,0,0])
//        cylinder(d1=0, d2=vmill_d, h=vmill_d, $fn=1);
//    }
//}

difference() {
    cylinder(d=body_d, h=body_h);
    
    // Grip & Decoration
//    translate([0,0,7/8*inch])
//    sine_wave(3.6, inch, 18, body_d/2);
//    
//    translate([0,0,body_h-7/8*inch])
//    sine_wave(3.6, inch, 18, body_d/2);
    
    // Big die pocket
    translate([0,0,body_h - big_h])
    hex_pocket(d=big_flats, h=big_h);
    
    // Small die pocket
    hex_pocket(d=small_flats, h=small_h);
    translate([0,0,small_h])
    cylinder(d1=small_points, d2=axle_d, h=(small_points-axle_d)/2);
    
    // Center axle
    cylinder(d=axle_d, h=body_h+1);
    
    // Bottom chamfer
    difference() {
        cylinder(d=body_d+1, h=1/4*inch);
        cylinder(d1=body_d-1/4*inch, d2=body_d, h=1/4*inch);
    }
    
    // Top chamfer
    translate([0,0,body_h - 1/4*inch])
    difference() {
        cylinder(d=body_d+1, h=1/4*inch);
        cylinder(d2=body_d-1/4*inch, d1=body_d, h=1/4*inch);
    }
    
    // Center chamfers
    translate([0,0,1.5*inch])
    difference() {
        cylinder(d=body_d+1, h=inch);
        cylinder(d=body_d-1/4*inch, h=inch);
        cylinder(d1=body_d, d2=0, h=inch);
        cylinder(d2=body_d, d1=0, h=inch);
    }
}