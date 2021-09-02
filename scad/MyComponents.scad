//
// using NopSCADlib Copyright Chris Palmer 2018
// nop.head@gmail.com
// hydraraptor.blogspot.com
//

// Shows electronic parts for Advanced Ultimate-Box creator

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/fans.scad>

use <NopSCADlib/printed/foot.scad>  // for case-feet

// include here additional components which should be displayed


// ***************** insert electronic parts on Front-panel ***************


// ************************************************************************


// *************** insert electronic parts on Back-panel ******************
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
// **********************************************************************

// ******************* insert electronic parts inside the box ***********


// **********************************************************************




