include <BOSL2/std.scad>

include <NopSCADlib/core.scad>

include <MyTubings.scad>
include <MyPCBPillars.scad>
include <MyInserts.scad>
include <MyComponents.scad>
include <MyRockers.scad>
include <MyExplanations.scad>






/* Box design originally by:
////////////////////////////////////////////////////////////////////
              -    FB Aka Heartman/Hearty 2016     -
              -   http://heartygfx.blogspot.com    -
              -       OpenScad Parametric Box      -
              -         CC BY-NC 3.0 License       -
////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////
Improved by jbebel:
http://github.com/jbebel/Ultimate-Box-Maker

To create a box, start by modifying the numerical parameters in the sections
below. This can be accomplished using a release of OpenSCAD newer than 2015.03.
As of the time of writing, this means that a development snapshot is required.
The Thingiverse Customizer may also potentially work, but at the time of
writing, it was inoperable.

The simplest choice is to hand-edit the .scad file. Feature toggles are
annotated with a comment. The other numerical parameters are measurements in
mm. Everything is parametrized, so if you double all the non-feature parameters
you will double the box size in every dimension. Certain parameters are derived
from other parameters. If you wish to override them, you may, but sensible
defaults have been chosen. Notably the design in this revision is particularly
PCB-centric, in that you should start with your PCB size and adjust the margins
around it to determine the box size. If you care more about the box size, you
can set the Length, Width, and Height explicitly, but read the comments around
them.

Once your box is sized appropriately, you can use the Panel modules to design
the holes and text for the front and back panels. Helper variables are provided
to assist you in positioning these holes relative to the PCB, if your holes are
for PCB-mounted components.

When you are ready to print, adjust the values in the "STL element to export"
section, and export each part one at a time.

Experimental options are provided for a screwless design, but these are
untested. In particular, the box fixation tabs may need thicknesses adjusted
in order to have the appropriate flexibility.

////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////
extended by m-oster
http://github.com/M-oster/Advanced-Ultimate-Box-Maker

________________________________________________________


*/

// preview[view:north east, tilt:top diagonal]
//----------------------- Box parameters ---------------------------

/* [Box options] */
// - Wall thickness
Thick = 2.8;//[2.0:0.1:5.0]
// - Panel thickness
PanelThick = 2.5;
// - Font Thickness
FontThick = 0.6;
// - Filet Radius
Filet = 2;
// - 0 for beveled, 1 for rounded
Round = 1; // [0:No, 1:Yes]
// - Printer margin around interior cutouts
CutoutMargin = 0.3;
// - Margin between mating parts
PartMargin = 0.1;
// - Draw PCB
PCBDraw = 1; //[0:No, 1:Yes]
// - Text on PCB
TextOnPCB="PCB";
// - Draw Electronic Parts
PartsDraw = 0; //[0:No, 1:Yes]
// - Decorations?
Decorations = 1; // [0:No, 1:Yes]
// - Decorations to ventilation holes
Vent = 1; // [0:No, 1:Yes]
// - Decoration-Holes width (in mm)
Vent_width = 1.7;  //1.5
// - Tolerance (Panel/rails gap on one edge)
PanelThickGap = CutoutMargin + PartMargin;      // +0.4
PanelVerticalGap = PartMargin;                  // +0.1
PanelHorizontalGap = CutoutMargin + PartMargin; // +0.4
// - Bar/Recess on upper edge of bottom/top-shell (if Thick >= 2.5)
bar_recess = 1; //[0:No, 1:Yes]
// - Additional Holes - [OnOff,xPos,yPos,diam]
aAddHoles = [[0,54,103,3]];
//           Add.Hole1       
// - Font general (Windows-Fonts)
sTextFont = "Calibri"; // [Arial, Arial Black, Bahnschrift condensed, Calibri, Courier]

/* [Case Feet] */
// - Kind of Case Feet
CaseFeet = 4; // [0:No Feet, 1:OnlyHoles, 2:Rubber Feet, 3:Folding Feet, 4:Folding Feet small]
// - Hole diameter for Case Feet (if not "No Feet")
CaseFeetHole = 3.1;
// - Margin between front panel and Case foot hole
FrontCaseFeetMargin = 7;
// - Margin between back panel and Case foot hole
BackCaseFeetMargin = 10;
// - Margin between left wall and Case foot hole
LeftCaseFeetMargin = 10;
// - Margin between right wall and Case foot hole
RightCaseFeetMargin = 10;

/* [Box Fixation Tabs] */
// - Side screw hole (or snap) diameter (not for inserts)
ScrewHole = 2.2606;
// - Screw thread major diameter for outer shell
BoxHole = 2.8448;
// Thickness of fixation tabs (not for inserts)
TabThick = 2.5;
// use Inserts
// - Varius kinds to fasten the Shells
tab_inserts = 0; //[0:Screws, 1:Snap-tabs EXPERIMENTAL, 2:Insert_M2x4, 3:Insert_M3x5, 4:Insert_M3x6g, 5:Insert_M4x5, 6:Insert_M4x6]
// Back left tab
BLTab = 0; // [0:Bottom, 1:Top]
// Back right tab
BRTab = 0; // [0:Bottom, 1:Top]
// Front left tab
FLTab = 0; // [0:Bottom, 1:Top]
// Front right tab
FRTab = 0; // [0:Bottom, 1:Top]
// EXPERIMENTAL: Snap tabs
SnapTabs = 0; // [0:Screws, 1:Snaps]


/* [PCB Options] */
// - PCB Length
PCBLength = 75.0;
// - PCB Width
PCBWidth = 100.0;
// - PCB Thickness
PCBThick = 1.6;
// You likely need to maintain |TabThick| margin on the left and right for tabs
// and whatnot.
// - Margin between front panel and PCB
FrontEdgeMargin = 25;
// - Margin between back panel and PCB
BackEdgeMargin = 30;
// - Margin between left wall and PCB
LeftEdgeMargin = 10;
// - Margin between right wall and PCB
RightEdgeMargin = 35;
// - Margin between top of PCB and box top
TopMargin = 70;

/* [PCB Feet] */
// - Kind of PCB feet? (x4), No Feet, with Feet, Holes, Spacers or Pillars instead of PCB-Feet
PCBFeet = 1; // [1:with Feet, 0:No Feet, 2:only Holes, 3:Feet w.Insert_M2x4, 4:Feet w.Insert_M3x5, 5:Feet w.Insert_M3x6g, 6:Feet w.Insert_M4x5, 7:Feet w.Insert_M4x6, 8:M3x8_hex_pillar, 9:M3x10_hex_pillar, 10:M3x15_hex_pillar, 11:M3x20_hex_pillar,  12:M3x25_hex_pillar, 13:M4x10_hex_pillar, 14:SPACER_M3x5, 15:SPACER_M3x8, 16:SPACER_M3x10, 17:SPACER_M3x15, 18:SPACER_M3x20, 19:SPACER_M4x5, 20:SPACER_M4x8, 21:SPACER_M4x10, 22:SPACER_M4x15, 23:SPACER_M4x20]
// - Foot height above box interior
FootHeight = 7;
// - Foot diameter
FootDia = 7;
// - Hole diameter, or peg for screwless design, overwritten by choice of PCBFeet
FootHole = 3.0; // [2.0:0.1:4.0]
// - EXPERIMENTAL Screwless design
Screwless = 0; // [0:Screws, 1:Screwless]
FootFilet = FootHeight/4;

// Foot centers are specified as distance from PCB back-left corner.
// X is along the "length" axis, and Y is along the "width" axis.

// - Foot 1, rear left, distance from back PCB edge
Foot1X = 4.2;
// - Foot 1, rear left, distance from left PCB edge
Foot1Y = 3.0;
// - Foot 2, rear right, distance from back PCB edge
Foot2X = 4.2;
// - Foot 2, rear right, distance from right PCB edge
Foot2YFromEdge = 3.0;
Foot2Y = PCBWidth - Foot2YFromEdge;
// - Foot 3, front left, distance from front PCB edge
Foot3XFromEdge = 4.2;
Foot3X = PCBLength - Foot3XFromEdge;
// - Foot 3, front left, distance from left PCB edge
Foot3Y = 3.0;
// - Foot 4, front right, distance from front PCB edge
Foot4XFromEdge = 4.2;
Foot4X = PCBLength - Foot4XFromEdge;
// - Foot 4, front right, distance from right PCB edge
Foot4YFromEdge = 3.0;
Foot4Y = PCBWidth - Foot4YFromEdge;

/* [Frontplate Holes] */
// - Round Holes - [On/Off,xPos,yPos,Diam1,Diam2,Symmetric],[...]
aFP_Holes = [[0,0,0,1,1,0]];
//           

// - Square Holes - [On/Off,xPos,yPos,Width,Hight,Filet],[...]
aFP_SHoles = [[0,10,15,15,10,0]];
//               SquareHole

// - Square Holes with Recess-Margin -[ OnOff, Sx, Sy, Sl, Sw, Recess, XMargin, YMargin],[...]
aFP_SHolesRecess = [[0,9,50,29.5,18,-1.7,1.5,2.0]];
//                   


