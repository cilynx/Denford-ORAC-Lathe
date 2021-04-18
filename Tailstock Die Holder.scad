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
body_c = 1 * inch;

endmill_d = 1/8 * inch;
vmill_d = 1/16 * inch;
chamfer = 1/8 * inch;
chamfer_d = body_d-2*chamfer;

grip_h = (body_h-4*chamfer-body_c)/2;

$fn=360;

$vpt = [-40,40,0];
$vpr = [45,0,45];
$vpd = 400;

module bolt_circle(d, h, n) {
  $fn=100;
  for(i=[0:n-1])
    rotate(360/n*i)
    translate([d/sqrt(3) - endmill_d/2,0,0])
    cylinder(d=endmill_d, h=h);
}

module hex_pocket(d, h) {
  cylinder(d=d*2/sqrt(3), h=h, $fn=6);
  bolt_circle(d, h, 6);
}

module body() {
  // Bottom chamfer
  cylinder(h=chamfer, d2=body_d, d1=chamfer_d);

  // Bottom body
  translate([0,0,chamfer])
  cylinder(h=grip_h, d=body_d);

  // Bottom body chamfer
  translate([0,0,grip_h+chamfer])
  cylinder(h=chamfer, d1=body_d, d2=chamfer_d);

  // Center section
  translate([0,0,2*chamfer+grip_h])
  cylinder(h=body_c, d=chamfer_d);

  // Body top chamfer
  translate([0,0,2*chamfer+grip_h+body_c])
  cylinder(h=chamfer, d2=body_d, d1=chamfer_d);

  // Top body
  translate([0,0,3*chamfer+grip_h+body_c])
  cylinder(h=grip_h, d=body_d);

  // Top chamfer
  translate([0,0,3*chamfer+grip_h+body_c+grip_h])
  cylinder(h=chamfer, d1=body_d, d2=chamfer_d);
}

difference() {
  body();
  
  // Axle
  cylinder(h=body_h, d=axle_d);
  
  // Big die pocket
  translate([0,0,body_h-big_h])
  hex_pocket(h=big_h, d=big_flats);
  
  // Small die pocket
  translate([0,0,small_h]) 
    cylinder(h=(small_points-axle_d)/2, d1=small_points, d2=axle_d);
  hex_pocket(h=small_h, d=small_flats);
  
}