/*
    0 - preview
    1 - wood
    2 - plastic
*/
show = 0;


pl = 10; // plywood thickness
$fn = 64;
mW = 400;
mL = 320;
mH = 22;
mEdge = 6;
mR = 10;
monAn = 75;

piW = 56;
piH = 22;
piFromBottom = 5;

doorFromEdge = 50;
doorClearance = 1;
wireCutout = 8;

soundPlateH = 100;
spkW = 60;
spkL = 40;
spKGrill = 5;
outerR = 40;

cpL = 200;

kbd = [
    430,
    120,
    18
];
kbdPos = 130;
kbdTh = 20;
cpAn = 5;

carveR = 30; // round carve radius
edgeDepth = 5;

bindingTh = 6;
bindingW = 20;
bindingHole = 2;

dev = true; // show devices

footW = 30;
footStandout = 10;
footHeight = bindingTh;

// overhang
overHangW = 200;
overhangL = 20;

// computed
backToScreen = 130;
bottomToCp = 70;
frontPlateH = mL + soundPlateH + outerR;

totalHeight = frontPlateH*sin(monAn)+pl+bottomToCp+cpL*sin(cpAn);
totalWidth = mW+outerR*2+2*pl;

echo ("---------");
echo ("height:");
echo (totalHeight);
echo ("width:");
echo (totalWidth);
echo ("---------");

// assembly
if (show == 0) {
    assembly();
}

/*-- plastic --*/
if (show == 2) {
    translate([0,20]) foot ();
    translate([-130,0,0]) monBinding(50, mH, 3);
    translate([-200,0,0]) monBinding(30, kbdTh, 3);
    translate([-270,0,0]) monBinding(30, kbdTh-3, 3);

    bigBinding(bottomToCp, outerR*sin(cpAn)+pl, cpAn, cos(cpAn),0);
    rotate([0,0,-90]) scale([-1,1,1]) 
        bigBinding(bottomToCp, outerR*sin(cpAn)+pl, cpAn, cos(cpAn),0);
    rotate([0,0,90]) 
        translate([-30,30])
            bigBinding(backToScreen, outerR*cos(monAn)+ pl*sin(monAn), 0, sin(monAn), edgeDepth);
    rotate([0,0,0]) 
        translate([30,30])
            scale([-1,1,1]) bigBinding(backToScreen, outerR*cos(monAn)+ pl*sin(monAn), 0, sin(monAn), edgeDepth);
    
    translate([0,100,0]) binding (bindingW, bindingTh, 90, bindingHole);
    translate([0,140,0])binding (bindingW, bindingTh, monAn, bindingHole);
    translate([0,180,0]) binding (bindingW, bindingTh, 90-cpAn, bindingHole);
}

/*-- wood --*/
if (show == 1) {
    projection() {

        translate([5, 5,0 ]) side(true);
        translate([5, -5,0 ]) scale([1,-1,1]) side(false);
        translate([bottomToCp+cpL*sin(cpAn)+5, -backToScreen-5,0]) top();
        translate([-mW/2-outerR-5, 5,0]) rotate([0,0, 180]) cp();
        translate([-mW/2-outerR-5, -mW/2-outerR-5,0]) bottom();
        translate([95,5,0]) rotate([-90,0,0]) frontPanel();
        translate([5,450+ mW/2+outerR]) rotate([0,0,-90]) {
        back();
        door();
        }
        translate([-mW/2-outerR-5,510]) front();
    }
}

module assembly () {
    translate([0,(frontPlateH - outerR)*cos(monAn)+ backToScreen, -(bottomToCp+(cpL)*sin(cpAn))+pl])
        rotate([90,0,0]){
            %back();
            %door();
        }

    // bindings
    // 90
    translate([
        -mW/2-outerR,
        backToScreen + frontPlateH * cos(monAn) - pl - bindingW - bindingTh*2- 40,
        -bottomToCp - cpL*sin(cpAn) +pl 
    ])
        binding (bindingW, bindingTh, 90, bindingHole);
    // monitor (need 2 of these)
    translate([
        0,
        frontPlateH * cos(monAn)+ pl,
        frontPlateH*sin(monAn)
    ])
        rotate([0,180-monAn, 90]) binding (bindingW, bindingTh, monAn, bindingHole);
    // control panel (need 2 of these)
    translate([
        0,
        -(cpL+outerR)*cos(cpAn),
        -(cpL+outerR)*sin(cpAn)- pl
    ])
    rotate([0,90,90]) binding (bindingW, bindingTh, 90-cpAn, bindingHole);
    
