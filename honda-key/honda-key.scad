function mm(i) = i*25.4;
function in(mm) = mm/25.4;

blade_h = mm(.118)/2;
blade_w = mm(.352);
blade_l = 46;
blade_tip_w = 3;
body_l = 30;
cut_h = (blade_tip_w-mm(.035))/2;
cut_w = 1;

depths = [in(blade_w), .312, .298, .283, .269, .255, .241, in(blade_w/2)];
incr = .12;
positions = [.719, .599, .480, .360, .241, .241 - incr, -.05];
guard = 1.005;

module blank() {
    translate([-body_l, -body_l/2+blade_w/2, 0]) {
        cube([body_l, body_l, blade_h]);
    }
    difference() {
    cube([blade_l, blade_w, blade_h]);
        translate([blade_l, blade_w/2+blade_tip_w/2, 0]) {
            rotate([0,0,45]) {
                cube([10, 10, blade_h]);
            }
        }
        translate([blade_l, blade_w/2-blade_tip_w/2, 0]) {
            rotate([0,0,45+180]) {
                cube([10, 10, blade_h]);
            }
        }
    }
}


module cut_shape(w, d) {
    linear_extrude(height=cut_h) {
        hull(){
            translate([-w/2+(d<0?d:0), 0, 0]) {
                rotate([0,0,45]) {
                    square([10, 10]);
                }
            }
            translate([w/2+(d>0?d:0), 0, 0]) {
                rotate([0,0,45]) {
                    square([10, 10]);
                }
            }
        }
    }
}

module cut(position, bit, d) {
    if(position < 7) {
        translate([blade_l-mm(positions[position]), mm(depths[bit]), blade_h-cut_h]) {
            cut_shape(cut_w, d);
        }
    } else {
        translate([blade_l-mm(positions[position-7]), blade_w-mm(depths[bit]), blade_h-cut_h]) {
            rotate([0, 0, 180]) {
                cut_shape(cut_w, d);
            }
        }
    }
}

module half(bits) {
    difference() {
        blank();
        for(i=[0:4]){
            cut(i, bits[i], i<4 ? (bits[i+1] >= bits[i] ? mm(incr) : 0) : 0);
            cut(i, bits[i], i>0 ? (bits[i-1] >= bits[i] ? -mm(incr) : 0) : 0);
        }
        cut(5,1);
        cut(6,7);
        for(i=[7:11]){
            cut(i, bits[i-2], i<11 ? (bits[i-2+1] >= bits[i-2] ? -mm(incr) : 0) : 0);
            cut(i, bits[i-2], i>7 ? (bits[i-2-1] >= bits[i-2] ? mm(incr) : 0) : 0);
        }
        cut(12,1);
        cut(13,7);
        
        translate([blade_l, mm(depths[1]), blade_h-cut_h]) {
        cut_shape(mm(2*guard));
        }
        translate([blade_l, blade_w-mm(depths[1]), blade_h-cut_h]) {
            rotate([0, 0, 180]) {
                cut_shape(mm(2*guard));
            }
        }

    }
}

module full(bits) {
    union(){
        half(bits);
        translate([0, blade_w/2, 0]) {
            rotate([180, 0, 0]) {
                translate([0, -blade_w/2, 0]) {
                    half(bits);
                }
            }
        }
    }
}

full([3,1,4,1,5,1,2,1,5,3]);
