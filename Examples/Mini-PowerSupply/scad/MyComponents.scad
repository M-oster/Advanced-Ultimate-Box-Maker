//
// using NopSCADlib Copyright Chris Palmer 2018
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// Shows electronic parts for Ultimate-Box creator

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/fans.scad>
use <NopSCADlib/vitamins/washers.scad>
include <NopSCADlib/printed/fan_guard.scad>
use <NopSCADlib/vitamins/fuseholder.scad>
use <NopSCADlib/vitamins/jack.scad>
use <NopSCADlib/printed/foot.scad>  // for case-feet
include <NopSCADlib/vitamins/panel_meters.scad>
include <NopSCADlib/vitamins/batteries.scad>

// ************************** electronic parts on Front-panel ****************
module ShowJack(Jx, Jy, color) {
      translate([Length - (Thick + PanelThickGap),
               Thick + PanelHorizontalGap,
               Thick + PanelVerticalGap]) {
                  rotate([90, 0, 90]) {
                      translate([Jx+3,Jy+3,0]) {
                         post_4mm(color,PanelThick);
                      }
                  }
      } 
      
}

module ShowPSU(Px,Py,type) {
   translate([Length - (Thick + PanelThickGap),
               Thick + PanelHorizontalGap,
               Thick + PanelVerticalGap]) {
                  rotate([90,0,90]){
                     translate([Px,Py,0]){
                        panel_meter(panel_meters[type]);
                     }
                  }
   }
   
}


module ShowLEDSocket(LedX, LedY) {
   translate([Length - (Thick + PanelThickGap),
               Thick + PanelHorizontalGap,
               Thick + PanelVerticalGap]) {
        rotate([180, 0, 90]) {
            translate([LedX+3, -4, -(LedY+3)]) {        // [x, z, -y]
                color("Silver") {
                    import("/../assemblies/LED_5mm+Socket.3mf", convexity=3);
                }
            }
        }
    }
}

module ShowBatteryMeter(Bx, By) {
   translate([Length - (Thick + PanelThickGap),
               Thick + PanelHorizontalGap,
               Thick + PanelVerticalGap]) {        
        rotate([-90, 0, 90]) {
            translate([Bx, -By, 1]) {   // [x, -y, z]
                meter( led_meters[2], colour = "blue", value = "lllll");
            }
        }
   }
        
}

// *************** electronic parts on Back-panel ******************
module ShowFan(Fx, Fy, type) {
 translate([Thick + PanelThickGap + PanelThick,
               Thick + PanelHorizontalGap + PanelWidth,
               Thick + PanelVerticalGap]) {
      rotate([90, 0, 270]) {
         translate([fan_size/2+Fx,fan_size/2+Fy,0]) {
            let($show_threads = true)
            fan_assembly(fans[type], PanelThick, true);
         }
      }
   }

}
module ShowSwitch(Sx, Sy, type, color) {
   translate([Thick + PanelThickGap,
               Thick + PanelHorizontalGap + PanelWidth,
               Thick + PanelVerticalGap]) {
      rotate([90, 0, 270]) {
           translate([Sx+19.8/2, Sy+12.9/2, 0]) {  // dimension/2 of Switch
              rotate([0,0,90]) {
               rocker(rockers[type], color);
            }
         }
      }
   }

}

module ShowPowerJack(PwrX, PwrY) {
   translate([Thick + PanelThickGap+PanelThick,
              Thick + PanelHorizontalGap + PanelWidth,
              Thick + PanelVerticalGap]) {
         rotate([0, 180, 0]) {
          translate([-6.4, -(PwrX+3), -(PwrY+2.7)]) {     // [ z, -x , -y] , z-offset to fit to panel
            color(grey(20)) {
                import("../assemblies/PowerJack.amf", convexity=3);
            }
            translate([0, 0, 0]) {     // [ z, -x , -y] , z-offset to fit to panel
                color("Black") {
                    import("../assemblies/PowerJack-Ring.amf", convexity=3);
                }
            }
            color("Silver") {
                translate([-13+PanelThick, 0, 0]) {     // [ z, -x , -y] , z-offset to fit to panel
                    import("../assemblies/PowerJack-Washer.amf", convexity=3);
                }
                translate([-16.2+PanelThick, 0, 0]) {     // [ z, -x , -y] , z-offset to fit to panel
                    import("../assemblies/PowerJack-Nut.amf", convexity=3);
                }
            }
         }
      }
   }
}