/* [Frontplate Text] */
// - Round Text [On/Off,xPos,yPos,Fontsize,Diameter,Arc,Start,"Text"],[...]
aFP_RTexts = [[0,122,21,3,10,180,0,"1 . 2 . 3 . 4 . 5 . 6"]];
// - Text  [On/Off,xPos,yPos,Fontsize,"Text"],[...]
aFP_STexts = [[0,50,43,6,"Frontpanel"]];


/* [Backplate Holes] */
// - Square Holes - [On/Off,xPos,yPos,Width,Hight,Filet],[...]
aBP_SHoles = [[0,103,56,19.2,12.9,0]];
//                AC-Power-switch


// - Square Holes with Recess-Margin -[ OnOff, Sx, Sy, Sl, Sw, Recess, XMargin, YMargin],[...]
aBP_SHolesRecess = [[0,66,65,7.0,3.0,1.8,2.7,2.0]];
//                               USB-conn.
// References between USB/BT-switch and its holes
USBcon_LHoleX=aBP_SHolesRecess[0][1]-12.5;
USBcon_RHoleX=aBP_SHolesRecess[0][1]+14.5;
USBcon_HoleY= aBP_SHolesRecess[0][2]-1;

// - Round Holes - [On/Off,xPos,yPos,Diam1,Diam2,Symmetric],[...]
aBP_Holes = [[0,0,0,1.0,1.0,0]];
//             

/* [Backplate Text] */
//Text [On/off,xPos,yPos,Fontsize,"Text"],[...]
aBP_STexts = [[0,65,43,6,"Backpanel"]];
// Round Text [On/off,xPos,yPos,Fontsize,Diameter,Arc,Start,'Text']
aBP_RTexts = [[0,0,0,0,0,0," "]];

/* [FAN guard Settings] */
// - Fan Position Backplane - [On/Off,xPos,yPos]
BP_fan_position = [0,10,8];
// Cover size. E.g. 80 for a 80mm Fan
fan_size_in_mm = 50;//[25:25mm fan, 30:30mm fan, 40:40mm fan, 50:50mm fan, 60:60mm fan, 70:70mm fan, 80:80mm fan, 92:92mm fan, 120:120mm fan, 140:140mm fan]

// E.g. 2.9 for M2.5, 3.3 for M3, 4.4 for M4
screw_hole_diameter_in_mm = 3.3;// [2.9:M2, 3.3:M3, 4.4:M4] 

// Minimum Border Size. I recommend to use two/four/six... times of your line width setting of your slicer. Simplify3D uses 0.48mm line width by default if you are using a 0.4mm nozzle. Cura uses 0.4mm line width.
fan_min_border_size_in_mm = 1.92;

// Size of the pattern lines. I recommend to use two/four/six... times of your line width setting of your slicer. Simplify3D uses 0.48mm line width by default if you are using a 0.4mm nozzle. Cura uses 0.4mm line width.
fan_line_size_in_mm = 3.0; //[1.5:0.1:3.5]

// Space between two lines of the inner pattern.
fan_line_space_in_mm = 2.8; //[1.8:0.1:50]

// number of straight lines supporting the crosshair pattern.
number_of_support_lines = 4;  //[1:1:36]

/* [STL element to export] */
// - Top shell
TShell = 1; // [0:No, 1:Yes]
// - Bottom shell
BShell = 1; // [0:No, 1:Yes]
// - Front panel
FPanL = 1; // [0:No, 1:Yes]
// - Back panel
BPanL = 1; // [0:No, 1:Yes]
// - Panel holes and text
PanelFeatures = 1; // [0:No, 1:Yes]
//- Small Parts for 3D-Print, when choosen (PCB-Spacer)
SmallParts = 0;  // [0:No, 1:Yes]


/* [Special Values] */
// - Show Explanations
ShowExplanations = 0; // [0:No, 1:Yes]

// - Debug Output */
// - enable Debug output for more Info
Debug = 0; // [0:No, 1:Yes]


// *************** from here you dont need to change values *********************************
/* [Hidden] */
// - Shell color
Couleur1 = "Orange";
// - Panel color
Couleur2 = "OrangeRed";
// - Text color
TextColor = "White";
//
eps = 1/128; //small fudge factor to stop CSG barfing on coincident faces.
// - making decorations thicker if it is a vent to make sure they go through shell

// Add a small number to Thick in case Filet is 0.
Dec_Thick = Vent ? Thick*1.001 + Filet : Thick/2;
// Separate vents with a square pillar by default.
Dec_Spacing = Thick + Vent_width;
// X offset to center of first vent
Dec_Offset = Thick*2 + PanelThick + PanelThickGap*2 + Dec_Spacing - Vent_width/2;
//    [type, fan_size, screw_distancefan_size]
aFanSize_screw_distance=[[0,25,20],[1,30,24],[2,40,32],[3,50,40],[4,60,50],[5,70,61.5],[6,80,71.5],[7,92,82.5],[8,120,105],[9,140,126]];

// vars for fan guard
fan_min_border_size = fan_min_border_size_in_mm;
fan_line_size = fan_line_size_in_mm;
fan_line_space = fan_line_space_in_mm;
fan_size = fan_size_in_mm;
screw_hole_dia = screw_hole_diameter_in_mm;

//25mm fan: 20 | 30mm fan: 24 | 40mm fan: 32 | 50mm fan: 40 | 60mm fan: 50 | 70mm fan: 61.5 | 80mm fan: 71.5 | 92mm fan: 82.5 | 120mm fan: 105 | 140mm fan: 126 
// search screw_distance to according fan-size from array "aFanSize_screw_distance"
aPos= select(aFanSize_screw_distance,search(fan_size, aFanSize_screw_distance,num_returns_per_match=0,index_col_num=1));
screw_hole_distance = aPos[0][2];
fan_type =aPos[0][0];
if (Debug){echo("FAN:", screw_hole_distance=aPos[0][2], fan_type=fan_type);}

// vars for array "PCB-feet", number of offset for spacers, pillars and inserts
// adjust these values when changing Myxxxx.Scad-files
pcb_insert_offset = 3;
pcb_pillar_offset = 8;
pcb_spacer_offset = 14;
// offset of var tab_insert for tabs
tab_insert_offset = 2;

// some simplifications of vars used in the modules
// outer / inner diameter of choosen insert for PCBFeet (only valid if PCBFeet used with inserts) + add. margin
pcbFeet_outer_diam = inserts[PCBFeet - pcb_insert_offset][2];
pcbFeet_inner_diam = inserts[PCBFeet - pcb_insert_offset][4];
pcbFeet_height = inserts[PCBFeet - pcb_insert_offset][1];
// dim. for values of inserts
tab_hole = inserts[tab_inserts - tab_insert_offset][3];  // hole in tab=hole-diam of insert
tab_thick = inserts[tab_inserts - tab_insert_offset][1]; // thick of tab = lenght of insert
tab_box_hole = inserts[tab_inserts - tab_insert_offset][4];  // outer hole = screw-diam of insert
// some dim. of PCB-Spacers
pcb_spacer_height = tubings[PCBFeet - pcb_spacer_offset][5];  // length of pcb-spacer --> height for pcb
pcb_spacer_innerDiam = tubings[PCBFeet - pcb_spacer_offset][3];  // diam. inner hole of pcb-spacer
// pcb-pillars as pcb-feet
pcb_pillar_height = pillars[PCBFeet - pcb_pillar_offset][3];  // length of pillar w.o.outer thread --> height for pcb-foot

if(Debug) echo("inserts dimensions w.o margins:",pcbFeet_outer_diam = pcbFeet_outer_diam, pcbFeet_inner_diam = pcbFeet_inner_diam, pcbFeet_height = pcbFeet_height);

//additional diameter for hole-diameter of PCBFeet with inserts
AddMargin = 3.0;

// Resolution based on Round parameter. Set this first number to something
// smaller to speed up processing. It should always be a multiple of 4.
Resolution = Round ? 100: 4;

/* Calculate box dimensions from PCB. If you want a more box-centric design
   where the outer diameter of the box matters more than the margins around
   the PCB you can set these manually. The PCB will still be placed according
   to the left and back margins, and if you want to use the screwless box
   design, you will need to set the TopMargin to
   (Height - Thick*2 - FootHeight - PCBThick)
*/

Length = PCBLength + FrontEdgeMargin + BackEdgeMargin + ((Thick + PanelThick + PanelThickGap*2)*2);
Width = PCBWidth + LeftEdgeMargin + RightEdgeMargin + Thick*2;
Height = FootHeight + PCBThick + TopMargin + Thick*2;

echo("Case-Feet choosen:",CaseFeet);
echo("PCBFeet choosen:",PCBFeet);
echo("Inserts for tab-holes:",tab_inserts);   // for tab-holes using inserts
echo("------------------------------------------------------------------------------");
echo("Box: ", Length=Length, Width=Width, Height=Height);

if (ShowExplanations) echoPCBFeetDescr();

// part of X-position inset of mounting holes and tabs
MountInset = Thick*3 + PanelThick + PanelThickGap*2;     // correct ScrewHole-size added in the modules
// Ref. Position between RelayHolder Holes and Relayholder
RelayHolder_LHoleX=aBP_Holes[6][1];
RelayHolder_HoleY= aBP_Holes[6][2];

// Calculate panel dimensions from box dimensions.
PanelWidth = Width - Thick*2 - PanelHorizontalGap*2;
PanelHeight = Height - Thick*2 - PanelVerticalGap*2;

