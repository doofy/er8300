$fn = 40;

camera_bb_width = 105;
camera_bb_depth = 60;
camera_bb_height = 64;

rpi_bb_width = 90;
rpi_bb_depth = 58;
rpi_bb_height = 20;

poe_bb_width = 75;
poe_bb_depth = 45;
poe_bb_height = 21;

camera_body_width = 105; //TODO incorrect
camera_body_depth = 52;
camera_body_height = 64;

camera_inset = 10;

camera_lens_width = 105; //TODO incorrect
camera_lens_depth = 60;
camera_lens_height = 60;

wall_thickness = 3;

baseplate_width = 160;
baseplate_depth = 100;
baseplate_height = wall_thickness;

clip_height = 20;
clip_spacing = 0.5;

sideclip_depth = clip_height;
sideclip_height = 10;

topclip_width = baseplate_width;
topclip_depth = baseplate_depth + 2 * sideclip_depth + 2 * wall_thickness;
topclip_height = 30;

module mountinghole() {
  mountinghole_d = 2.2;
  mountinghole_head_d = 3.8;
  mountinghole_head_height = 1.2;
  cylinder(d1 = mountinghole_head_d, d2 = mountinghole_d, h = mountinghole_head_height);
  translate([0, 0, mountinghole_head_height]) cylinder(d = mountinghole_d, h = 10);
}

module baseplate() {
  width = baseplate_width;
  depth = baseplate_depth;
  height = baseplate_height;
  translate([0, - depth / 2, 0]) cube([width, depth, height]);
}

module sideclip() {
  width = baseplate_width;
  height = sideclip_height;
  depth = sideclip_depth;
  translate([0, - baseplate_depth / 2 - depth, 0]) {
    cube([baseplate_width, depth, wall_thickness]);
    cube([baseplate_width, wall_thickness, height]);
  }
}

module mountingclip() {
  width = baseplate_width;
  depth = wall_thickness;
  height = 2 * wall_thickness;
  translate([0, camera_bb_depth / 2 + clip_spacing, wall_thickness]) cube([width, depth, height]);
  translate([0, camera_bb_depth / 2 + 2*clip_spacing + 2*wall_thickness, wall_thickness]) cube([width, depth, height]);
  translate([0, -camera_bb_depth / 2 - clip_spacing - wall_thickness, wall_thickness]) cube([width, depth, height]);
  translate([0, -camera_bb_depth / 2 - 2*clip_spacing - 3*wall_thickness, wall_thickness]) cube([width, depth, height]);
}

module topmountingclip() {
  width = baseplate_width;
  depth = 2 * wall_thickness;
  height = wall_thickness;
  dfromplate = 5;
  translate([0, camera_bb_height / 2 + clip_spacing, -wall_thickness - dfromplate]) cube([width, depth, height]);
  translate([0, camera_bb_height / 2 + clip_spacing, -3*wall_thickness - dfromplate]) cube([width, depth, height]);
  translate([0, camera_bb_height / 2 + 2*wall_thickness, -3*wall_thickness - dfromplate]) cube([width, height, depth + dfromplate + wall_thickness]);

  translate([0, -camera_bb_height / 2 - depth, -wall_thickness - dfromplate]) cube([width, depth, height]);
  translate([0, -camera_bb_height / 2 - depth, -3*wall_thickness - dfromplate]) cube([width, depth, height]);
  translate([0, -camera_bb_height / 2 - 3*wall_thickness, -3*wall_thickness - dfromplate]) cube([width, height, depth + dfromplate + wall_thickness]);
}

module sideclip_inside() {
  translate([0, 2 * wall_thickness + clip_spacing, wall_thickness + clip_spacing]) cube([baseplate_width, wall_thickness, sideclip_height]);
  translate([0, wall_thickness, sideclip_height + clip_spacing]) cube([baseplate_width, 2 * wall_thickness + clip_spacing, wall_thickness]);
  translate([0, 2 * wall_thickness + clip_spacing, camera_body_height + wall_thickness - sideclip_height - clip_spacing]) cube([baseplate_width, wall_thickness, sideclip_height]);
  translate([0, wall_thickness, camera_body_height + wall_thickness - sideclip_height - clip_spacing]) cube([baseplate_width, 2 * wall_thickness + clip_spacing, wall_thickness]);
}