module ShowFuseHolder (posX, posY) {
    translate([Thick + PanelThickGap,
               Thick + PanelHorizontalGap + PanelWidth,
               Thick + PanelVerticalGap]) {
        rotate([180, 90, 0]) {
            translate([-(posY+3), posX+3, 0]) {  // [-y, x, z]
                let($show_threads=1)
                fuseholder(PanelThick);
            }
        }
    }
}

module ShowSlideSwitch(Cx, Cy) {
    translate([Thick + PanelThickGap + PanelThick,
               Thick + PanelHorizontalGap + PanelWidth,
               Thick + PanelVerticalGap]) {
        rotate([0, 0, 90]) {
            translate([-(Cx+5.7), -(4.5+PanelThick), Cy+3]) {        // [-x, z, y]
                color(grey(20)) {
                    import("/../assemblies/DPDT_Slide_Switch.amf", convexity=3);
                }
            }
        }
    }
}

// show USB-Holder
module ShowUSBHolder(Hx,Hy,Hz) {
   translate([GeneralMarginX, GeneralMarginY, Thick]) {
        rotate([0,0,90]) {
            translate([Hx-19.5,-Hz,Hy-3.5]) { // [x, -z, y]
                import("../assemblies/USB-Holder.amf", convexity=3);
            }
        }
    }
      
}

// show USB-module
module ShowUSBModule(Ux,Uy, Uz) {
   translate([GeneralMarginX, GeneralMarginY, Thick]) {
        rotate([0,0,90]) {
            //translate([Ux-12.5,-(Uz+28),Uy-1]) { // [x, -z, y]
            translate([Ux-12.5,-(Uy-40),Uz]) { // [x, -y, z]
                import("../assemblies/USB-Module_CH340G.amf", convexity=3);
            }
        }
        rotate([0,0,0]) {
            translate([Uy-56,Ux-2,Uz+1.6]) {   //  [y, x, z]
                color("Olive") {
                    linear_extrude(height=FontThick) {
                        text("USB-PCB", font="Arial black", halign="center", valign="center",size=4);
                    }
                }
            }
        }
    }
      
}

module ShowRelayHolder(Rx, Ry) {
    translate([Thick + PanelThickGap + PanelThick,
               Thick + PanelHorizontalGap + PanelWidth,
               Thick + PanelVerticalGap]) {
        rotate([0, 90, 0]) {
            translate([-(Ry+27.5), -(Rx+8.5), 0]) {        // [-y, z, y]
                color(grey(20)) {
                    import("/../assemblies/Relay-Holder.amf", convexity=3);
                }
            }
        }
    }
}

module ShowAutomFuseHolder (posX, posY) {
    translate([Thick + PanelThickGap,
               Thick + PanelHorizontalGap + PanelWidth,
               Thick + PanelVerticalGap]) {
        rotate([90, 0, 90]) {
            translate([-(posX+6),posY+11,-2.5]) {  // [-x, y, -z]
                color(grey(20)) {
                    import("/../assemblies/AutomFuseholder.amf", convexity=3);
                }
            }
        }
    }
}

// ******************* electronic parts inside the box ******************
module ShowBatHolders(Bx, By,) {
      translate([GeneralMarginX, GeneralMarginY, Thick+11]) {
         rotate([0,90,0]) {
               translate([0,Bx,By]) {   // [ -z, x, y]
                  import("../assemblies/BATTERY-HOLDER_18650.stl", convexity=3);
                  translate([-20,0,0]) {
                     import("../assemblies/BATTERY-HOLDER_18650.stl", convexity=3);
                     translate([-20,0,0]) {
                        import("../assemblies/BATTERY-HOLDER_18650.stl", convexity=3);
                     }
                  }
               }
         }
      }
}

module ShowBatteries(Batx, Baty, type) {
    translate([GeneralMarginX, GeneralMarginY, Thick+11]) {
       rotate([0,90,0]) {
           translate([0,Batx,Baty]) {
               battery(batteries[type]);
               translate([-20,0,0]) {
                     battery(batteries[type]);
                     translate([-20,0,0]) {
                         battery(batteries[type]);
                     }
                  }
           }
    }
 }
}

