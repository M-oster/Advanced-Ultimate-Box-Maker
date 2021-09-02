//
// NopSCADlib Copyright Chris Palmer 2018
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// This file is part of NopSCADlib.
//
// NopSCADlib is free software: you can redistribute it and/or modify it under the terms of the
// GNU General Public License as published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.
//
// NopSCADlib is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with NopSCADlib.
// If not, see <https://www.gnu.org/licenses/>.
//

/*
function insert_length(type)         = type[1];     //! Length
function insert_outer_d(type)        = type[2];     //! Outer diameter at the top
function insert_hole_radius(type)    = type[3] / 2; //! Radius of the required hole in the plastic
function insert_screw_diameter(type) = type[4];     //! Screw size
function insert_barrel_d(type)       = type[5];     //! Diameter of the main barrel
function insert_ring1_h(type)        = type[6];     //! Height of the top and middle rings
function insert_ring2_d(type)        = type[7];     //! Diameter of the middle ring
function insert_ring3_d(type)        = type[8];     //! Diameter of the bottom ring
*/

//
// Threaded inserts
//
//                                l    o    h    s    b     r    r    r
//                                e    u    o    c    a     i    i    i
//                                n    t    l    r    r     n    n    n
//                                g    e    e    e    r     g    g    g
//                                t    r         w    e     1    2    3
//                                h         d         l
//                                     d         d          h    d    d
//                                                    d
//
Insert_M2x4   = [ "Insert_M2x4", 4.0, 3.5, 3.2, 2,   3.0,  1.0, 3.4, 3.1 ];
Insert_M3x5   = [ "Insert_M3x5", 5.0, 4.4, 4.0, 3,   3.65, 1.6, 4.4, 3.9 ];
Insert_M3x6g  = [ "Insert_M3x6g",5.7, 4.6, 4.2, 3,   5.15, 2.3, 4.2, 3.9 ];
Insert_M4x5   = [ "Insert_M4x5", 5.0, 5.7, 4.7, 4,   5.15, 2.3, 4.9, 4.8 ];
Insert_M4x6   = [ "Insert_M4x6", 6.0, 5.7, 4.7, 4,   5.15, 2.3, 5.0, 4.8 ];

inserts = [ Insert_M2x4, Insert_M3x5, Insert_M3x6g, Insert_M4x5, Insert_M4x6 ];
            
use <NopSCADlib/vitamins/insert.scad>
            