// definition of case rubber-foot (when choosen "rubber-feet" for case feet)
CaseFoot = Foot(d = 15, h = 8, t = 3, r = 1, screw = M3_dome_screw);

// General margins from case edges to Foot-holes, use in mod. "DrawCaseFeet", "CaseFeetHoles" and in "myComponents.scad" 
GeneralMarginX = 2*Thick + PanelThick + PanelThickGap*2 + CaseFeetHole;  // General X-margin from case edges to Foot-holes
GeneralMarginY = Thick + CaseFeetHole;                                   // General Y-margin from case edges to Foot-holes



/*  Panel Manager

    Use the below 4 modules to produce holes and text on the front and back
    panels. The holes modules should contain instances of SquareHole or
    CylinderHole defined later in this file. The text modules should contain
    instances of LText or CText defined later in this file. It is
    recommended to use variables that you define for your needs to create
    the size and positions of these objects.
*/

// Calculate board-relative positions with respect to the panel, for
// convenience in placing panel elements.
TopOfBoardWRTPanel = FootHeight + PCBThick - PanelVerticalGap;
LeftEdgeOfBoardWRTFPanel = LeftEdgeMargin - PanelHorizontalGap;
LeftEdgeOfBoardWRTBPanel = RightEdgeMargin - PanelHorizontalGap;
// Visible panel edges
PanelBottomEdge = Thick - PanelVerticalGap;
PanelTopEdge = PanelHeight - Thick + PanelVerticalGap;
PanelLeftEdge = Thick - PanelHorizontalGap;
PanelRightEdge = PanelWidth - Thick + PanelHorizontalGap;

echo("PCB-hole distances:",Foot1_Foot2=PCBWidth-Foot1Y-Foot2YFromEdge,
                          Foot1_Foot3=PCBLength-Foot1X-Foot3XFromEdge,
                          Foot2_Foot4=PCBLength-Foot2X-Foot4XFromEdge,
                          Foot3_Foot4=PCBWidth-Foot3Y-Foot4YFromEdge);    

echo("--------------------------------------------------------------------------------");


// Holes for front panel
module FPanelHoles() {
     // Square-Holes
   for (FP_SHole = aFP_SHoles) {
        //           On/Off,       xPos,      yPos,       Width,     Hight,      Filet
        SquareHole(FP_SHole[0],FP_SHole[1],FP_SHole[2],FP_SHole[3],FP_SHole[4],FP_SHole[5]);
   }
      // round holes
   for (FP_Hole = aFP_Holes) {
        //            On/Off,      xPos,     yPos,     Diameter1
        //CylinderHole(FP_Hole[0],FP_Hole[1],FP_Hole[2],FP_Hole[3]);  
        CylinderHole(FP_Hole[0],FP_Hole[1]+Thick,FP_Hole[2]+Thick,FP_Hole[3]);
     }
}

module FPanelHolesRecess() {
    // Square-holes with recess for Frontpanel
    for (FP_SHoleRecess = aFP_SHolesRecess) {
        SquareHoleRecess(FP_SHoleRecess[0], FP_SHoleRecess[1],FP_SHoleRecess[2],FP_SHoleRecess[3],FP_SHoleRecess[4],FP_SHoleRecess[5],FP_SHoleRecess[6],FP_SHoleRecess[7]);
    }
}

// Text for front panel
module FPanelText() {
   // flat Text frontpanel
   for (FP_SText = aFP_STexts) {
      for (i=[1:len(FP_SText)-1]) {
         //     On/Off,      Xpos,        Ypos,       "Font",      Size,       "Text",   "HAlign","VAlign"
         LText(FP_SText[0], FP_SText[1], FP_SText[2], sTextFont, FP_SText[3], FP_SText[4], HAlign="left");
      }
   }
   // round text frontpanel
   for (FP_RText = aFP_RTexts) {
      for (i=[1:len(FP_RText)-1]) {
         //     On/Off,      Xpos,        Ypos,       "Font",      Size,       Diameter,   Arc(deg),    St.Angle(deg),  "Text"
         CText(FP_RText[0], FP_RText[1], FP_RText[2], sTextFont, FP_RText[3], FP_RText[4], FP_RText[5], FP_RText[6], FP_RText[7] );
      }
   }
}


// Holes for back panel and fan
module BPanelHoles() {
   
   for (BP_SHole = aBP_SHoles) {
         //             On/Off,       xPos,                              yPos,                         width,      height,       filet
        //SquareHole(BP_SHole[0], BP_SHole[1]+LeftEdgeOfBoardWRTBPanel, BP_SHole[2]+TopOfBoardWRTPanel, BP_SHole[3], BP_SHole[4], BP_SHole[5]);
      SquareHole(BP_SHole[0], BP_SHole[1], BP_SHole[2], BP_SHole[3], BP_SHole[4], BP_SHole[5]);
   }
   
   for (BP_Hole = aBP_Holes) {
       //            OnOff,         xPos,                             yPos,                          diameter1
       //CylinderHole(BP_Hole[0], BP_Hole[1]+LeftEdgeOfBoardWRTBPanel, BP_Hole[2]+TopOfBoardWRTPanel, BP_Hole[3]+PartMargin*2);
      CylinderHole(BP_Hole[0], BP_Hole[1]+Thick, BP_Hole[2]+Thick, BP_Hole[3]);
   }
   
      if (BP_fan_position[0]==1)
     //             xPos, yPos, fan_size, screw_hole_dia, screw_hole_distance
     fan_cover_inv(BP_fan_position[1], BP_fan_position[2], fan_size, screw_hole_dia, screw_hole_distance);
}
      
module BPanelHolesRecess() {
    // Square-holes with recess for Backpanel
    for (BP_SHoleRecess = aBP_SHolesRecess) {
         SquareHoleRecess(BP_SHoleRecess[0], BP_SHoleRecess[1],BP_SHoleRecess[2],BP_SHoleRecess[3],BP_SHoleRecess[4],BP_SHoleRecess[5],BP_SHoleRecess[6],BP_SHoleRecess[7]);
    }
}



// Text for back panel
module BPanelText() {
   
   // flat Text Backpanel
   for (BP_SText = aBP_STexts) {
         //     OnOff,    xpos,        ypos,          Font,     text,     HAlign / VAlign
      LText(BP_SText[0], BP_SText[1], BP_SText[2], sTextFont, BP_SText[3], BP_SText[4]);
      //LText(BP_SText[0], BP_SText[1]+LeftEdgeOfBoardWRTBPanel, BP_SText[2]+TopOfBoardWRTPanel, sTextFont, BP_SText[3], BP_SText[4]);
   }
   // round text Backpanel
   for (BP_RText = aBP_RTexts) {
               //     On/Off,      Xpos,        Ypos,       "Font",      Size,       Diameter,   Arc(deg),    St.Angle(deg),  "Text"
         CText(BP_RText[0], BP_RText[1], BP_RText[2], sTextFont, BP_RText[3], BP_RText[4], BP_RText[5], BP_RText[6], BP_RText[7] );
   }
}


// ------- You probably don't need to modify anything below this line. --------


/* Generic rounded box

    Produces a box of the specified dimensions. Corners are rounded
    according to Filet and Resolution parameters.
    
    Arguments:
    xshrink: the amount to reduce the length on one end compared to the full
        length
    yzshrink: the amount to reduce the width or height on one edge compared
        to the full box  
*/
module RoundBox(xshrink=0, yzshrink=0) {
    Filet = (Filet > Thick*2) ? Filet - yzshrink : Filet;
    translate([xshrink, yzshrink, yzshrink]) {
        rotate([90, 0, 90]) {
            linear_extrude(height=Length - xshrink*2) {
                translate([Filet, Filet, 0]) {
                    offset(r=Filet, $fn=Resolution) {
                        square([Width - 2*yzshrink - 2*Filet, Height - 2*yzshrink - 2*Filet]);
                    }
                }
            }
        }
    }
}


/*  MainBox: Main box module

    This module produces the simple main box half. No feet, tabs, vents or
    fixation is applied here.
*/
module MainBox() {
    difference() {
        union() {
            // Makes a hollow box with walls of Thick thickness.
            difference() {
                RoundBox();
                RoundBox(xshrink=Thick, yzshrink=Thick);
            }
            // Makes interior backing for panel as a wall
            difference() {
                RoundBox(xshrink=(Thick + PanelThick + PanelThickGap*2), yzshrink=Thick/2);
                RoundBox(xshrink=(Thick*2 + PanelThick + PanelThickGap*2));
            }
        } // end union
        // Remove the top half
        translate([-Thick, -Thick, Height/2]) {
            cube([Length + Thick*2, Width + Thick*2, Height]);
        }
        // Remove the center for panel visibility.
        RoundBox(xshrink=-Thick, yzshrink=Thick*2);
     
        if ((Thick >= 2.5)&&(bar_recess)) {   // Recess ony when Wallthicknes >= 2.5, and enabled in customizer
           // Recess in upper edge of the bottom-shell right/ top-shell left ,Thick of the bar 2.0mm, 0.3 gap added
           translate([Length/2, Width -(Thick/2+0.35/2)+ CutoutMargin/2 , Height/2- (2.0 +CutoutMargin)/2 ]) { // -(recess+gap)/2
             cube([0.45*Length, Thick*0.35+CutoutMargin+0.2, 2.0+CutoutMargin+0.2], center=true);
           }
        } // end if Thick
    } // end difference
   
