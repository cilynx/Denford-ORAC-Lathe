inch = 25.4;

big_flats = (1+7/16) * inch;
big_points = big_flats * 2/sqrt(3);
big_h = 1/2 * inch;

small_flats = 1 * inch;
small_points = small_flats * 2/sqrt(3);
small_h = 3/8 * inch;

axle_d = 3/4 * inch;

body_h = 4 * inch;
body_d = 2 * inch;

endmill_d = 1/8 * inch;
vmill_d = 1/16 * inch;

module hex_pocket(d, h) {
//    minkowski() {
//        cylinder(d=(d-endmill_d)*2/sqrt(3), h=h, $fn=6);
//        cylinder(d=endmill_d, h=0.001, $fn=100);
//    }
    cylinder(d = d*2/sqrt(3), h=h, $fn=6);
    bolt_circle(d, h, 6);
}

module bolt_circle(d, h, n) {
    for(i=[0:n-1])
        rotate(60*i)
        translate([d/sqrt(3) - endmill_d/2,0,0])
        cylinder(d=endmill_d, h=h, $fn=100);
}

module sine_wave(x, z, n, r) {
    step = 1;
    for(i=[0:step:360*n]) {
        rotate([0,0,-i/x])
        translate([0, r-vmill_d, z/2*sin(i)])
        rotate([-90,0,0])
        cylinder(d1=0, d2=vmill_d, h=vmill_d, $fn=1);
    }
} 

difference() {
    cylinder(d=body_d, h=body_h, $fn=100);
    
    translate([0,0,-0.1])
    hex_pocket(d=small_flats, h=small_h);
    
    translate([0,0,body_h - big_h])
    hex_pocket(d=big_flats, h=big_h);
    
    cylinder(d=axle_d, h=body_h+1);
    
    translate([0,0,7/8 * inch])
    sine_wave(3.6, inch, 18, body_d/2);

    translate([0,0, body_h-7/8*inch])
    sine_wave(3.6, inch, 20, body_d/2);
    
    translate([0,0,-0.001])
    difference() {
        cylinder(d=body_d+1, h=1/4*inch);
        cylinder(d1=body_d-1/4*inch, d2=body_d, h=1/4*inch, $fn=100);
    }
    
    translate([0,0,body_h - 1/4*inch + 0.001])
    difference() {
        cylinder(d=body_d+1, h=1/4*inch);
        cylinder(d2=body_d-1/4*inch, d1=body_d, h=1/4*inch, $fn=100);
    }

    translate([0,0,1.5*inch])
    difference() {
        translate([0,0,0.001])
        cylinder(d=body_d+1, h=inch-0.002, $fn=100);
    
        cylinder(d=body_d-1/4*inch, h=inch, $fn=100);
        cylinder(d1=body_d, d2=0, h=inch, $fn=100);
        cylinder(d2=body_d, d1=0, h=inch, $fn=100);
    }

}