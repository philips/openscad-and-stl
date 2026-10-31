// 70mm x 70mm Mini Weaving Loom with 20 Dents & Child Shuttle
$fn = 40;

// Dimensions (mm)
loom_w     = 70.0;  // Frame width
loom_l     = 70.0;  // Frame length
loom_h     = 4.0;   // Thickness (sturdy enough not to warp under tension)
side_wall  = 7.0;   // Left/right solid frame border
corner_r   = 2.5;   // Child-safe rounded corners

// Dent / Comb settings
num_dents  = 20;    // 20 warp dents per side
dent_depth = 3.5;   // Depth of the notch (mm)
dent_w     = 1.3;   // Width of the notch (fits yarn/crochet thread)
bridge_w   = 5.0;   // Solid plastic between notches and center window

module rounded_box(w, l, h, r) {
    hull() {
        translate([r, r, 0]) cylinder(r=r, h=h);
        translate([w - r, r, 0]) cylinder(r=r, h=h);
        translate([r, l - r, 0]) cylinder(r=r, h=h);
        translate([w - r, l - r, 0]) cylinder(r=r, h=h);
    }
}

module mini_loom() {
    window_w = loom_w - (2 * side_wall);
    window_l = loom_l - (2 * (dent_depth + bridge_w));
    pitch    = window_w / num_dents;

    difference() {
        // Outer rounded body
        rounded_box(loom_w, loom_l, loom_h, corner_r);

        // Center weaving window
        translate([side_wall, dent_depth + bridge_w, -1])
            cube([window_w, window_l, loom_h + 2]);

        // 20 Dents along bottom and top rails
        for (i = [0 : num_dents - 1]) {
            cx = side_wall + (i + 0.5) * pitch;

            // Bottom notch slot + rounded inner bottom
            translate([cx - dent_w / 2, -1, -1])
                cube([dent_w, dent_depth + 1, loom_h + 2]);
            translate([cx, dent_depth, -1])
                cylinder(r=dent_w / 2, h=loom_h + 2);

            // Top notch slot + rounded inner bottom
            translate([cx - dent_w / 2, loom_l - dent_depth, -1])
                cube([dent_w, dent_depth + 1, loom_h + 2]);
            translate([cx, loom_l - dent_depth, -1])
                cylinder(r=dent_w / 2, h=loom_h + 2);
        }
    }
}

// Matching kid-friendly mini weaving shuttle
module shuttle() {
    s_len = 65;
    s_wid = 8;
    s_thk = 2.4;
    translate([0, -14, 0]) {
        difference() {
            hull() {
                translate([s_wid / 2, s_wid / 2, 0]) cylinder(d=s_wid, h=s_thk);
                translate([s_len - (s_wid / 2), s_wid / 2, 0]) cylinder(d=s_wid, h=s_thk);
            }
            // Thread eyelet
            translate([6.5, s_wid / 2, -1])
                cylinder(d=3.0, h=s_thk + 2);
            // Yarn waist notches
            translate([s_len * 0.38, -1, -1])
                cube([15, 2.2, s_thk + 2]);
            translate([s_len * 0.38, s_wid - 1.2, -1])
                cube([15, 2.2, s_thk + 2]);
        }
    }
}

mini_loom();
//shuttle();
