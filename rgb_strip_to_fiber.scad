led_size = 5;
led_strip_width = 10;
led_strip_thickness = 2;

ferrule_dia = 6;
ferrule_depth = 12;
ferrule_insulation_dia = 10;
ferrule_insulation_height = 10;
ferrule_lip = [0.5, 1]; // ferrule wall thickness is 0.2

registration_block_size = [10, 10, 14];
registration_block_lip = 2;
led_register_lip = 4;
block_to_led = 5;

part_spacing = 0.2;
wall_thickness = 1.5;

m2_hole_size = 2.2;
m2_nut_dia = 4.8;
m2_nut_depth = 1.5;

m3_hole_size = 3.3;


$fa=0.5;
$fs=0.5;

ferrules = [
  [2.5, 8, "1"],
  [3.4, 12, "2-3"],
  [4, 12, "4-5"],
  [4.7, 12, "6-7"]
];


smidge = 0.01;

module mockup(count, leds_per_meter=60, holes="inner", explode=0, half=false, blocks=true) {
  led_stride = 1000/leds_per_meter;

  translate([0, explode * 10, 0])
    strip_base(count, leds_per_meter, holes=holes, blocks=blocks);
  if (!half)
    translate([0, explode * -10, 0])
      mirror([0, 1, 0])
        strip_base(count, leds_per_meter, holes=holes, blocks=blocks);

    translate([0, 0, -block_to_led])
      led_strip(count, leds_per_meter);

  if (blocks) {
        translate([0 * led_stride, 0, 0])
          for (x = [0, half ? 0 : 1])
            rotate([0, 0, 90 + 180 * x])
              translate([0, max(0, explode * 5 - 2.5), 0])
                registration_block_awg_10(registration_block_size);

        translate([1 * led_stride, 0, 0])
          for (x = [0, half ? 0 : 1])
            rotate([0, 0, 90 + 180 * x])
              translate([0, max(0, explode * 5 - 2.5), 0])
                registration_block_awg_12(registration_block_size);

        translate([2 * led_stride, 0, 0])
          for (x = [0, half ? 0 : 1])
            rotate([0, 0, 90 + 180 * x])
              translate([0, max(0, explode * 5 - 2.5), 0])
                registration_block_awg_14(registration_block_size);
  }
}

module strip_base_with_fiber_cutouts(count, leds_per_meter=60, ferrule=0, nut_holes=false) {
  led_stride = 1000/leds_per_meter;

  difference() {
    strip_base(count, leds_per_meter=leds_per_meter, holes="outer", blocks=false, nut_holes=nut_holes);
    for (i = [0 : count - 1])
      translate([i * led_stride, 0, 0])
        ferrule_cutout(20, ferrule[0], ferrule[1]);
  }
}

module strip_base(count, leds_per_meter=60, holes="inner", blocks=true, nut_holes=false) {
  led_stride = 1000/leds_per_meter;
  registration_block_cutout = [registration_block_size.y + part_spacing,
                               registration_block_size.x + part_spacing,
                               registration_block_size.z + part_spacing];
  side_inset = 10;
  led_strip_cutout = led_strip_width + 1;

  housing_size = [(count -1) * led_stride + registration_block_cutout.x + wall_thickness * 2,
                  registration_block_cutout.y/2 + wall_thickness,
                  registration_block_cutout.z + wall_thickness * 2 + block_to_led];

  led_cutout = 5.5;
  fiber_cutout = registration_block_size.x - registration_block_lip;