    if ((Thick >= 2.5)&&(bar_recess)) {   // bar on upper edge only when Wallthicknes >= 2.5,and enabled in customizer
      // top bridge at bottom-shell left side, a little bit smaller than the recess (-3)
       translate([Length/2, Thick/2, Height/2+ 2.0/2]) {  // middle of bar left side: Thick/2
          cube([0.45*Length -3, Thick*0.35 , 2.0], center=true);   // Thickness of the bar: Thick*0.35, 2mm high
       }
    } // end if Thick
}


/*  decoration: a single box decoration
*/
module decoration() {
    translate([-Vent_width/2, -Thick, -Thick]) {
        cube([Vent_width, Dec_Thick + Thick, Height/4 + Thick]);
    }
}


/* LeftDecorations: left decorations module

    Produces the decorations/vents for just the left side of the box.
    These can be rotated and translated for the right side.
*/
module LeftDecorations() {
    for (i=[0 : Dec_Spacing : Length/4]) {
        translate([Dec_Offset + i, 0, 0]) {
            decoration();
        }
        translate([Length - Dec_Offset - i, 0, 0]) {
            decoration();
        }
    }
}


/*  Decorations: decorations module

    This module produces the box vents or decorations for the right side by mirroring left side.
*/
module Decorations() {
    LeftDecorations();
    // Mirror for the right side decorations
    translate([0, Width, 0]) {
        mirror([0, 1, 0]) {
            LeftDecorations();
        }
    }
}


/*  Coque: Shell module

    This module takes no arguments, but produces a box shell. This is half
    the box, including slots for end panels, rounded corners according to
    Filet and Resolution, and vents/decorations according to parameters.
*/
module Coque() {
    color(Couleur1) {
        difference() {
            MainBox();
            if (Decorations) {
                Decorations();
            }
        }
    }
}


/*  tab: tab module

    Produces a single box fixation tab with screw hole or snap button
*/
module tab(ScrewHole, TabThick) {
    translate([0, Thick, Height/2]) {
        rotate([90, 0, 180]) {
            difference() {
                linear_extrude(TabThick) {
                    difference() {
                        //circle(r=4*ScrewHole, $fn=6);    // generate tab as hexagon
                        circle(r=3.8*ScrewHole, $fn=6);    // generate slightly smaller tab as hexagon
                        if (Debug) echo("----------------------");
                        if (Debug)echo("sub tab: ScrewHole from circle:",ScrewHole);
                        if (!SnapTabs) {
                            if (Debug)echo("sub tab: translate:",0,ScrewHole*2,0);
                            translate([0, ScrewHole*2, 0]) {
                                circle(d=ScrewHole, $fn=100);     // hole in tab when not SnapTabs choosen
                            }
                        }
                    }
                }
                translate([-4*ScrewHole, -ScrewHole, TabThick]) {
                    rotate([90+45, 0, 0]) {
                        cube([8*ScrewHole, 3*ScrewHole, 5*ScrewHole]);  // substr. cube with rotate-angle from tab-bottom
                    }
                }
                translate([-4*ScrewHole, 0, -PartMargin]) {
                    cube([8*ScrewHole,4*ScrewHole,PartMargin*2]);  // back of the tab, outer-side direction
                }
            }  // end of difference
            // ****** draw insert for tab ***** 
            if((tab_inserts > 1)&&($preview)) {    // draw inserts if choosen, only in peview
                translate([0, ScrewHole*2, 0]){
                     rotate([0, 180, 0]) 
                     let($show_threads = true)
                     insert(inserts[tab_inserts - tab_insert_offset]);
                   
               }
            }
            // *******  

            if (SnapTabs) {
                translate([0, ScrewHole*2, PartMargin]) {
                    difference() {
                        sphere(d=(ScrewHole - PartMargin*2), $fn=100);
                        translate([0, 0, ScrewHole*.5 + TabThick/2]) {
                            cube(ScrewHole, center=true);
                        }
                    }
                }
            } // end of SnapTabs
        }  // end of rotate
    } // end of main-translate
}


/*  Tabs: tabs module

    This module produces the wall fixation box tabs.
    Tabs are produced according to the parameters for XXTab indicating top
    or bottom.

    Arguments:
        top: 0 for bottom shell tabs. 1 for top shell tabs. defaults to bottom.
*/
//module Tabs(top=0) {
module Tabs(top=0, tab_hole, tab_thick) {
   if (Debug) echo("sub Tabs before: tabs:",tab_hole=tab_hole, tab_thick=tab_thick);
   if (Debug) echo();
   ScrewHole=tab_hole;
   TabThick=tab_thick;
   if (Debug) echo("sub Tabs after: tabs:",ScrewHole=ScrewHole, TabThick=TabThick);
    color(Couleur1) {
        if (BLTab == top) { //tab back-left
            translate([MountInset + ScrewHole*4, 0, 0]) {  // MountInset=Thick*3+PanelThick+PanelThickGap*2+ScrewHole*4 --> X-position of mounting holes and tabs
                tab(ScrewHole, TabThick);
            }
        }
        if (FLTab == top) {    //tab front-left
            translate([Length - (MountInset + ScrewHole*4), 0, 0]) {
                tab(ScrewHole, TabThick);
            }
        }
        if (BRTab == top) {   //tab back-right
            translate([MountInset + ScrewHole*4, Width, 0]) {
                rotate([0, 0, 180]) {
                    tab(ScrewHole, TabThick);
                }
            }
        }
        if (FRTab == top) {  //tab front-right
            translate([Length - (MountInset + ScrewHole*4), Width, 0]) {
                rotate([0, 0, 180]) {
                    tab(ScrewHole, TabThick);
                }
            }
        }
    } // end of color
}


/*  hole: hole module for outerpart hole of the box

    Produces a box hole for fixation. This is either a cylinder for a screw
    or a semispherical indention for snap tabs.
*/
module hole(BoxHole, ScrewHole) {
    if (Debug) echo("sub hole: ",BoxHole=BoxHole, ScrewHole=ScrewHole, SnapTabs=SnapTabs);
    if (SnapTabs) {
        translate([0, -Thick, Height/2 - 2*ScrewHole]) {
            sphere(d=ScrewHole, $fn=100);       // Sphere in the box-part when using snaptabs
        }
    }
    else {
        translate([0, Thick, Height/2 - 2*ScrewHole]) {
            rotate([90, 0, 0]) {
               cylinder(Thick*3, d=BoxHole, $fn=100);      // hole in the box-part for tabs
            }
        }
    } // end SnapTabs
}


/*  Holes: holes module for box-holes of fixation tab (not the holes of the tabs)

    This module produces the holes necessary in the box fixation tabs and in
    the wall of the box for the corresponding tabs to affix to. Holes are
    produced according to the parameters for XXTab indicating top or bottom.

    Arguments:
        top: 0 for bottom shell holes. 1 for top shell holes. defaults to
            bottom.
*/
module Holes(top=0,tab_box_hole,tab_hole) {
   if (Debug) echo("sub Holes before:", tab_box_hole=tab_box_hole, tab_hole=tab_hole);
   BoxHole=tab_box_hole;
   ScrewHole= tab_hole;
   if (Debug) echo("sub Holes after:", BoxHole=BoxHole, ScrewHole=ScrewHole);
      
    color(Couleur1) {
        if (BRTab != top) {
            translate([MountInset + ScrewHole*4, Width, 0]) {
                hole(BoxHole,ScrewHole);
            }
        }
        if (FRTab != top) {
            translate([Length - (MountInset + ScrewHole*4), Width, 0]) {
                hole(BoxHole,ScrewHole);
            }
        }
        if (BLTab != top) {
            translate([MountInset + ScrewHole*4, 0, 0]) {
                rotate([0, 0, 180]) {
                    hole(BoxHole,ScrewHole);
                }
            }
        }
        if (FLTab != top) {
            translate([Length - (MountInset + ScrewHole*4), 0, 0]) {
                rotate([0, 0, 180]) {
                    hole(BoxHole,ScrewHole);
                }
            }
        }
    } // end of color
}

/*  PCB: PCB module

    Produces the model of the PCB using parameters for its size and thickness.
    The text PCB is placed on top of the board. This is called by the Feet()
    module with the % modifier which makes this module translucent and only
    viewed in preview mode.
*/
module PCB(FootHeight) {   // added footheight in dependency of kind of feet
    translate([0, 0, FootHeight]) {
        cube([PCBLength, PCBWidth, PCBThick]);
        translate([PCBLength/2, PCBWidth/2, PCBThick]) {
            color("Olive") {
                linear_extrude(height=FontThick) {
                    text(TextOnPCB, font="Arial black", halign="center", valign="center",size=5.5);
                }
            }
        }
    }
}


/*  foot module

    Produces a single foot for PCB mounting.
*/

