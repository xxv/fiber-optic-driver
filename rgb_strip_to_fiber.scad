leds_per_meter = 60;
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
block_to_led = 5;

part_spacing = 0.2;
wall_thickness = 1.5;

$fa=0.5;
$fs=0.5;


/////// computed
led_stride = 1000/leds_per_meter;


smidge = 0.01;

module mockup(explode=0, half=0) {
  translate([0, explode * 10, 0])
    strip_base(3);
  if (!half)
    translate([0, explode * -10, 0])
      mirror([0, 1, 0])
        strip_base(3);

  translate([0, 0, -block_to_led])
    led_strip(3);
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

module strip_base(count) {
  registration_block_cutout = [registration_block_size.y + part_spacing, registration_block_size.x + part_spacing, registration_block_size.z + part_spacing];
  side_inset = 10;
  led_strip_cutout = led_strip_width + 1;

  housing_size = [(count -1) * led_stride + registration_block_cutout.x + wall_thickness * 2,
                  registration_block_cutout.y/2 + wall_thickness,
                  registration_block_cutout.z + wall_thickness * 2 + block_to_led];

  led_cutout = registration_block_size.x - registration_block_lip;

  difference() {
    translate([-registration_block_cutout.x/2 - wall_thickness, 0, -wall_thickness - block_to_led])
      cube(housing_size);
    for (i = [0 : count - 1])
      translate([i * led_stride, 0, 0]) {
        registration_block_base(registration_block_cutout);
        translate([-led_cutout/2,-led_cutout/2, -block_to_led + smidge])
          cube([led_cutout, led_cutout, block_to_led]);
        translate([-led_cutout/2,-led_cutout/2, registration_block_cutout.z - smidge])
          cube([led_cutout, led_cutout, wall_thickness + smidge * 2]);
      }
    translate([-registration_block_cutout.x/2 - wall_thickness - smidge, -led_strip_cutout/2,  - block_to_led -0])
      cube([housing_size.x + smidge * 2, led_strip_cutout, led_strip_thickness]);
  }
}


// max 3 1mm fibers
module registration_block_awg_18(block_size) {
  registration_block(block_size, 2.2, 12);
}

// max 3 1mm fibers
module registration_block_awg_14(block_size) {
  registration_block(block_size, 2.2, 12);
}

// max 5 1mm fibers
module registration_block_awg_12(block_size) {
  registration_block(block_size, 2.8, 12);
}

// max 7 1mm fibers
module registration_block_awg_10(block_size) {
  registration_block(block_size, 4.7, 12);
}

module registration_block(block_size, ferrule_dia, ferrule_length) {
  difference() {
    intersection() {
      registration_block_base(block_size);
      translate([-block_size.x/2, 0])
        cube(block_size);
    }

    translate([0, 0, -smidge]) {
      cylinder(d=ferrule_dia - ferrule_lip.x, h=block_size.z + smidge * 2);
      translate([0, 0, ferrule_lip.y])
        cylinder(d=ferrule_dia, h=ferrule_length + smidge);
    }
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

module led_strip(count) {
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
