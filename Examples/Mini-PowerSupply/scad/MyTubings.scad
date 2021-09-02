
// height as add. param
//                                 Description   OuterDim InnerDim            Colour         Height
SPACER_M3x5   = ["SPACER_M3x5",  "Polystrol",       7,      3.5,            [0.2, 0.2, 0.2],   5];
SPACER_M3x8   = ["SPACER_M3x8",  "Polystrol",       7,      3.5,            [0.2, 0.2, 0.2],   8];
SPACER_M3x10  = ["SPACER_M3x10", "Polystrol",       7,      3.5,            [0.2, 0.2, 0.2],   10];
SPACER_M3x15  = ["SPACER_M3x15", "Polystrol",       7,      3.5,            [0.2, 0.2, 0.2],   15];
SPACER_M3x20  = ["SPACER_M3x20", "Polystrol",       7,      3.5,            [0.2, 0.2, 0.2],   20];
SPACER_M4x5   = ["SPACER_M4x5",  "Polystrol",       8,      4.5,            [0.2, 0.2, 0.2],   5];
SPACER_M4x8   = ["SPACER_M4x8",  "Polystrol",       8,      4.5,            [0.2, 0.2, 0.2],   8];
SPACER_M4x10  = ["SPACER_M4x10", "Polystrol",       8,      4.5,            [0.2, 0.2, 0.2],   10];
SPACER_M4x15  = ["SPACER_M4x15", "Polystrol",       8,      4.5,            [0.2, 0.2, 0.2],   15];
SPACER_M4x20  = ["SPACER_M4x20", "Polystrol",       8,      4.5,            [0.2, 0.2, 0.2],   20];

tubings = [SPACER_M3x5, SPACER_M3x8, SPACER_M3x10, SPACER_M3x15, SPACER_M3x20, SPACER_M4x5, SPACER_M4x8, SPACER_M4x10, SPACER_M4x15, SPACER_M4x20];

use <NopSCADlib/vitamins/tubing.scad>

// adding height as param to overwrite value in lib tubing
function tubing_height(type)   = type[5]; //! Height

// external call to the original lib with additional height-param
module tubing_ext(type) {

   length = tubing_height(type);
   tubing(type, length=length);

}