module foot(top=0, inner_diam, outer_diam, foot_height) {
    if (Debug) echo("sub foot params:", inner_diam=inner_diam, outer_diam=outer_diam, foot_height=foot_height);
    FootHole = inner_diam;  // must be set on top, because in the if clause the var is gone
    FootDia = outer_diam;
    FootHeight = foot_height;
    color(Couleur1) {
        rotate_extrude($fn=100) {
            difference() {
                union() {
                    if (Screwless && top) { // Foot with TopMargin height
                        square([FootDia/2 + FootFilet, TopMargin]);
                    }
                    else if (Screwless && !top) { // Foot for PCB peg
                        square([FootDia/2 + FootFilet, FootHeight + PCBThick*2]);
                    }
                    else if (!Screwless && !top) { // Foot with screwhole
                        translate([FootHole/2 + CutoutMargin, 0, 0]) {
                            square([(FootDia - FootHole)/2 - CutoutMargin + FootFilet, FootHeight]);
                        }
                    }
                }  // end of union
                translate([FootDia/2 + FootFilet, FootFilet, 0]) {
                    offset(r=FootFilet, $fn=Resolution) {
                        square(Height);
                    }
                }
                if (Screwless && !top) { // Remove around peg
                    translate([FootHole/2 - PartMargin, FootHeight]) {
                        polygon([[0, 0],
                                 [FootDia/2, 0],
                                 [FootDia/2, PCBThick*3],
                                 [-FootHole/3, PCBThick*3],
                                 [0, PCBThick]
                                ]
                        );
                    }
                }
                if (Screwless && top) { // Remove hole for peg
                    translate([-FootHole/2, TopMargin - PCBThick, 0]) {
                        polygon([[0, 0],
                                 [(FootHole*5/6 + CutoutMargin), 0],
                                 [(FootHole + CutoutMargin), PCBThick],
                                 [(FootHole + CutoutMargin), PCBThick*2],
                                 [0, PCBThick*2],
                                ]
                        );
                    }
                }

            }  // end of difference
        }  // end of rotate_extrude
    }  // end of color
}


/*  Feet module

    Combines four feet to form mounting platform for PCB.
    A model of the PCB is included with the background modifier. It is
    translucent but visible in the preview, but not in the final render.

    No arguments are used, but parameters provide the PCB and foot dimensions.

   Added some code for inserts 
*/

module Feet(top=0, inner_diam, outer_diam, foot_height) {
    if (Debug) echo("sub Feet params:", inner_diam=inner_diam, outer_diam=outer_diam, foot_height=foot_height);
    translate([BackEdgeMargin + Thick + PanelThick + PanelThickGap*2, LeftEdgeMargin + Thick, Thick]) {
        if (Screwless || !top ) {
            translate([Foot1X, Foot1Y]) {
                foot(top=top, inner_diam=inner_diam, outer_diam=outer_diam, foot_height=foot_height);
                if((PCBFeet >= pcb_insert_offset)&&(PCBFeet < pcb_pillar_offset)&&($preview)) {    // draw inserts, if choosen
                   translate([0,0,foot_height])
                   let($show_threads = true)
                   insert(inserts[PCBFeet-pcb_insert_offset]);
                }
            }
            translate([Foot2X, Foot2Y]) {
                foot(top=top, inner_diam=inner_diam, outer_diam=outer_diam, foot_height=foot_height);
                if((PCBFeet >= pcb_insert_offset)&&(PCBFeet <= pcb_pillar_offset)&&($preview)) {    // draw inserts
                   translate([0,0,foot_height])
                   let($show_threads = true)
                   insert(inserts[PCBFeet-pcb_insert_offset]);
                }
            }
            translate([Foot3X, Foot3Y]) {
                foot(top=top, inner_diam=inner_diam, outer_diam=outer_diam, foot_height=foot_height);
                if((PCBFeet >= pcb_insert_offset)&&(PCBFeet < pcb_pillar_offset)&&($preview)) {    // draw inserts
                   translate([0,0,foot_height])
                   let($show_threads = true)
                   insert(inserts[PCBFeet-pcb_insert_offset]);
                }
            }
            translate([Foot4X, Foot4Y]) {
                foot(top=top, inner_diam=inner_diam, outer_diam=outer_diam, foot_height=foot_height);
                if((PCBFeet >= pcb_insert_offset)&&(PCBFeet < pcb_pillar_offset)&&($preview)) {    // draw inserts
                   translate([0,0,foot_height])
                   let($show_threads = true)
                   insert(inserts[PCBFeet-pcb_insert_offset]);
                }
            }
        } // end of main if
    } // end if translate
}

// NEW ******************************** NEW ****

module DrawPCB(FootHeight) {  // separation of drawing the PCB from the PCBFeet, adapting Foot-height for various type of Feet
   if (PCBDraw) {
      translate([BackEdgeMargin + Thick + PanelThick + PanelThickGap*2, LeftEdgeMargin + Thick, Thick]) {
         %PCB(FootHeight);
      }
   }
  }

module PCBFeetHoles(diam) {    // create holes dependend of kind of PCB-holes
      if(Debug) echo("sub PCBFeetHoles: diam:",diam);
      if (Debug) echo("Mod. PCBFeetHoles: HoleDiam+CutoutMargin:",diam + CutoutMargin);
      if (Debug) echo();
      translate([BackEdgeMargin + Thick + PanelThick + PanelThickGap*2,
                 LeftEdgeMargin + Thick,
                 Thick]){
         translate([Foot1X, Foot1Y, -Thick -eps]) {
             cylinder(h=Thick*2,d=diam + CutoutMargin,$fn=30);
         }
         translate([Foot2X, Foot2Y, -Thick -eps]) {
             cylinder(h=Thick*2,d=diam + CutoutMargin,$fn=30);
        }
        translate([Foot3X, Foot3Y, -Thick -eps]) {
             cylinder(h=Thick*2,d=diam + CutoutMargin,$fn=30);
        }
        translate([Foot4X, Foot4Y, -Thick -eps]) {
             cylinder(h=Thick*2,d=diam + CutoutMargin,$fn=30);
        }
      }
}


module AdditionalHoles() {
    for (AddHoles = aAddHoles) {
      if (AddHoles[0]) {
         for (i=[1:len(AddHoles)-1]) {
            //                                        On-Off       Xpos,             Ypos,             diameter
            if(Debug) echo("sub AdditionalHole:", OnOff=OnOff, xPos=AddHoles[1], yPos=AddHoles[2], diam=AddHoles[3]);
            if(Debug) echo("Mod. AdditionalHole: HoleDiam+CutoutMargin:",AddHoles[3] + CutoutMargin);
            if(Debug) echo();
               translate([GeneralMarginX, GeneralMarginY, Thick]) {
  //           translate([BackEdgeMargin + Thick + PanelThick + PanelThickGap*2,
  //                     LeftEdgeMargin + Thick,
  //                     Thick]){
                  translate([AddHoles[1], AddHoles[2], -Thick -eps]) {
                     cylinder(h=Thick*2,d=AddHoles[3] + CutoutMargin,$fn=30);
                  }
               }
         }
    }  // end for i=..
  } // end for AddHoles..
   
}
 

module DrawCaseFeet() {
  if ($preview) {

      if (CaseFeet == 2) {   // 2:Rubber Feet
         translate([GeneralMarginX, GeneralMarginY, Thick]) {
            translate([BackCaseFeetMargin, LeftCaseFeetMargin, -Thick -eps]) {
               foot_assembly(Thick, CaseFoot);          // Case-foot1 back-left
            }
            translate([BackCaseFeetMargin, Width-2*GeneralMarginY-RightCaseFeetMargin, -Thick -eps]) {
               foot_assembly(Thick, CaseFoot);         // Case-foot2 back-right
            }
            translate([Length-2*GeneralMarginX-FrontCaseFeetMargin, LeftCaseFeetMargin, -Thick -eps]) {
               foot_assembly(Thick, CaseFoot);         // Case-foot3 front-left
            }
            translate([Length-2*GeneralMarginX-FrontCaseFeetMargin, Width-2*GeneralMarginY-RightCaseFeetMargin, -Thick -eps]) {
               foot_assembly(Thick, CaseFoot);         // Case-foot4 front-right
            }        
         } //end main translate
      }  // end if caseFeet=2
   
      if (CaseFeet == 3) {    // 3:Folding Feet
        translate([GeneralMarginX, GeneralMarginY, Thick]) {
            translate([BackCaseFeetMargin-4, LeftCaseFeetMargin-7, -Thick -eps]) {
               rotate([0,180,180]) {
                  color("LightGrey") {
                    import("../stls/FoldingFoot-base.stl", convexity=3);   // back-left
                  }
               }
            }
            translate([BackCaseFeetMargin-4, Width-2*GeneralMarginY-RightCaseFeetMargin-7, -Thick -eps])  {
               rotate([0,180,180]) {
                  color("LightGrey") {
                    import("../stls/FoldingFoot-base.stl", convexity=3);   // back-right
                  }
               }
            }
               
            translate([Length-2*GeneralMarginX-FrontCaseFeetMargin+4, LeftCaseFeetMargin+7, -Thick -eps]) {
               rotate([0,180,0]) {
                    color("LightGrey") {
                     import("../stls/FoldingFoot-base.stl", convexity=3);   // front-left
                        translate([-1,-25,-18]) {
                           rotate([0,-103,0]) {
                              color("LightGrey") {
                                 import("../stls/FoldingFoot-arm.stl", convexity=3);
                              }
                           }
                        }
                     }
                  }
            }
            translate([Length-2*GeneralMarginX-FrontCaseFeetMargin+4, Width-2*GeneralMarginY-RightCaseFeetMargin+7, -Thick -eps]) {
               rotate([0,180,0]) {
                    color("LightGrey") {
                      import("../stls/FoldingFoot-base.stl", convexity=3);   // front-right
                        translate([-1,-25,-18]) {
                           rotate([0,-103,0]) {
                              color("LightGrey") {
                                 import("../stls/FoldingFoot-arm.stl", convexity=3);
                              }
                           }
                        }
                  }
               }
            }
         } //end main translate
       }  // end if CaseFeet=3

      if (CaseFeet == 4) {    // 4: small Folding Feet
        translate([GeneralMarginX, GeneralMarginY, Thick]) {  // main translate for all objects

            translate([BackCaseFeetMargin-4, LeftCaseFeetMargin-7, -Thick -eps]) {
               rotate([0,180,180]) {
                  color("LightGrey") {
                    import("../stls/FoldingFoot-base-small.stl", convexity=3);   // back-left
                  }
               }
            }
            translate([BackCaseFeetMargin-4, Width-2*GeneralMarginY-RightCaseFeetMargin-7, -Thick -eps])  {
               rotate([0,180,180]) {
                  color("LightGrey") {
                    import("../stls/FoldingFoot-base-small.stl", convexity=3);   // back-right
                  }
               }
            }
            translate([Length-2*GeneralMarginX-FrontCaseFeetMargin+4, LeftCaseFeetMargin+7, -Thick -eps]) {
               rotate([0,180,0]) {
                  color("LightGrey") {
                    import("../stls/FoldingFoot-base-small.stl", convexity=3);   // front-left
                    translate([5,-20,-18]) {
                       rotate([0,-103,0]) {
                           import("../stls/FoldingFoot-arm-small.stl", convexity=3);
                       }
                    }
                  }
               }
            }
            translate([Length-2*GeneralMarginX-FrontCaseFeetMargin+4, Width-2*GeneralMarginY-RightCaseFeetMargin+7, -Thick -eps]) {
               rotate([0,180,0]) {
                  color("LightGrey") {
                    import("../stls/FoldingFoot-base-small.stl", convexity=3);   // front-right
                    translate([5,-20,-18]) {
                       rotate([0,-103,0]) {
                           import("../stls/FoldingFoot-arm-small.stl", convexity=3);
                       }
                    }
                  } // end color
               } // end rotate
            } // end translate
            
        } //end main-translate
      }  // endif CaseFeet=4
  
    } // endif preview
   
}