    // big fucking bindings
    translate([
        -mW / 2,
        -cpL*cos(cpAn),
        -(bottomToCp + cpL*sin(cpAn))
    ]) {
        rotate([0,0,90])
            bigBinding(bottomToCp, outerR*sin(cpAn)+pl, cpAn, cos(cpAn), 0);
    }
    scale([-1,1,1])
        translate([
            -mW / 2,
            -cpL*cos(cpAn),
            -(bottomToCp + cpL*sin(cpAn))
        ]) {
            rotate([0,0,90])
                bigBinding(bottomToCp, outerR*sin(cpAn)+pl, cpAn, cos(cpAn), 0);
        }


    translate([
        mW / 2, 
        (mL+soundPlateH)*cos(monAn)+ backToScreen, 
        (mL + soundPlateH)*sin(monAn)
    ]){
        rotate([0, 90,-90])
            bigBinding(backToScreen, outerR*cos(monAn)+ pl*sin(monAn), 0, sin(monAn), edgeDepth);
    }
    scale([-1,1,1])
        translate([
            mW / 2, 
            (mL+soundPlateH)*cos(monAn)+ backToScreen, 
            (mL + soundPlateH)*sin(monAn)
        ]){
            rotate([0, 90,-90])
                bigBinding(backToScreen, outerR*cos(monAn)+ pl*sin(monAn), 0, sin(monAn), edgeDepth);
        }
    // feet

    translate([
        -mW/2-outerR-pl,
        -150,
        -bottomToCp-cpL*sin(cpAn)-bindingTh
    ]) 
        rotate([0,0,90])
            foot ();

    scale([-1,1,1]) translate([
        -mW/2-outerR-pl,
        -150,
        -bottomToCp-cpL*sin(cpAn)-bindingTh
    ]) 
        rotate([0,0,90])
            foot ();

    translate([
        -mW/2-outerR-pl,
        200,
        -bottomToCp-cpL*sin(cpAn)-bindingTh
    ]) 
        rotate([0,0,90])
            foot ();

    scale([-1,1,1]) translate([
        -mW/2-outerR-pl,
        200,
        -bottomToCp-cpL*sin(cpAn)-bindingTh
    ]) 
        rotate([0,0,90])
            foot ();
    // the rest
    translate([-mW / 2, (mL+soundPlateH)*cos(monAn), (mL + outerR + soundPlateH)*sin(monAn)])
    top();

    translate([-mW/2, -pl - (cpL + outerR)*cos(cpAn), -bottomToCp - cpL*sin(cpAn)])
        frontPanel();

    translate([0,0, -bottomToCp - (cpL)*sin(cpAn)]) 
        bottom  ();

    translate([
        mW/2+outerR+pl, 
        -(cpL)*cos(cpAn), 
        -bottomToCp - (cpL)*sin(cpAn)
    ])
        rotate([0, -90, 0]) 
            side(true);
    translate([
        -mW/2-outerR, 
        -(cpL)*cos(cpAn), 
        -bottomToCp - (cpL)*sin(cpAn)
    ])
        rotate([0, -90, 0]) 
            side(false);

    rotate([monAn,0,0])
        translate([0, mL/2 + soundPlateH, -pl]) 
            front(dev);

    rotate ([cpAn,0,0]) {
        cp(dev);
    }
}
module door () {
    linear_extrude(pl)
        translate([-mW/2,doorFromEdge])
            offset(-doorClearance)
                square([mW, (bottomToCp+ cpL*sin(cpAn) + (frontPlateH-outerR)* sin(monAn)) - doorFromEdge]);

}

module back () {
    linear_extrude(pl)
        difference () {
            hull () {
                square([mW+ 2*outerR, .1], true);
                translate([0, bottomToCp+ cpL*sin(cpAn) +  (frontPlateH-(outerR+.1))* sin(monAn)-pl,0]) 
                    scale([1,1*sin(monAn),1]) offset(outerR) square([mW, .1], true);
            }
            translate([-mW/2, doorFromEdge])
            square([mW, (bottomToCp+ cpL*sin(cpAn) + (frontPlateH-outerR)* sin(monAn)) - doorFromEdge]);
            hull () {
                translate([mW/2-doorFromEdge,doorFromEdge]) {
                    translate([-wireCutout/2,0]) square(wireCutout, wireCutout/2);

                    translate([0,-wireCutout/2]) circle(wireCutout/2);
                }
            }
        }
}