module ShowBatHolderPillars(Px, Py) {       // start-pos of Pillars
    PillarDiffX = 25;    //x-diff of the 2 pillars, its the Thick of BatteryHolder + Margin
    translate([GeneralMarginX, GeneralMarginY, Thick]) {
        translate([Py, Px, 0]) {        // coordinates switched because of NopSCADlib
             pillar(pillars[12-pcb_pillar_offset]);
        }
        translate([Py, Px, pillars[12-pcb_pillar_offset][3]]) { // z=height of 2nd Pillar
            pillar(pillars[12-pcb_pillar_offset]);
        }
        translate([Py, Px, 2* pillars[12-pcb_pillar_offset][3]]) { // z=height of 3rd Pillar
            let($show_threads = true)
            pillar(pillars[9-pcb_pillar_offset]);
        }

        translate([Py, Px+PillarDiffX, 0]) {
            pillar(pillars[12-pcb_pillar_offset]);
        }
        translate([Py, Px+PillarDiffX, pillars[12-pcb_pillar_offset][3]]) { // z=height of 2nd Pillar
            pillar(pillars[12-pcb_pillar_offset]);
        }
        translate([Py, Px+PillarDiffX, 2* pillars[12-pcb_pillar_offset][3]]) { // z=height of 3rd Pillar
            let($show_threads = true)
            pillar(pillars[9-pcb_pillar_offset]);
        }

//draw washers
        translate([Py, Px, 2* pillars[12-pcb_pillar_offset][3] + pillars[9-pcb_pillar_offset][3]]) {
            washer(M3_washer);
        }
        translate([Py, Px+PillarDiffX, 2* pillars[12-pcb_pillar_offset][3] + pillars[9-pcb_pillar_offset][3]]) {
            washer(M3_washer);
        }

// draw Battholder on top
        translate([Py-5, Px-5, 2* pillars[12-pcb_pillar_offset][3] + pillars[9-pcb_pillar_offset][3]+1]) {
            DrawBattHolder(Px=Px, Py=Py, PillarDiffX=PillarDiffX);
        }

// draw nuts
        translate([Py, Px, 2* pillars[12-pcb_pillar_offset][3] + pillars[9-pcb_pillar_offset][3]+1+PCBThick]) {
            nut_and_washer(M3_nut, false);
        }
        translate([Py, Px+PillarDiffX, 2* pillars[12-pcb_pillar_offset][3] + pillars[9-pcb_pillar_offset][3]+1+PCBThick]) {
            nut_and_washer(M3_nut, false);
        }

   }
    
}


// draw BatteryHolder on top
module DrawBattHolder (Px, Py, PillarDiffX=25) {    // separated mod. because of STL-printing w.o. its position in the box
    BHwidth=10;     // BattHolderWidth
        color(grey(20)) {
            linear_extrude(height = 2, convexity=10) {
                difference() {
                    square([BHwidth, PillarDiffX+10]);   // width=10, length=width of Battholder + 10
                    translate([BHwidth-BHwidth/2,BHwidth/2,0]) {
                        circle(d=3.0+CutoutMargin);
                    }
                    translate([BHwidth-BHwidth/2,BHwidth/2+PillarDiffX,0]) {
                        circle(d=3.0+CutoutMargin);
                    }
                }
            }
        }
}


// show Buck-Converter with constant current
module ShowBuckConverter(Bx,By,Bz) {
   translate([GeneralMarginX, GeneralMarginY, Thick]) {
        rotate([90,0,90]) {
            translate([By+29,Bz+2,Bx+11]) { // [x, z, y]
                import("../assemblies/dc-dc-5A-cc.stl", convexity=3);
            }
        }
        translate([By+14,Bx+32,Bz+13]) {
            rotate([0,0,90]) {
                color("Olive") {
                    linear_extrude(height=FontThick) {
                        text("Buck-Conv.", font="Arial black", halign="center", valign="center",size=5);
                    }
                }
            }
        }
    }
      
}


// show BluTooth module
module ShowBTModule(Bx,By,Bz) {
   translate([GeneralMarginX, GeneralMarginY, Thick]) {
        rotate([0,0,0]) {
            translate([Bx-1,By,Bz]) { // [x, y, z]
                import("../assemblies/BT-Modul_BK3231.amf", convexity=3);
            }
        }
        translate([Bx+10,By+20,Bz+1.6]) {
            rotate([0,0,90]) {
                color("Olive") {
                    linear_extrude(height=FontThick) {
                        text("BT-PCB", font="Arial black", halign="center", valign="center",size=5);
                    }
                }
            }
        }
    }
      
}