module CaseFeetHoles() {    // Holes for Case-Feet

   translate([GeneralMarginX, GeneralMarginY, Thick]) {
        translate([BackCaseFeetMargin, LeftCaseFeetMargin, -Thick -eps]) {
            cylinder(h=Thick*2,d=CaseFeetHole + CutoutMargin,$fn=30);            // Case-foot1 back-left
        }
         translate([BackCaseFeetMargin, Width-2*GeneralMarginY-RightCaseFeetMargin, -Thick -eps]) {
            cylinder(h=Thick*2,d=CaseFeetHole + CutoutMargin,$fn=30);            // Case-foot2 back-right
        }
        translate([Length-2*GeneralMarginX-FrontCaseFeetMargin, LeftCaseFeetMargin, -Thick -eps]) {
            cylinder(h=Thick*2,d=CaseFeetHole + CutoutMargin,$fn=30);           // Case-foot3 front-left
        }
        translate([Length-2*GeneralMarginX-FrontCaseFeetMargin, Width-2*GeneralMarginY-RightCaseFeetMargin, -Thick -eps]) {
            cylinder(h=Thick*2,d=CaseFeetHole + CutoutMargin,$fn=30);           // Case-foot4 back-right
        }
   }
    
}

module DrawPCB_Pillars() {
  if($preview)
      translate([BackEdgeMargin + Thick + PanelThick + PanelThickGap*2, LeftEdgeMargin + Thick, Thick]){
        let($show_threads = true)
        translate([Foot1X, Foot1Y, 0]) {
              pillar(pillars[PCBFeet-pcb_pillar_offset]);
        }
        let($show_threads = true)
        translate([Foot2X, Foot2Y, 0]) {
               pillar(pillars[PCBFeet-pcb_pillar_offset]);
        }
        let($show_threads = true)
        translate([Foot3X, Foot3Y, 0]) {
               pillar(pillars[PCBFeet-pcb_pillar_offset]);
        }
        let($show_threads = true)
        translate([Foot4X, Foot4Y, 0]) {
               pillar(pillars[PCBFeet-pcb_pillar_offset]);
        }
        
    } // main translate
}

module DrawPCB_Spacers() {
   
  if(Debug) echo("sub DrawPCB_Spacers: PCBFeet-pcb_spacer_offset:",PCBFeet-pcb_spacer_offset);
  if(Debug) echo("sub DrawPCB_Spacers: height:", Thick + pcb_spacer_height/2);
   if(($preview)  || (SmallParts)) {
      translate([BackEdgeMargin + Thick + PanelThick + PanelThickGap*2, LeftEdgeMargin + Thick, Thick]){
         translate([Foot1X, Foot1Y, pcb_spacer_height/2]) {
            tubing_ext(tubings[PCBFeet-pcb_spacer_offset]);
         }
         translate([Foot2X, Foot2Y, pcb_spacer_height/2]) {
            tubing_ext(tubings[PCBFeet-pcb_spacer_offset]);
         }
         translate([Foot3X, Foot3Y, pcb_spacer_height/2]) {
            tubing_ext(tubings[PCBFeet-pcb_spacer_offset]);
         }
         translate([Foot4X, Foot4Y, pcb_spacer_height/2]) {
            tubing_ext(tubings[PCBFeet-pcb_spacer_offset]);
        }
      } // end translate
   } // endif $preview

}

//*********************************************

/*  TopShell: top shell module

    Produces the top shell, including requested fixation tabs and holes
    Model is rotated and translated to the appropriate position.
*/
module TopShell() {
    translate([0, 0, Height + 0.2]) {
        mirror([0, 0, 1]) {
            difference() {
                union() {
                    Coque();
                    //Handling of fixation tabs
                    if (tab_inserts<=1) { // default case, using screws (0) and EXPERIMENTAL case of snap-tabs (1)
                        Tabs(top=1, tab_hole=ScrewHole, tab_thick=TabThick);
                    }
                    if (tab_inserts >=1) {
                        Tabs(top=1, tab_hole=tab_hole-CutoutMargin, tab_thick=tab_thick+0.5); // tab_thick=length of insert+margin
                    }
                     // EXPERIMENTAL screwless
                    if (Screwless && PCBFeet==1) {    // "1"=with integr. Feet
                       Feet(top=1,inner_diam=FootHole, outer_diam=FootDia, foot_height=FootHeight);
                    }
                } //end of union
                
                // Handling of PCBFeet
                if (tab_inserts<=1) {
                    if(Debug) echo("sub TopShell: box_hole tab_insert<=1:",BoxHole);
                    Holes(top=1, tab_box_hole=BoxHole, tab_hole=ScrewHole); // def. using screws:(0), EXPERIMENTAL snap-tabs:(1)
                }
                if (tab_inserts >1) {
                    if(Debug) echo("sub TopShell: tab_box_hole tab_insert>1:",tab_box_hole +CutoutMargin);
                    Holes(top=1, tab_box_hole = tab_box_hole +CutoutMargin, tab_hole=tab_hole);   // overwrite hole-values with screw-diam. of choosen insert
                } 
          } // end of difference
      } // end of mirror
   } // end of translate
}


/*  BottomShell: bottom shell module

    Produces the bottom shell, including requested fixation tabs, holes,
    and various sorts of PCB-feet.
*/
module BottomShell() {
   if(Debug) echo("Debug sub BottomShell:",PCBFeet=PCBFeet, FootHole=FootHole, pcb_spacer_offset=pcb_spacer_offset, tubings_PCBFeet=tubings[PCBFeet-pcb_spacer_offset][3]);
  