module monBinding (side, depth, hole) {
    difference () {
        union () {
            linear_extrude(depth+bindingTh, convexity=4) union () {
                square([side+10, 10]);
                square([10, side+10]);
            }
            linear_extrude(bindingTh, convexity=4) union () {
                hull () {
                    square([side+10, 10]);
                    square([10, side+10]);
                }
            }
        }
        translate([5,5,-0.01]) {
            union () {
                cylinder(depth+2+ bindingTh, hole, hole);
                cylinder(2, hole+2, hole);  
            }
        }
        translate([5,side,-0.01]) {
            union () {
                cylinder(depth+2+ bindingTh, hole, hole);
                cylinder(2, hole+2, hole);  
            }
        }
        translate([side,5,-0.01]) {
            union () {
                cylinder(depth+2+ bindingTh, hole, hole);
                cylinder(2, hole+2, hole);  
            }
        }
    }
}

module foot () {
    union() {
        difference () {
            linear_extrude(bindingTh) hull () {
                translate([0, -bindingW/2-pl])
                    square([footW, bindingW], true);
                resize([0, footStandout, 0]) circle(footW/2);
            }
            translate([-bindingW/3, -bindingW/2-pl, bindingTh])
                scale([1,1, -1]) hole ();
            translate([bindingW/3, -bindingW/2-pl, , bindingTh])
                scale([1,1, -1]) hole ();
        }
        difference () {
            union () {
                translate([0,0, pl+bindingTh]) 
                    resize([0, footStandout, 0]) 
                        sphere(footW/2);

                linear_extrude(pl+bindingTh)
                    resize([0, footStandout, 0]) 
                        circle(footW/2);
                }

                translate([-footW/2, -footStandout])   
                    cube([footW, footStandout, pl+bindingTh+footW]);
            
                translate([0,0, pl+bindingTh]) 
                    resize([0, footStandout/2, 0]) 
                        sphere(footW/2*2/3);
            }

        
    }
}

module binding (side, thick, angle, hole) {
    rotate([-90,0,0]) {
        difference () {
            cylinder(side+2 * thick, side + thick , side + thick);
            rotate([90,0,0]) translate([thick+ side/2,thick+ side/2,0]) hole();
            rotate ([0,0,-180+angle])
            translate([thick+ side/2,0, thick+ side/2]) 
                rotate([-90,0,0]) 
                    hole();
            translate ([-(side+2 * thick),0,-1]) {
                cube ([(side+2 * thick) * 2, side+2 * thick, side+2 * thick+2]);
            }
            rotate ([0, 0,, angle])
                translate ([-(side+2 * thick),0,-1]) {
                    cube ([(side+2 * thick) * 2, side+2 * thick, side+2 * thick+2]);
                }
            translate([0, 0, thick]){
                difference () {
                    cylinder(side, side + thick+2 , side + thick);
                    translate ([-(side+2 * thick),-thick,-1]) {
                        cube ([(side+2 * thick) * 2, side+2 * thick, side+2 * thick+2]);
                    }
                    rotate ([0, 0,, angle])
                        translate ([-(side+2 * thick),-thick,-1]) {
                            cube ([(side+2 * thick) * 2, side+2 * thick, side+2 * thick+2]);
                        }
                }
            }
        }
    }
}

module bigBinding (length, cutout, angle, scaleFactor, edgeOffset) {

    union () {
        intersection () {
           difference() {
                scale([scaleFactor, 1, 1]) 
                    cylinder(length+edgeOffset, outerR+pl, outerR+pl);
                scale([scaleFactor, 1, 1]) 
                    translate([0,0,length-(cutout)])
                        cylinder(cutout+edgeOffset + 1, outerR, outerR);
                scale([scaleFactor, 1, 1]) 
                    cylinder(pl, outerR, outerR);
                scale([scaleFactor, 1, 1])
                    translate([0,0, -1])
                        cylinder (length+edgeOffset, outerR-bindingTh, outerR-bindingTh);
                translate([0,0, length+edgeOffset])
                    rotate([0,270-angle,0])
                        cube([outerR+pl, outerR+pl, outerR+pl]);
            }
            translate([-outerR-pl,0,-1,])
                cube([outerR+pl, outerR+pl, length+2+edgeOffset]);
        }
        // plates
        translate([-outerR* scaleFactor,-bindingW,0])
            difference() {
                translate([0,0,pl])
                    cube([bindingTh*scaleFactor, bindingW, length -  cutout-pl]);
                translate([0, 10, 10+pl])
                    rotate([0,90,0]) {
                        hole();
                    }
                translate([0, 10,length -  cutout- 10])
                    rotate([0,90,0]) {
                        hole();
                    }
            }
        rotate([0,0,270])
            translate([-outerR,0,0])
                difference() {
                    translate([0,0,pl])
                        cube([bindingTh, bindingW, length -  cutout - pl]);
                    translate([0, 10, 10+pl])
                        rotate([0,90,0]) {
                            hole();
                        }
                    translate([0, 10,length -  cutout- 10])
                        rotate([0,90,0]) {
                            hole();
                        }
                }
    }
}

