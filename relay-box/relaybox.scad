pcbL = 51;
pcbW = 39;
pcbH = 1.6;
pcbUnderH = 4;
screwW = 33.3;
screwL = 44.5;
screwD = 3;
boxHfromPcb = 12;
walls = 2;
roundAnglesD = 2*walls;

relaysL = 20;
relaysW = 33;
relaysH = 16;
relaysDeltaX = 19-.5;


module screwMount() {
    difference(){
        cylinder(d=screwD+2*walls, h= pcbUnderH);
        cylinder(d=screwD, h=pcbUnderH);
    }
}

module screwMounts() {
    screwMount();
    translate([0, screwW, 0])
        screwMount();
    translate([screwL, 0, 0]){
        screwMount();
        translate([0, screwW, 0])
            screwMount();
    }
}

module corner(h) {
    cylinder(d=roundAnglesD, h=h, $fn=20);
}

module roundedBox(h) {
    hull() {
        corner(h);
        translate([pcbL, 0, 0])
            corner(h);
        translate([0, pcbW, 0]) {
            corner(h);
            translate([pcbL, 0, 0])
                corner(h);
        }
    }
}

module relays() {
    cube([relaysL, relaysW, relaysH]);
}

screwConnL = 8;
screwConnW = 30;
screwConnH = 10.5;
screwConnDeltaX = 4;

module screwConnectors() {
    cube([screwConnL, screwConnW, screwConnH]);
}

wiresL = 3;
wiresW = 26;
wiresH = 20;
wiresDeltaX = 2;
wiresDeltaY = 6;

module inputWires() {
    cube([wiresL, wiresW, wiresH]);
}

powerWireD = 4;
powerWireL = 10;
powerWireSpace = screwConnW/6;
powerWireH = 3.3;
powerWireDeltaX = 3.6;

module powerWire(){
    cylinder(d=powerWireD, h=powerWireL, $fn=20);
}

module powerWires() {
    for(i=[0:5]) {
        translate([0, i*powerWireSpace, 0])
            rotate([0, 90, 0])
                powerWire();
    }
}

module pcb() {
    union(){
        cube([pcbL, pcbW, pcbH]);
        translate([relaysDeltaX, (pcbW-relaysW)/2, pcbH])
            relays();
        translate([pcbL-screwConnDeltaX-screwConnL, (pcbW-screwConnW)/2, pcbH])
            screwConnectors();
        translate([pcbL-screwConnDeltaX, powerWireSpace/2+(pcbW-screwConnW)/2, pcbH+powerWireH])
            powerWires();
        translate([pcbL-screwConnDeltaX-powerWireDeltaX, powerWireSpace/2+(pcbW-screwConnW)/2, pcbH+screwConnH-.1])
            rotate([0, -90, 0])
            powerWires();
        translate([wiresDeltaX, wiresDeltaY, 0])
            inputWires();
    }
}


bottomH = pcbUnderH+pcbH+walls+powerWireH;

module bottom() {
    union(){
        difference() {
            roundedBox(bottomH);
            translate([0, 0, walls])
                cube([pcbL, pcbW, 10]);
            translate([0, 0, pcbUnderH+walls])
                pcb();
        }
        translate([(pcbL-screwL)/2, (pcbW-screwW)/2, walls])
            screwMounts();
    }
}

counterSinkH = 3;
counterSinkD = 6;

module counterSink(){
    mirror([0, 0, 1]){
        cylinder(d=counterSinkD, h=counterSinkH, $fn=20);
        cylinder(d=screwD+1, h=10, $fn=20);
    }    
}

module counterSinks(){
//    counterSink();
    translate([0, screwW, 0])
        counterSink();
    translate([screwL, 0, 0]){
        counterSink();
        translate([0, screwW, 0])
            counterSink();
    }
}

topH = screwConnH-powerWireH+walls+counterSinkH;

module top(){
    difference(){
        translate([0, 0, bottomH])
            roundedBox(topH);
        cube([pcbL, pcbW, bottomH+screwConnH-powerWireH]);
        translate([0, 0, pcbUnderH+walls])
            pcb();
        translate([(pcbL-screwL)/2, (pcbW-screwW)/2, bottomH+topH])
            counterSinks();
    }
}

bottom();
//top();
%translate([0, 0, pcbUnderH+walls])
    pcb();

translate([0, 2*(pcbW+roundAnglesD), bottomH+topH])
    rotate([180, 0, 0]) 
        top();