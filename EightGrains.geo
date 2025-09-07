// Md Shahrier Hasan
// University of California Los Angeles
// May 2 2025

// Square geometry, 8 grains
n_grain_refine = 5;

Point(1) = {0, 0, 0};
Point(2) = {0.5, 0, 0};
Point(3) = {1, 0, 0};
Point(4) = {0, 0.5, 0};
Point(5) = {0.5, 0.5, 0};
Point(6) = {1, 0.5, 0};
Point(7) = {0, 1, 0};
Point(8) = {0.5, 1, 0};
Point(9) = {1, 1, 0};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 6};
Line(4) = {6, 9};
Line(5) = {9, 8};
Line(6) = {8, 7};
Line(7) = {7, 4};
Line(8) = {4, 1};
Line(9) = {5, 2};
Line(10) = {6, 5};
Line(11) = {8, 5};
Line(12) = {5, 4};

// Line loops

Line Loop(1) = {1, -9, 12, 8};
Line Loop(2) = {2, 3, 10, 9};
Line Loop(3) = {4, 5, 11, -10};
Line Loop(4) = {6, 7, -12, -11};

Plane Surface(11) = {1};
Plane Surface(12) = {2};
Plane Surface(13) = {3};
Plane Surface(14) = {4};


Extrude {0, 0, 0.5} {
  Surface{11,12,13,14};
  Layers{n_grain_refine};
  Recombine;
}

//+
Extrude {0, 0, 0.5} {
  Surface{58, 80, 102, 36}; 
  Layers{n_grain_refine};
  Recombine;
}

// Transfinite Line
n = n_grain_refine + 1;

Transfinite Line {1,2,3,4,5,6,7,8,9,10,11,12} = n Using Progression 1;

Transfinite Surface {11};
Transfinite Surface {12};
Transfinite Surface {13};
Transfinite Surface {14};

// Recombine Surface

Recombine Surface {11};
Recombine Surface {12};
Recombine Surface {13};
Recombine Surface {14};


Physical Volume("grain1") = {1};
Physical Volume("grain2") = {2};
Physical Volume("grain3") = {3};
Physical Volume("grain4") = {4};
Physical Volume("grain5") = {5};
Physical Volume("grain6") = {6};
Physical Volume("grain7") = {7};
Physical Volume("grain8") = {8};

Physical Surface("back") = {13, 14, 11, 12};

//+
Physical Surface("right", 191) = {115, 133, 67, 49};
//+
Physical Surface("top", 192) = {155, 137, 71, 89};
//+
Physical Surface("bottom", 11) = {177, 111, 45, 23};
//+
Physical Surface("front", 193) = {190, 124, 146, 168};
//+
Physical Surface("left", 194) = {93, 35, 189, 159};
//+
Physical Surface("grain boundary", 195) = {27, 36, 31};
//+
Physical Surface("grain boundary", 195) += {53, 58, 27};
//+
Physical Surface("grain boundary", 195) += {80, 75, 53};
//+
Physical Surface("grain boundary", 195) += {102, 31, 75};
//+
Physical Surface("grain boundary", 195) += {58, 123, 119};
//+
Physical Surface("grain boundary", 195) += {80, 119, 141};
//+
Physical Surface("grain boundary", 195) += {163, 102, 141};
//+
Physical Surface("grain boundary", 195) += {123, 36, 163};
//+