module top () {
    linear_extrude(pl)
    hull () {
        translate([0,-edgeDepth])
            square([mW, backToScreen+edgeDepth]);
        translate([mW/2 - overHangW/2, -overhangL-edgeDepth])
            square([overHangW, backToScreen + overhangL]);
    }
}
module frontPanel () {
    cube([mW, pl, bottomToCp - outerR*sin(cpAn)]);
}
module bottom () {
        linear_extrude(pl)
            hull () {
                translate([0, (mL + soundPlateH) * cos(monAn) + backToScreen, 0])
                    square([mW+ 2 * outerR, 1], true);
                translate([0, -(cpL)*cos(cpAn) ,0])
                    offset(outerR) square([mW, .1], true);
            }
}

module side (hole) {
    depth = (cpL)*cos(cpAn) + (mL+soundPlateH)*cos(monAn) + backToScreen;
    height = bottomToCp + (cpL)*sin(cpAn) + (mL+soundPlateH)*sin(monAn);
        linear_extrude(pl) {
            difference () {
                square ([height, depth]);

                // small square to fix angle
                    translate([bottomToCp+cpL*sin(cpAn), cpL*cos(cpAn)])
                        rotate([0,0,-monAn])
                            translate([edgeDepth, -carveR+frontPlateH-outerR])
                                square([carveR,carveR]);
                   // /small square

                translate([-edgeDepth*sin(cpAn),-edgeDepth]){
                    offset(carveR) offset(-carveR)
                        hull () {
                        translate([height+carveR,0,0])
                            square([
                                0.1, 
                                (cpL)*cos(cpAn) + (mL+soundPlateH)*cos(monAn) + carveR*cos(monAn)
                            ]);
                        translate([ bottomToCp ,0,0])
                            rotate([0,0,90-cpAn])
                                translate([-carveR, 0])
                                square([cpL+carveR, 0.01]);
                    
                    }
                }

                if (hole) {
                    translate([pl+piFromBottom, (cpL)*cos(cpAn)+pl])
                    square([piH, piW]);
                }
            }
        }
}

module cp (kb)  {
    // kb
    if(kb) {
        color("white") 
            translate([0,-kbdPos, -pl]) linear_extrude(pl+5) square([kbd[0], kbd[1]], true);
    }

    // kb plate
    translate([0,0, -pl]) linear_extrude(pl) 
        difference () {
            hull () {
                square([mW+ 2*outerR, .1], true);
                translate([0, -cpL ,0]) 
                    offset(outerR) square([mW, .1], true);
            }
            translate([0,-kbdPos,0]) square([kbd[0], kbd[1]], true);
        }
}
module front (mon) {
    if (mon) {
        %color("#333") translate([0,0,-mH/2]) cube ([mW, mL, mH], true);
    }
    linear_extrude(pl)
        difference () {
            hull () {
                offset (outerR)
                    square([mW, mL], true);
                translate([0,-mL/2-soundPlateH/2,0]) 
                    square([mW+ 2*outerR, soundPlateH], true);
            }
            translate([0,0,-2]) 
                offset(mR) 
                    square ([mW-mEdge*2-2*mR, mL-mEdge*2-2*mR], true);
            
            // speaker holes
            translate([mW/2 - spkL/2 - mEdge,-mL/2-soundPlateH/2 - spkL/2,0]) {
                intersection () {
                    translate([0,spkL/2,0]) circle (spkL/2+spKGrill/2);
                    for (i = [0: spKGrill*2: spkL]) {
                        translate([0, i, 0]) 
                        square ([spkW, spKGrill], true);
                    }
                }
            }
            translate([-mW/2 + spkL/2 + mEdge, -mL/2 - soundPlateH/2 - spkL/2,0]) {
                intersection () {
                    translate([0,spkL/2,0]) circle (spkL/2+spKGrill/2);
                    for (i = [0: spKGrill*2: spkL]) {
                        translate([0, i, 0]) 
                        square ([spkW, spKGrill], true);
                    }
                }
            }
    }
}

module hole () {
    union () {
        cylinder(bindingTh+1, bindingHole, bindingHole);
        translate([0, 0, bindingTh-2+0.01])
            cylinder(2, bindingHole, bindingHole+2);
    }   
    
}