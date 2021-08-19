include <rgb_strip_to_fiber.scad>

ferrule = ferrules[0]; // 18awg

rotate([-90, 0, 0])
  strip_base_with_fiber_cutouts(5, leds_per_meter=144, ferrule=ferrule, nut_holes=true);
translate([0, 25, 0])
rotate([-90, 0, 0])
  strip_base_with_fiber_cutouts(5, leds_per_meter=144, ferrule=ferrule, nut_holes=false);