    difference() {
        union() {
            Coque();
           //Handling of fixation-tabs
            if (tab_inserts <=1) { // default case using screws (0), EXPERIMENTAL case of snap-tabs is (1)
               Tabs(tab_hole=ScrewHole, tab_thick=TabThick); // def. values of customizer
            }
            if (tab_inserts >1) {
               if(Debug) echo("sub BottomShell tab:",tab_hole=tab_hole, tab_thick=tab_thick);
               Tabs(tab_hole=tab_hole, tab_thick=tab_thick+0.5); // tab_thick= length of insert+ add. margin
            }
            
            //handling of PCB-Feet
            if (PCBFeet >= pcb_pillar_offset && PCBFeet < pcb_spacer_offset) {  // Pillars as PCBFeet
               DrawPCB_Pillars();
               DrawPCB(FootHeight = pcb_pillar_height);
            } 
            if (PCBFeet >= pcb_spacer_offset) {                             // Spacers as PCBFeet
               DrawPCB_Spacers();
               DrawPCB(FootHeight = pcb_spacer_height);
            }
            if (PCBFeet==1) {
               Feet(top=0, inner_diam=FootHole, outer_diam=FootDia, foot_height=FootHeight);      // integrated PCBFeet
               DrawPCB(FootHeight);
            }
            if ((PCBFeet >= pcb_insert_offset) && (PCBFeet < pcb_pillar_offset)) {  // PCBFeet w.Inserts, for adapting hole diameter
               Feet(top=0, inner_diam=pcbFeet_inner_diam + CutoutMargin, outer_diam=pcbFeet_outer_diam + AddMargin, foot_height=pcbFeet_height);     // overwrite diam. with diam. of insert + add. margin
               DrawPCB(FootHeight);
            }

        } // end union
        //handling of Box-Holes for tabs, depends on choosen tab-inserts, diameter and tab-thick must be treated differently
        if (tab_inserts<=1) {
           if(Debug) echo("sub BottomShell: tab_box_hole tab_insert <=1:",BoxHole);
           Holes(tab_box_hole=BoxHole, tab_hole=ScrewHole);       // def. using screws (0) and EXPERIMENTAL snap-tabs (1)
        }
        if (tab_inserts >1) {
           if(Debug) echo("sub BottomShell: tab_box_hole tab_insert >1:",tab_box_hole);
           Holes(tab_box_hole = tab_box_hole, tab_hole=tab_hole);   // overwriting BoxHole with screw-diam. of choosen insert
        }

        // Handling of PCBFeet
        //don't draw Holes for "0:no Holes" and "1:with Feet" and feet w.inserts
        if (PCBFeet==2) {    // only Holes, no PCB-Feet, diam. from FootHole
            PCBFeetHoles(diam = FootHole);  // hole diam. of selected Spacer
        }
        if ((PCBFeet >= pcb_pillar_offset)&&(PCBFeet < pcb_spacer_offset))  { // Pillars as PCBFeet
           if(Debug) echo("PCBFeet-Pillars:", PCBFeet=PCBFeet, pcb_pillar_offset=pcb_pillar_offset, diam=pillars[PCBFeet - pcb_pillar_offset][2]);
           PCBFeetHoles(diam = pillars[PCBFeet - pcb_pillar_offset][2]);
       }
        if (PCBFeet >= pcb_spacer_offset) {                                   //Spacers as PCBFeet
           if(Debug) echo("PCBFeet-Spacer:", PCBFeet=PCBFeet, pcb_spacer_offset=pcb_spacer_offset, diam=pcb_spacer_innerDiam);
           PCBFeetHoles(diam = pcb_spacer_innerDiam);
        }
        // Handling of CaseFeet
        if (CaseFeet !=0) {  //draw Holes instead of case-Feet for all kind of feet, but "no Feet"
           CaseFeetHoles();
        }
        // Additional Holes
        //if (UseAdditionalHoles) {
           AdditionalHoles();// 2 Holes for BatteryHolder
        //}
    } // end difference
    if (CaseFeet >=2) { 
        DrawCaseFeet();        // draw Case Feet, only in preview mode
    }

}



/*  Panel module

    Produces a single panel with potentially rounded corners. Takes no
    arguments but uses the global parameters.
*/
module Panel() {
    Filet = (Filet > Thick*2) ? Filet - Thick - PanelVerticalGap : Filet - PanelVerticalGap;
    if(Debug) echo("mod. Panel:", Thick=PanelThick, PanelWidth=PanelWidth, PanelHeight=PanelHeight, Filet=Filet);
    translate([Filet, Filet, 0]) {
        offset(r=Filet, $fn=Resolution) {
            square([PanelWidth - Filet*2, PanelHeight - Filet*2]);
        }
    }
}


/*  Cylinder Hole module

    Produces a cylinder for use as a hole in a panel

    Arguments:
    OnOff: Rendered only if 1
    Cx: X position of hole center
    Cy: Y position of hole center
    Cdia: diameter of hole
*/
module CylinderHole(OnOff, Cx, Cy, Cdia) {
    if (OnOff) {
        if(Debug) echo("mod. CylinderHole:", Cx=Cx, Cy=Cy, Cdia=Cdia + CutoutMargin*2);
        translate([Cx, Cy, 0]) {
            //circle(d=Cdia + CutoutMargin, $fn=100);
            circle(d=Cdia + CutoutMargin*2, $fn=100);
        }
    }
}


/*  Square Hole module

    Produces a rectangular prism with potentially rounded corner for use as
    a hole in a panel

    Arguments:
    OnOff: Rendered only if 1
    Sx: X position of bottom left corner
    Sy: Y position of bottom left corner
    Sl: width of rectangle
    Sw: height of rectangle
    Filet: radius of rounded corner
*/

module SquareHole(OnOff, Sx, Sy, Sl, Sw, Filet) {
    if (OnOff) {
        Offset = Filet + CutoutMargin;
        if(Debug) echo("mod. SquareHole:", Sx=Sx,
                                      Sy=Sy,
                                      Sl=Sl + CutoutMargin*2,
                                      Sw=Sw + CutoutMargin*2,
                                      Filet=Offset);
        translate([Sx + Filet, Sy + Filet, 0]) {
            offset(r=Offset, $fn=Resolution) {
                square([Sl - Filet*2, Sw - Filet*2]);
            }
        }
    } // end if
}

module SquareHoleRecess(OnOff, Sx, Sy, Sl, Sw, Recess, XMargin, YMargin, side) {
    if (OnOff) {
        if(Debug) echo("mod. SquareHoleRecess:",
                                 Sx=Sx,
                                 Sy=Sy,
                                 Sl=Sl + 2*CutoutMargin,
                                 Sw=Sw + 2*CutoutMargin,
                                 Recess=Recess,
                                 XMargin=XMargin + CutoutMargin,
                                 YMargin=YMargin + CutoutMargin);

        translate([Sx, Sy, 0-eps]) {
            linear_extrude(height=PanelThick + 2*eps) {   
                    square([Sl +2*CutoutMargin, Sw + 2*CutoutMargin]);
           }
        }
    }
       
 
    
    // Recess on the outside of the panel
    if ((OnOff) && (Recess>=0)) {
         translate([Sx-XMargin, Sy-YMargin, PanelThick-Recess]) {
             linear_extrude(height = Recess+eps) {
               square([Sl + 2*XMargin, Sw + 2*YMargin]);
             }
         }
    }
    
    // Recess on the inner side of the panel
    if ((OnOff) && (Recess<0)) {
         //translate([Sx-XMargin, Sy-YMargin, -PanelThick-Recess]) {
            linear_extrude(height = -Recess) {
                translate([Sx-XMargin, Sy-YMargin, -PanelThick-Recess]) {
            //cube([Sl + 2*XMargin, Sw + 2*YMargin, -Recess+eps], center=false);
               square([Sl + 2*XMargin, Sw + 2*YMargin]);
            }
         }
    }
    
}



module FPLongHoles() {     // Longholes for frontpanel
     for (FP_Hole = aFP_Holes) {
         if (FP_Hole[5]==0) { //only tighten right side of hole
            //        xPos-offset           diam2     diam1    
            //xPos= FP_Hole[1] + FP_Hole[3]/2 - (FP_Hole[3] - FP_Hole[4]);
            xPos= FP_Hole[1] - FP_Hole[3]/2 + FP_Hole[4];
            yPos = FP_Hole[2];
            diam1 = FP_Hole[3] + CutoutMargin*2;
            if(Debug) echo("Pos(FRight):", xPos=xPos, yPos=yPos, diam1=diam1);
            diam2 = FP_Hole[3]/2- FP_Hole[4]+FP_Hole[3]/2;
            if(Debug) echo("diam2:",diam2);
            //translate([xPos + CutoutMargin,yPos-diam1/2,0]) {
            translate([xPos + CutoutMargin+Thick,yPos-diam1/2+Thick,0]) {
                square(size=[diam2,diam1],center=false);
            }
         } // end if
         // symmetric , tigthen both sides of hole
         if (FP_Hole[5]==1) {
            // right side
            xPosR= FP_Hole[1] + FP_Hole[4]/2;
            yPos = FP_Hole[2];
            diam1 = FP_Hole[3]+ CutoutMargin*2;
            if(Debug) echo("Pos(FRight):", xPosR=xPosR, yPos=yPos, diam1=diam1);
            diam2R = (FP_Hole[3]- FP_Hole[4])/2;
            if(Debug) echo("diam2R:",diam2R);
            //translate([xPosR + CutoutMargin,yPos-diam1/2,0]) {
            translate([xPosR + CutoutMargin+Thick,yPos-diam1/2+Thick,0]) {
               square(size=[diam2R,diam1],center=false);
            }
            // left side
            xPosL=FP_Hole[1] - FP_Hole[3]/2;
            if(Debug) echo("Pos(FLeft):", xPosL=xPosL, yPos=yPos, diam1=diam1);
            diam2L = (FP_Hole[3]- FP_Hole[4])/2;
            if(Debug) echo("diam2L:",diam2L);
            //translate([xPosL-CutoutMargin,yPos-diam1/2,0]) {
            translate([xPosL-CutoutMargin+Thick,yPos-diam1/2+Thick,0]) {
               square(size=[diam2L,diam1],center=false);
            }
         } // end if
  
   } // end for
}