module topplate() {
  module mountingholes_top() {
    x1 = 43.5;
    x2 = x1 + 20 + 28;
    ydistance = 20;
    y1 = ydistance / 2;
    y2 = - ydistance / 2;

    translate([camera_inset, 0, 0]) {
      translate([x1, y1, 0]) mountinghole();
      translate([x1, y2, 0]) mountinghole();
      translate([x2, y1, 0]) mountinghole();
      translate([x2, y2, 0]) mountinghole();
    }
  }
  module cableholes() {
    width = 20;
    depth = 20;
    height = 20;
    translate([baseplate_width - width - width / 2, baseplate_depth / 2 - depth / 2 + 2, -10]) cube([width, depth, height]);
    translate([width / 2, baseplate_depth / 2 - depth / 2 + 2, -10]) cube([width, depth, height]);
    translate([baseplate_width - width - width / 2, -baseplate_depth / 2 - depth / 2 - 2, -10]) cube([width, depth, height]);
    translate([width / 2, -baseplate_depth / 2 - depth / 2 - 2, -10]) cube([width, depth, height]);
  }
  difference() {
    union() {
      baseplate();
      sideclip();
      mirror([0, 1, 0]) sideclip();
      mountingclip();
    }
    mountingholes_top();
    cableholes();
  }
}

module bottomplate() {
  module mountingholes_bottom() {
    x1 = 53.5;
    x2 = x1 + 33;
    ydistance = 27;
    y1 = ydistance / 2;
    y2 = - ydistance / 2;

    translate([camera_inset, 0, 0]) {
      translate([x1, y1, 0]) mountinghole();
      translate([x1, y2, 0]) mountinghole();
      translate([x2, y1, 0]) mountinghole();
      translate([x2, y2, 0]) mountinghole();
    }
  }
  module tripod_hole() {
    x = 72.5;
    y = 0;
    d = 6;
    translate([camera_inset, 0, 0])
      translate([x, y, -5]) cylinder(d = d, h = 10);
  }
  difference() {
    union() {
      baseplate();
      sideclip();
      mirror([0, 1, 0]) sideclip();
      mountingclip();
    }
    mountingholes_bottom();
    tripod_hole();
  }
}

module case_wall() {
  width = baseplate_width;
  depth = baseplate_depth;
  height = camera_body_height + 2 * wall_thickness + topclip_height;

  translate([0, -sideclip_depth - baseplate_depth / 2 - wall_thickness, 0]) {
    cube([width, wall_thickness, height]);
    sideclip_inside();
  }
}

module outter_case() {
  case_wall();
  mirror([0, 1, 0]) case_wall();
  translate([0, - topclip_depth / 2, camera_body_height + 2 * wall_thickness + topclip_height])
    cube([topclip_width, topclip_depth, wall_thickness]);
}

/*translate([0, 0, 2 * wall_thickness + camera_body_height]) rotate([180, 0, 0]) topplate();*/
bottomplate();
/*
color("green") outter_case();

//camera bb
color("blue") translate([camera_inset, - camera_bb_depth / 2, wall_thickness]) cube([camera_bb_width, camera_bb_depth, camera_bb_height]);

//rpi bb
  translate([60,-40, wall_thickness + 3])
rotate([90, 0, 0])
  color("red") {
    cube([rpi_bb_width, rpi_bb_depth, rpi_bb_height]);
    translate([rpi_bb_width - 15, rpi_bb_depth, 1]) cube([10, 40, 10]);
    translate([-52, 5, 1]) cube([52, 52, 18]);
  }

//poe bb
  translate([0,0,-50])
  translate([45,39, 2*poe_bb_depth + 17])
rotate([-90, 0, 0])
  color("red") {
    cube([poe_bb_width, poe_bb_depth, poe_bb_height]);
    translate([poe_bb_width, poe_bb_depth - 10 - 5, 2]) cube([36, 10, 10]);
    translate([-40, 3, 3]) cube([40, 40, 16]);
  }
*/