  difference() {
    translate([-registration_block_cutout.x/2 - wall_thickness,
               0,
               -wall_thickness - block_to_led])
      cube(housing_size);

    for (i = [0 : count - 1])
      translate([i * led_stride, 0, 0]) {
        if (blocks) {
          registration_block_base(registration_block_cutout);
          translate([-fiber_cutout/2,
                     -fiber_cutout/2,
                     registration_block_cutout.z - smidge])
            cube([fiber_cutout, fiber_cutout, wall_thickness + smidge * 2]);
        }
        translate([-led_cutout/2,-led_cutout/2, -block_to_led + smidge])
          cube([led_cutout, led_cutout, block_to_led]);
      }

    translate([-registration_block_cutout.x/2 - wall_thickness - smidge,
               -led_strip_cutout/2,
               -block_to_led -0])
      cube([housing_size.x + smidge * 2, led_strip_cutout, led_strip_thickness]);

    if (holes == "inner")
      for (i = [0 : count - 2])
        translate([i * led_stride + led_stride/2,
                   -smidge,
                   registration_block_cutout.z/2]) {
          rotate([-90, 0, 0])
            cylinder(d=m3_hole_size, h=housing_size.y + smidge * 2);
        }
    if (holes == "outer") {
      translate([-registration_block_cutout.x/2 - wall_thickness,
                 0,
                 -wall_thickness - block_to_led + housing_size.z/2])
        for (x = [2, housing_size.x - 2])
          translate([x, -smidge, 0]) {
            rotate([-90, 0, 0])
              cylinder(d=m2_hole_size, h=housing_size.y + smidge * 2);
            if (nut_holes)
              translate([0, housing_size.y - m2_nut_depth, 0])
              rotate([-90, 30, 0])
                cylinder(d=m2_nut_dia, $fn=6, h=m2_nut_depth + smidge * 2);

          }
    }
  }
}


// max 1 1mm fibers
module registration_block_awg_18(block_size=registration_block_size) {
  block = ferrules[0];
  registration_block(block_size, block[0], block[1], block[2]);
}

// max 3 1mm fibers
module registration_block_awg_14(block_size=registration_block_size) {
  block = ferrules[1];
  registration_block(block_size, block[0], block[1], block[2]);
}

// max 5 1mm fibers
module registration_block_awg_12(block_size=registration_block_size) {
  block = ferrules[2];
  registration_block(block_size, block[0], block[1], block[2]);
}

// max 7 1mm fibers
module registration_block_awg_10(block_size=registration_block_size) {
  block = ferrules[3];
  registration_block(block_size, block[0], block[1], block[2]);
}

module ferrule_cutout(height, ferrule_dia, ferrule_length) {
  translate([0, 0, -smidge]) {
    cylinder(d=ferrule_dia - ferrule_lip.x, h=height + smidge * 2);
    translate([0, 0, ferrule_lip.y])
      cylinder(d=ferrule_dia, h=ferrule_length + smidge);
  }
}

module registration_block(block_size, ferrule_dia, ferrule_length, label) {
  label_depth = 0.30;

  difference() {
    intersection() {
      registration_block_base(block_size);
      translate([-block_size.x/2, 0])
        cube(block_size);
    }

    ferrule_cutout(block_size.z, ferrule_dia, ferrule_length);
    translate([0, block_size.y/2 - label_depth + smidge, block_size.z/2])
      rotate([-90, 90, 0])
        linear_extrude(height=label_depth)
          text(text=label, size=5, valign="center", halign="center");
  }
}

module registration_block_base(size) {
  translate([-size.x/2, -size.y/2])
    cube(size);
}

module ferrule_insulated() {
  taper_height = 2;

  translate([0, 0, -ferrule_depth])
    cylinder(d=ferrule_dia, h=ferrule_depth);

  translate([0, 0, taper_height])
    cylinder(d=ferrule_insulation_dia, h=ferrule_insulation_height-taper_height);
  cylinder(d1=ferrule_dia, d2=ferrule_insulation_dia, h=taper_height);

}

module led_strip(count, leds_per_meter) {
  led_stride = 1000/leds_per_meter;
  translate([0, 0, 1]) {
  color("#fefefe")
  for (i = [0 : count - 1])
    translate([i * led_stride, 0, 0]) {
      translate([-led_size/2, -led_size/2, 0])
        cube([led_size, led_size, 2]);
    }

  color("#fcfcfc")
  translate([-led_stride/2, -led_strip_width/2, -1])
  cube([led_stride * count, led_strip_width, 1]);
  }
}
