baseL = 43;
baseW = 16.1;
baseH = 2;
baseCornerRad = 1.7;

baseHoleD = 6.1;
baseHoleFromSide = 6.1;

colThickness = 2;
colDTop = 10.5;
colDBottom = 13.5;
colH = 45; // 47 but better too long than too short
colHoleDTop = colDTop - colThickness;
colHoleDBottom = colDBottom - colThickness;

stopH = 4.5;
stopD = 13.4;

$fn = 50;
    
module baseCorner() {
    cylinder(h=baseH, r=baseCornerRad);
}

module base() {
    difference() {
        hull(){
            translate([-(baseL-2*baseCornerRad)/2, -(baseW-2*baseCornerRad)/2, 0]) {
                baseCorner();
            }
            translate([(baseL-2*baseCornerRad)/2, -(baseW-2*baseCornerRad)/2, 0]) {
                baseCorner();
            }
            translate([-(baseL-2*baseCornerRad)/2, (baseW-2*baseCornerRad)/2, 0]) {
                baseCorner();
            }
            translate([(baseL-2*baseCornerRad)/2, (baseW-2*baseCornerRad)/2, 0]) {
                baseCorner();
            }
        }
        translate([-((baseL-baseCornerRad)/2 - baseHoleFromSide), 0, 0]) {
            cylinder(d = baseHoleD, h = baseH);
        }
        translate([((baseL-baseCornerRad)/2 - baseHoleFromSide), 0, 0]) {
            cylinder(d = baseHoleD, h = baseH);
        }
        cylinder(d = colHoleDBottom, h = colH);
    }
}

module col(){
    difference() { 
        cylinder(d1 = colDBottom, d2 = colDTop, h = colH);
        cylinder(d1 = colHoleDBottom, d2 = colHoleDTop, h = colH);
    }
}

module stop() {
    rotate_extrude(convexity = 10) {
        translate([(stopD - stopH)/2, 0, 0]) {
            circle(d = stopH);
        }
    }
}

module whole() {
    union(){
        base();
        translate([0, 0, colH-stopH/2]) {
            stop();
        }
        col();
    }
}    
    
whole();    

    
//col();
    
    
    
    
    
    
    
    
    
    