module BPLongHoles() {     // Longholes for Backpanel
     for (BP_Hole = aBP_Holes) {
         if (BP_Hole[5]==0) { //only tighten right side of hole
            //        xPos-offset      diam1              diam2    
            //xPos= BP_Hole[1] + BP_Hole[3]/2 - (BP_Hole[3] - BP_Hole[4]);
            xPos= BP_Hole[1] - BP_Hole[3]/2 + BP_Hole[4];
            yPos = BP_Hole[2];
            diam1 = BP_Hole[3] + CutoutMargin*2;
            if(Debug) echo("mod. BPLongHoles: Pos(BRight):", xPos=xPos, yPos=yPos, diam1=diam1);
            diam2 = BP_Hole[3]/2- BP_Hole[4]+BP_Hole[3]/2;
            if(Debug) echo("mod. BPLongHoles: diam2:",diam2);
            //translate([xPos + CutoutMargin,yPos-diam1/2,0]) {
            translate([xPos + CutoutMargin+Thick,yPos-diam1/2+Thick,0]) {
                square(size=[diam2,diam1],center=false);
            }
         } // end dif
         // symmetric , tigthen both sides of hole
         if (BP_Hole[5]==1) {
            // right side
            xPosR= BP_Hole[1] + BP_Hole[4]/2;
            yPos = BP_Hole[2];
            diam1 = BP_Hole[3]+ CutoutMargin*2;
            diam2R = (BP_Hole[3]- BP_Hole[4])/2;
            if(Debug) echo("mod. BPLongHoles: Pos(BRight), Diam.:", xPosR=xPosR, yPos=yPos, diam1=diam1, diam2R=diam2R);
            //translate([xPosR + CutoutMargin,yPos-diam1/2,0]) {
            translate([xPosR + CutoutMargin+Thick,yPos-diam1/2+Thick,0]) {
               square(size=[diam2R,diam1],center=false);
            }
            // left side
            xPosL=BP_Hole[1] - BP_Hole[3]/2;
            diam2L = (BP_Hole[3]- BP_Hole[4])/2;
            if(Debug) echo("mod. BPLongHoles: Pos(FLeft), Diam.:", xPosL=xPosL, yPos=yPos, diam1=diam1, diam2L=diam2L);
            //translate([xPosL-CutoutMargin,yPos-diam1/2,0]) {
            translate([xPosL-CutoutMargin+Thick,yPos-diam1/2+Thick,0]) {
               square(size=[diam2L,diam1],center=false);
            }
         } //end if
   } //end for
}


/*  LText module

    Produces linear text for use on a panel

    Arguments:
    OnOff: Rendered only if 1
    Tx: X position of bottom left corner of text
    Ty: Y position of bottom left corner of text
    Font: Font to use for text
    Size: Approximate Height of text in mm.
    Content: The text
    HAlign: Text horizontal alignment. Defaults to "center". "left" and
        "right" available.
    VAlign: Text vertical alignment. Defaults to "baseline". "top",
        "center", and "bottom" available.
*/
module LText(OnOff,Tx,Ty,Font,Size,Content, HAlign="center", VAlign="baseline") {
    if (OnOff) {
        if(Debug) echo("mod. LText:", Tx=Tx, Ty=Ty, Font=Font, Size=Size, Content=Content, HAlign=HAlign, VAlign=VAlign);
        translate([Tx, Ty, PanelThick]) {
            linear_extrude(height=FontThick) {
                text(Content, size=Size, font=Font, halign=HAlign, valign=VAlign);
            }
        }
    }
}


/*  CText module

    Produces circular text for a panel

    OnOff:Rendered only if 1
    Tx: X position of text
    Ty: Y position of text
    Font: Font to use for text
    Size: Approximate height of text in mm
    TxtRadius: Radius of text
    Angl: Arc angle
    Turn: Starting angle
    Content: The text
*/
module CText(OnOff, Tx, Ty, Font, Size, TxtRadius, Angl, Turn, Content) {
    if (OnOff) {
        if(Debug) echo("mod. CText:", Tx=Tx, Ty=Ty, Font=Font, Size=Size,
             TxtRadius=TxtRadius, Turn=Turn, Content=Content);
        Angle = -Angl / (len(Content) - 1);
        translate([Tx, Ty, PanelThick]) {
            for (i= [0 : len(Content) - 1] ) {
                rotate([0, 0, i*Angle + 90 + Turn]) {
                    translate([0, TxtRadius, 0]) {
                        linear_extrude(height=FontThick) {
                            text(Content[i], size=Size, font=Font, halign="center");
                        }
                    }
                }
            }
        }
    }
}


/*  FPanL module

    Produces the front panel. No arguments are used, but this module imports
    FPanelHoles() and FPanelText() which must be edited to produce holes and
    text for your box.
*/
module FPanL() {
    translate([Length - (Thick + PanelThickGap + PanelThick),
               Thick + PanelHorizontalGap,
               Thick + PanelVerticalGap]) {
        rotate([90, 0, 90]) {
            color(Couleur2) {
              difference() {  // for Holes with Recess
                linear_extrude(height=PanelThick) {
                    difference() {
                        Panel();
                        if (PanelFeatures) {
                            FPanelHoles();
                        }
                    } // end difference norm. Holes
                    if (PanelFeatures) {
                        FPLongHoles();
                    }
                } // end linear_extrude
                FPanelHolesRecess();
              }  // end difference Holes w. Recess
            } // end color
            color(TextColor) {
                if (PanelFeatures) {
                    FPanelText();
                }
            }
        } // end rotate
    } // end translate
}


/*  BPanL module

    Produces the back panel. No arguments are used, but this module imports
    BPanelHoles() and BPanelText() which must be edited to produce holes and
    text for your box.
*/
module BPanL() {
    translate([Thick + PanelThickGap + PanelThick,
               Thick + PanelHorizontalGap + PanelWidth,
               Thick + PanelVerticalGap]) {
        rotate([90, 0, 270]) {
               color(Couleur2) {
                  difference() { // for Holes with Recess
                    linear_extrude(height=PanelThick) {
                        difference() { // for Panel and normal Holes
                            Panel();
                            if (PanelFeatures) {
                                BPanelHoles();
                            }
                        } // end difference norm. Holes
                        if (PanelFeatures) {
                            BPLongHoles();
                        }
                    } // end linear_extrude
                    BPanelHolesRecess();
               }// end difference Holes w. Recess
            }   // end color
            color(TextColor) {
                if (PanelFeatures) {
                    BPanelText();
                }
            }  // end color
        } // end rotate
    } // translate
}

 // FAN Module Section //
//----------------//



module fan_cover_inv(xPos, yPos, fan_size, screw_hole_dia, screw_hole_distance) {
   translate([xPos+fan_size/2, yPos+fan_size/2,0 -eps]) {


    corner_size = fan_size - screw_hole_distance;
    screw_pos = (fan_size - corner_size) / 2;
    color("DodgerBlue")
        union() {
//            linear_extrude(height = cover_h, convexity = 20) {
                intersection() {
                   square([fan_size, fan_size], center = true);
                   fan_pattern_inv(fan_size, fan_line_size, fan_line_space);
                }
            //}
        }  // union
 
        // screw-holes
        for(y = [-1:2:1]) {
            for(x = [-1:2:1]) {
                translate([screw_pos * x, screw_pos * y, -2]) {
                   // cylinder(h = cover_h +4, d = screw_hole_dia, $fn=30);
                   circle(d = screw_hole_dia, $fn=30);
                }
            }
        }
   }
}


module fan_pattern_inv(fan_size, line_size, line_space) {
   line = (line_size + line_space) * 2;
   num = ceil(fan_size /2 / line * 1.42)-1;
   
   difference() {
      union() {
         for (n = [1:num]) {
            difference() {
               circle(d = n * line + line_size *3, $fn = fan_size);
               circle(d = n * line, $fn = fan_size);
               //circle(d = n * line + line_size * 3, $fn = ceil(n * line + line_size * 5));
               //circle(d = n * line, $fn = ceil(n * line + line_size * 2));
               
            }
         }
      }
   
      for(rot=[0:90 / number_of_support_lines * 2:180]) {
         rotate(rot + 45) square([fan_size, line_size*(fan_size/100)+0.75], center = true);  // add for line_size:y=x/100+0.75
      }
  
  }
   
   
}

   

module ShowElectrParts() {
   
   // electr.parts on Frontpanel with relative values from the position-arrays
   if (FPanL) {
      
      // insert electr.parts on Frontpanel

   }  // endif
   
   // electr.parts on Backpanel with relative values from the position-arrays
   if (BPanL) {
      if (BP_fan_position[0]) {
         ShowFan(Fx=BP_fan_position[1], Fy=BP_fan_position[2], type=fan_type+1); // BP_fan_position[0]
      }
      
      // insert electr.parts on Backpanel

   }  // endif
   
// electr.parts inside the box with absolute position-values
   if (BShell) {
      
      // insert electr. parts inside of the box
      
   }  // end if
   
   
}

 


// ***********************  main-part ************************+

if($preview) {    //
   if (PartsDraw) {
      ShowElectrParts();
   }
}


// Top shell
if (TShell) {
    TopShell();
}

// Bottom shell
if (BShell) {
    BottomShell();
}

// Front panel
if (FPanL) {
    FPanL();
}

// Back panel
if (BPanL) {
    BPanL();
}

// for 3D-print of small parts (PCB-Spacers)
if ((PCBFeet >= pcb_spacer_offset) && (PCBFeet <=23) && (SmallParts)) {   // STL-export when PCBspacer choosen
   DrawPCB_Spacers();
}







