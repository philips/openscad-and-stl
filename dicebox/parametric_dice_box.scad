// Isometric viewport, x at 90 - atan(sin(45)), y = 0, z = 45
$vpr=[90 - atan(sin(45)),0,45]*1;
// Dimetric viewport
// $vpr=[60,0,45]*1;
$vpd = 600 + 12;

//include <Shapely/library.scad>
//include <Recymbol/library.scad>

/* [Main parameters] */
// Which part to create: the one for the egg bottom (Tray of Readiness) or the one for the egg top (Prisms of Holding)
Part_type = 1; // [1: "Cover (tray)", 2: "Base (holder)", 3: "Negative volumes for magnet embedding"]
// Whether to make the part solid, or with walls of the thickness specified below.
Solid_part = false;
// Pattern of dice to use. Note that not all patterns hold the same number of dice, and so not all of the parameters in "Types of dice used" will be effectively used.
Dice_pattern = 0; // [0: Single die, 7: "Matrix of columns and rows", 1: "7 dice in hexagon vertices and center", 2: "3 dice in triangle vertices", 3: "4 dice in square vertices", 5: "5 dice in 5-dot pattern (square vertices and center)", 6: "6 dice in hexagon pattern"]
// Type of matrix, if you chose "Matrix of columns and rows" above.It may have "indented" rows, or rows with one element less than the previous and next, or all the rows of equal length.
Dice_matrix_type = 0; // [0: Normal columns and rows, 1: Indenting even rows, 2: Indenting odd rows]
// Number of columns of dice, in a matrix pattern. Not used for all other patterns.
Dice_columns = 4;
// Number of rows of dice, in a matrix pattern. Not used for all other patterns.
Dice_rows = 3;
// Adjustment or fudge factor for the indented rows of the matrix pattern, increasing the space between holes (positive) or decreasing it (negative). This can be useful to fit patterns where some dice are notably different from the others.
Indented_matrix_row_spacing_adjustment = 0; // [-1: 0.001: 1]
// Adjustment or fudge factor for the radial patterns, moving them closer to (negative) or farther from (positive) the center. This can be useful to fit patterns where the center die is notably different from the others. -1 is at the very center, 1 is at the very border.
Pattern_radius_adjustment = 0; // [-1: 0.001: 1]
// Clearance for fitting the dice in their holders (in mm). Anything between 0.1 or 0.15 to 0.2 or 0.25 will usually do well.
Dice_clearance = 0.15; // [0: 0.001: 0.5]
// Whether to lay the dice resting on a face (space-saving) or to put them in the easy-to-pick orientation for trays.
Lay_dice_flat = false;
// Depth, in mm, of the recess for the dice when they are placed resting on a face.
Flat_dice_hole_depth = 2; // [0: 0.001: 15]
// Depth of the text engraving in the prisms for reference of the number of sides. This may help you with z-based color change for reference. Set to 0 to disable.
Text_depth = 0.4; // [0: 0.01: 2]
// Font to use in the text engraving in the prisms for reference of the number of sides. Use OpenSCAD nomenclature; check Help->Font List to get the available fonts and their nomenclature.
Text_font = "Liberation Sans:style=Bold";

/* [Main area parameters] */
// Width in mm of the main area.
Width = 85; // [0: 0.01: 250]
// Depth in mm of the main area (y-axis length).
Depth = 85; // [0: 0.01: 210]
// Margin for width, in mm, of the main area (this won't be used by dice holes).
Width_margin = 2; // [0: 0.01: 250]
// Margin for depth, in mm, of the main area (this won't be used by dice holes).
Depth_margin = 2; // [0: 0.01: 210]
// Thickness of the floor below the cover / tray dice holes. A negative value will cause the dice to protrude from the tray, which will need some "feet" —but can make for tighter boxes or special effects.
Tray_thickness = 1.8; // [-25: 0.0001: 25]
// Thickness of the floor below the base / holder dice holes.
Base_thickness = 1.8; // [0: 0.0001: 25]
// Style of the top right corner.
Top_right_corner_style = 1; // [0: Straight edges, 1: Rounded, -1: "Chamfered (rounded inwards)"]
// Radius of the main top right corner. Set to 0 for no rounding.
Top_right_corner_radius = 5; // [0: 0.01: 50]
// Style of the top left corner.
Top_left_corner_style = 1; // [0: Straight edges, 1: Rounded, -1: "Chamfered (rounded inwards)"]
// Radius of the main top left corner. Set to 0 for no rounding.
Top_left_corner_radius = 5; // [0: 0.01: 50]
// Style of the bottom right corner.
Bottom_right_corner_style = 1; // [0: Straight edges, 1: Rounded, -1: "Chamfered (rounded inwards)"]
// Radius of the main bottom right corner. Set to 0 for no rounding.
Bottom_right_corner_radius = 5; // [0: 0.01: 50]
// Style of the bottom left corner.
Bottom_left_corner_style = 1; // [0: Straight edges, 1: Rounded, -1: "Chamfered (rounded inwards)"]
// Radius of the main bottom left corner. Set to 0 for no rounding.
Bottom_left_corner_radius = 5; // [0: 0.01: 50]
// Leave this box checked to have automatically limited the main area corner radii to half the width or depth of the main area (the one that's smaller). Uncheck this if you want to make advanced asymmetrical shapes (with possibly unexpected results and unworkable polyhedra).
Limit_corner_radii = true;

corner_sides = [ 0 == Top_right_corner_radius ? 0 : Top_right_corner_style,
    0 == Top_left_corner_radius ? 0 : Top_left_corner_style,
    0 == Bottom_left_corner_radius ? 0 : Bottom_left_corner_style, 
    0 == Bottom_right_corner_radius ? 0 : Bottom_right_corner_style ];

corner_r = [ Top_right_corner_radius, Top_left_corner_radius, Bottom_left_corner_radius, 
    Bottom_right_corner_radius ];

// How many segments in a full circle; used only for the rounded corners of the main area. A higher value means more smoothnes and precision, but also a greater file size and rendering time. Usually 180 is more than enough. Use very low precisions ONLY to get a polygonal shape with a corner radius half of the width or depth.
Precision = 180; // [3: 1: 720]
// Rotation of the main area, in degrees. Positive values are counter-clockwise (CCW), negative values are clockwise (CW). The elements in the area WILL NOT be rotated. This is mostly useful with ngon-shaped boxes.
Main_rotation = 0; // [-360: 0.01: 360]
// Color of the main area. This will be used in preview only, for reference purposes. Use a SVG color name, or a hex code prepended by "#" (ex.: #808080).
Main_color = "#E3E3E3";

/* [Magnetization] */
// Number of magnet holes.
Magnets = 6; // [0: 1: 12]
Magnet_diameter = 4; // [1: 0.01: 15]
Magnet_height = 3; // [1: 0.01: 15]
// Clearance for fitting the magnets in their holders (in mm). Anything between 0.1 or 0.15 to 0.2 or 0.25 will usually do well.
Magnet_clearance = 0.15; // [0: 0.001: 0.5]
// Rotation of the magnet assembly. By default, when zeroed, there will be one at the right and exactly over X axis ( Y = 0 ).
Magnet_rotation = 0; // [-360: 0.01: 360]
// Z-height, in mm, of the magnet negative volumes.
Magnet_embedding_z_height = 0; // [0: 0.001: 15]
// Margin for magnets in x axis, in mm, of the main area (this won't be used by dice holes).
Magnet_width_margin = 1.27; // [0: 0.001: 120]
// Margin for depth, in mm, of the main area (this won't be used by dice holes).
Magnet_depth_margin = 1.27; // [0: 0.001: 100]
// Adjustment for the magnet patters on the horizontal coordinates (positive is to the right, negative to the left).
Magnet_x_displacement = 0; // [-100: 0: 100]
// Adjustment for the magnet patters on the vertical coordinates (positive is top-wise, negative is bottom-wise).
Magnet_y_displacement = 0; // [-100: 0: 100]
// Adjustment or fudge factor for the radial magnet patterns, moving them closer to (negative) or farther from (positive) the center. This can be useful to fit patterns where the center die is notably different from the others. -1 is at the very center, 1 is at the very border.
Magnet_radius_x_adjustment = 0; // [-1: 0.001: 1]
// Adjustment or fudge factor for the radial magnet patterns, moving them closer to (negative) or farther from (positive) the center. This can be useful to fit patterns where the center die is notably different from the others. -1 is at the very center, 1 is at the very border.
Magnet_radius_y_adjustment = 0; // [-1: 0.001: 1]


/* [Dice sizes] */
// d4 size is the side length, in mm.
d4_size = 22.5; // [1: 0.01: 100]
// d6 size is the side length.
d6_size = 16.5; // [1: 0.01: 100]
// d8 size is the distance between flats (two opposite sides, or twice the inradius).
d8_size = 14.8; // [1: 0.01: 100]
// d10/d100 size is the distance between flats (two opposite sides, or twice the inradius).
d10_size = 16.2; // [1: 0.01: 100]
// d12 size is the distance between flats (two opposite sides, or twice the inradius).
d12_size = 18; // [1: 0.01: 100]
// d20 size is the distance between flats (two opposite sides, or twice the inradius).
d20_size = 20.5; // [1: 0.01: 100]
// Truncated tetrahedron d4 size is the side length.
d4_truncated_size = 11; // [1: 0.01: 100]
// Truncated octahedron d8 size is the distance between flats (two opposite sides, or twice the inradius).
d8_truncated_size = 17; // [1: 0.01: 100]
// Size of the rhombic d12 is the distance between flats (two opposite sides, or twice the inradius).
d12_rhombic_size = 18.5; // [1: 0.01: 100]
// d24 deltoidal size is the distance between flats (two opposite sides, or twice the inradius).
d24_deltoidal_size = 23.4; // [1: 0.01: 100]
// Size of the hexahedral d24 is the distance between two flats (two opposite sides, or twice the inradius).
d24_hexahedral_size = 23.5; // [1: 0.01: 100]
// d30 size is the distance between flats (two opposite sides, or twice the inradius).
d30_size = 24.75; // [1: 0.01: 100]
// Deltoidal d60 size is the distance between flats (two opposite sides, or twice the inradius).
d60_deltoidal_size = 35.6; // [1: 0.01: 100]
// Dodoecahedral d60 size is the distance between flats (two opposite sides, or twice the inradius).
d60_dodecahedral_size = 35.6; // [1: 0.01: 100]


/* [Types of dice used] */
// Type of the first die in the arrangement.
Type_of_die_1 = 5; // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the second die in the arrangement.
Type_of_die_2 = 0; // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the third die in the arrangement.
Type_of_die_3 = 1;  // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the fourth die in the arrangement.
Type_of_die_4 = 2;  // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the fifth die in the arrangement.
Type_of_die_5 = 3;  // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the sixth die in the arrangement.
Type_of_die_6 = 4;  // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the seventh die in the arrangement.
Type_of_die_7 = 5; // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the eight die in the arrangement.
Type_of_die_8 = 5; // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the ninth die in the arrangement.
Type_of_die_9 = 5; // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the tenth die in the arrangement.
Type_of_die_10 = 5; // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the eleventh die in the arrangement.
Type_of_die_11 = 5; // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the twelfth die in the arrangement.
Type_of_die_12 = 5; // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the thirteenth die in the arrangement.
Type_of_die_13 = 5; // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]
// Type of the fourteenth die in the arrangement.
Type_of_die_14 = 5; // [0: d4, 1: d6, 2: d8, 3: "d10/d100", 4: d12, 5: d20, 6: "d4 (truncated tetrahedron)", 7: "d8 (truncated octahedron)", 8: "d12 (rhombic)", 9: "d24 (deltoidal)", 10: "d24 (hexahedral)", 11: "d30", 12: "d60 (deltoidal) ", 13: "d60 (dodecahedral)"]

{ /* OpenSCAD Shapely Library methods and functions */
/* Array of points for a circular arc.
 * If parameter d is present, it must be named.
 * If a parameter is named, all following parameters must also be named.
 */
function arc_points( r = undef, a1 = 0, a2 = 90, n = $fn, rotation = 0, pos = [0, 0], fa = $fa,
    clockwise = false, fs = $fs, d = 2) = let(
    d_ok = is_undef( r ) ? d : 2 * r, 
    r_ok = d_ok / 2,
    delta_a = a2 - a1,
    steps = max( 1, ( ( 0 == n) || is_undef( n ) ?
        max( round( abs(delta_a) / fa ), round( ( 2 * PI * ( abs( delta_a ) / 360 ) ) / fs ) )
        : n) ),
    a_step = delta_a / steps,
    start_s = clockwise ? steps : 0,
    end_s = clockwise ? 0 : steps,
    step = clockwise ? -1 : 1
    )
    [ for( i = [start_s:step:end_s], cur_a = a1 + rotation + ( a_step * i ) )
    [ r_ok * cos(cur_a), r_ok * sin(cur_a) ] + pos ];

/* Returns the average values in an array or vector
 * @uses transpose_matrix
 * @uses vector_avg
 */
function array_avg( arr ) = let( vec_num = is_list( arr ) ? len(arr) : 0,
    vec_size = is_list( arr ) && is_list( arr[0] ) ? len(arr[0] ) : 0,
    t_arr = !is_list( arr ) ? arr : transpose_matrix(arr) )
	0 == vec_num ? undef :
	0 == vec_size ? vector_avg( arr ) :
	[ for(i = [0:vec_size-1]) vector_avg(t_arr[i]) ] ;

/* Extracts a single column of a matrix.
 * Say, like getting all the x coordinates in a matrix of vectors.
 */
function array_column( arr = undef, n = 0 ) = let(arr_len = is_list( arr ) ? len(arr) : undef,
	vec_len = is_undef( arr_len ) ? undef : ( is_list( arr[0] ) ? len(arr[0]) : undef ))
	vec_len < n ? [] :
	[ for(i = [0:arr_len-1]) arr[i][n]
	];

/* Returns the max bounding values in an array, or the max value in a vector.
 * @uses transpose_matrix    
 */
function array_max( arr ) = let( vec_num = !is_list( arr ) ? undef : len(arr),
    vec_size = !is_list( arr ) || !is_list( arr[0] ) ? undef : len(arr[0] ),
    t_arr = transpose_matrix(arr) )
	is_undef( vec_num ) ? undef :
	is_undef( vec_size ) ? max( arr ) :
	[ for(i = [0:vec_size-1]) max(t_arr[i]) ];

/* Returns the median values in an array or vector
 * @uses transpose_matrix
 * @uses vector_median
 */
function array_median( arr ) = let( vec_num = !is_list( arr ) ? undef : len(arr),
   vec_size = is_list( arr ) && is_list( arr[0] ) ? len(arr[0] ) : undef,
   t_arr = transpose_matrix(arr) )
	is_undef( vec_num ) ? undef :
	is_undef( vec_size ) ? vector_median( arr ) :
	[ for(i = [0:vec_size-1]) vector_median( t_arr[i]) ] ;

/* Returns the min bounding values in an array, or the min value in a vector.
 */
function array_min( arr ) = let( vec_num = !is_list( arr ) ? undef : len(arr),
    vec_size = !is_list( arr ) || !is_list( arr[0] ) ? undef : len(arr[0] ),
    t_arr = transpose_matrix(arr) )
	is_undef( vec_num ) ? undef :
	is_undef( vec_size ) ? min( arr ):
	[ for(i = [0:vec_size-1]) min(t_arr[i]) ] ;

// Returns the first or all appearances of "needle" value in "haystack" array.
function array_search( needle, haystack, show_all = false ) = let( arr_len = len( haystack ),
    matches = [ for( i = [0: arr_len - 1] ) if( needle == haystack[i] ) i ] )
    show_all ? matches : matches[0] ;

/* Extracts a subset of an array, like PHP's array_slice
 * start Numeric value. Specifies where the function will start the slice. 0 = the first element. If this value is set to a negative number, the function will start slicing that far from the last element. -2 means start at the second last element of the array.
 * length Optional. Numeric value. Specifies the length of the returned array. If this value is set to a negative number, the function will stop slicing that far from the last element. If this value is not set, the function will return all elements, starting from the position set by the start-parameter. 
 */
function array_slice( arr, start = 0, length = undef ) = let( 
	backwards = start < 0 ? true : false,
	step = backwards ? -1 : 1,
	idx_1 = is_undef( start ) ? 0 : backwards ? len(arr) + start : start,
	l_ok = is_undef( length ) ? len( arr ) : ( length < 0 ? len( arr ) + length : length ),	
	idx_2 = backwards ? max(0, idx_1 - l_ok + 1 ) : min( len( arr ) - 1, idx_1 + l_ok - 1 ),
	first_idx = min(idx_1, idx_2),
	last_idx = max(idx_1, idx_2)
	)
	[for( i = [first_idx:last_idx] ) arr[i] ];

/* Orders an array using the quicksort algorithm. From the list comprehension examples.
 */
function array_sort( arr ) =( ! is_list( arr ) ) || ( !( len( arr ) > 0 ) ) ? [] : let(
    pivot   = arr[floor(len(arr)/2)],
    lesser  = [ for (y = arr) if (y  < pivot) y ],
    equal   = [ for (y = arr) if (y == pivot) y ],
    greater = [ for (y = arr) if (y  > pivot) y ]
) concat(
    array_sort( lesser ), equal, array_sort( greater )
);

/* Orders an array of vectors by one of the columns in descending order.
 */
function array_sort_on_desc( arr, col = 1 ) = ( !is_list( arr ) ) || ( len(arr) == 0 ) ? [] : let(
        last_i = len(arr) - 1,
        pivot_idx = floor(len(arr) /2),
        lesser  = [ for (l = [0:last_i] ) if( arr[l][col]  > arr[pivot_idx][col] ) arr[l] ],
        equal   = [ for (e = [0:last_i] ) if( arr[e][col] == arr[pivot_idx][col] ) arr[e] ],
        greater = [ for (g = [0:last_i] ) if( arr[g][col]  < arr[pivot_idx][col] ) arr[g] ]
    ) concat (
        array_sort_on_desc( lesser, col ),  equal, array_sort_on_desc( greater, col )
    );

/* Removes duplicates in an array (vector).
 */
function array_unique( arr ) = let( arr_n = len( arr ) )
    [ for( i = [0: arr_n - 1] ) let( cur_e = arr[i],
        repeat_count = 0 == i ? [] :
            [ for( d =[i-1 : -1 : 0] ) if( arr[d] == cur_e ) 1 ]
        ) if (0 == len( repeat_count ) ) cur_e		
    ];

// Cube definition
function cube_seed( r = 1 ) = let(
    half_sqrt2 = 0.70710678118654752440084436210485,
    cube_radius_factor = 1.1180339887498948482045868343656,
    cube_points = [
        [0,  1,  half_sqrt2], [ 1, 0,  half_sqrt2], [0, -1,  half_sqrt2], [-1, 0,  half_sqrt2],
        [0,  1, -half_sqrt2], [ 1, 0, -half_sqrt2], [0, -1, -half_sqrt2], [-1, 0, -half_sqrt2]
    ] * r / cube_radius_factor,
    cube_faces = [[0,1,2,3], [1,0, 4, 5], [2, 1, 5, 6], [3, 2, 6, 7], [0, 3, 7, 4], [5, 4, 7, 6]]
    ) [cube_points, cube_faces];

/* Deltoidal hexecontahedron
 * Thanks to http://dmccooey.com
 */
function deltoidal_hexecontahedron_seed( r = 1 ) = let(
    C0 = 0.690983005625052575897706582817, // (5 - sqrt(5)) / 4
    C1 = 0.783457635340899531654962439488, // (15 + sqrt(5)) / 22
    C2 = 1.11803398874989484820458683437, // sqrt(5) / 2
    C3 = 1.20601132958329828273486227812, // (5 + sqrt(5)) / 6
    C4 = 1.26766108272719625323969951590, // (5 + 4 * sqrt(5)) / 11
    C5 = 1.80901699437494742410229341718, // (5 + sqrt(5)) / 4
    C6 = 1.95136732208322818153792016770, // (5 + 3 * sqrt(5)) / 6
    C7 = 2.05111871806809578489466195539, // (25 + 9 * sqrt(5)) / 22
    C8 = 2.23606797749978969640917366873, // sqrt(5)
    deltoidal_hexecontahedron_radius_factor = 2.2939698674519558970120159698514, // C3, C6
    deltoidal_hexecontahedron_points = [
        [ 0, 0, C8 ],
        [ 0, C1, C7 ], [ 0, -C1, C7 ],
        [ C3, 0, C6 ], [ -C3, 0, C6 ], 
        [ C0, C2, C5 ], [ C0, -C2, C5 ], [ -C0, -C2, C5 ], [ -C0, C2, C5 ], 	
        [ C4, C4, C4 ], [ C4, -C4, C4 ], [ -C4, -C4, C4 ], [ -C4, C4, C4 ], 
        [ 0, C6, C3 ], [ 0, -C6, C3 ], 
        [ C5, C0, C2 ], [ C5, -C0, C2 ], [ -C5, -C0, C2 ], [ -C5, C0, C2 ], 
        [ C7, 0, C1 ], [ -C7, 0, C1 ], 
        [ C2, C5, C0 ], [ C2, -C5, C0 ], [ -C2, -C5, C0 ], [ -C2, C5, C0 ],
        [ 0, C8, 0 ], [ C1, C7, 0 ], [ C6, C3, 0 ],
        [ C8, 0, 0 ], [ C6, -C3, 0 ], [ C1, -C7, 0 ],
        [ 0, -C8, 0 ], [ -C1, -C7, 0 ], [ -C6, -C3, 0 ], 
        [ -C8, 0, 0 ], [ -C6, C3, 0 ], [ -C1, C7, 0 ], 
        [ C2, C5, -C0 ], [ C2, -C5, -C0 ], [ -C2, -C5, -C0 ], [ -C2, C5, -C0 ],
        [ C7, 0, -C1 ], [ -C7, 0, -C1 ],
        [ C5, C0, -C2 ], [ C5, -C0, -C2 ], [ -C5, -C0, -C2 ], [-C5, C0, -C2 ],
        [ 0, C6, -C3 ],  [0, -C6, -C3 ],
        [ C4, C4, -C4 ], [ C4, -C4, -C4 ], [ -C4, -C4, -C4 ], [ -C4, C4, -C4 ],
        [ C0, C2, -C5 ], [ C0, -C2, -C5 ], [ -C0, -C2, -C5 ], [ -C0, C2, -C5 ],
        [ C3, 0, -C6 ], [ -C3, 0, -C6 ],
        [ 0, C1, -C7 ], [ 0, -C1, -C7 ],
        [ 0, 0, -C8 ]
    ] * r / deltoidal_hexecontahedron_radius_factor,
    deltoidal_hexecontahedron_faces = [
        [ 0, 1, 5, 3 ], [ 0, 3, 6, 2 ],  [ 0, 2, 7, 4 ], [ 0, 4, 8 , 1], 
        [ 5, 1, 8, 13 ], [ 2, 6, 14, 7 ], 
        [ 5, 13, 21, 9 ], [ 3, 5, 9, 15 ], [ 6, 3, 16, 10 ], [ 6, 10, 22, 14 ],
        [ 7, 14, 23, 11 ], [ 4, 7, 11, 17 ], [ 8, 4, 18, 12 ], [ 8, 12, 24, 13 ],
        [ 13, 25, 26, 21 ], [ 9, 21, 27, 15 ],
        [ 3, 15, 19, 16 ], [ 10, 16, 29, 22 ], [ 14, 22, 30, 31 ], [ 14, 31, 32, 23 ],
        [ 11, 23, 33, 17 ], [ 4, 17, 20, 18 ], [ 12, 18, 35, 24 ], [ 13, 24, 36, 25 ],
        [ 26, 25, 47, 37 ], [ 27, 21, 26, 37 ], [ 19, 15, 27, 28 ], [ 16, 19, 28, 29 ],
        [ 30, 22, 29, 38 ], [ 31, 30, 38, 48 ], [ 32, 31, 48, 39 ], [ 33, 23, 32, 39 ],
        [ 20, 17, 33, 34 ], [ 18, 20, 34, 35 ], [ 24, 35, 40, 36 ], [ 25, 36, 40, 47 ], 
        [ 37, 47, 53, 49 ], [ 27, 37, 49, 43 ], [ 28, 27, 43, 41 ], [ 29, 28, 41, 44 ],
        [ 38, 29, 44, 50 ], [ 48, 38, 50, 54 ], [ 39, 48, 55, 51 ], [ 33, 39, 51, 45 ],
        [ 34, 33, 45, 42 ], [ 35, 34, 42, 46 ], [ 35, 46, 52, 40 ], [ 40, 52, 56, 47 ],
        [ 47, 56, 59, 53 ], [ 43, 49, 53, 57 ], [ 41, 43, 57, 44 ], [ 50, 44, 57, 54 ],
        [ 48, 54, 60, 55 ], [ 45, 51, 55, 58 ], [ 42, 45, 58, 46 ], [ 52, 46, 58, 56 ],
        [ 57, 53, 59, 61 ], [ 54, 57, 61, 60 ], [ 55, 60, 61, 58 ], [ 56, 58, 61, 59 ]
    ] ) [ deltoidal_hexecontahedron_points, deltoidal_hexecontahedron_faces ];

/* Deltoidal icositetrahedron
 * @uses sqrt2
 * Thanks to http://dmccooey.com
 */
function deltoidal_icositetrahedron_seed( r = 1 ) = let(
    sqrt2 = 1.4142135623730950488016887242097,
    deltoidal_icositetrahedron_radius_factor = sqrt2,
    C0 = 0.773459080339013578400241246316, // (4 + sqrt(2)) / 7
    deltoidal_icositetrahedron_points = [
        [ 0, 0, sqrt2 ],
        [ 1, 0, 1 ], [ 0, -1, 1 ], [ -1, 0, 1 ], [ 0, 1, 1 ], 
        [ C0, C0, C0 ], [ C0, -C0, C0 ], [ -C0, -C0, C0 ], [ -C0, C0, C0 ],
        [  1,  1, 0 ], [  sqrt2, 0, 0 ], [  1, -1, 0 ], [ 0, -sqrt2, 0 ],
        [ -1, -1, 0 ], [ -sqrt2, 0, 0 ], [ -1,  1, 0 ], [ 0,  sqrt2, 0 ], 
        [ C0, C0, -C0 ], [ C0, -C0, -C0 ], [ -C0, -C0, -C0 ],  [ -C0, C0, -C0 ],
        [ 1, 0, -1 ], [ 0, -1, -1 ], [ -1, 0, -1 ], [ 0, 1, -1 ],
        [ 0, 0, -sqrt2 ] 
    ] * r / deltoidal_icositetrahedron_radius_factor,
    deltoidal_icositetrahedron_faces = [
        [0, 4, 5, 1], [0, 1, 6, 2], [0, 2, 7, 3], [0, 3, 8, 4],
        [5, 4, 16, 9], [1, 5, 9, 10], [6, 1, 10, 11], [2, 6, 11, 12],
        [7, 2, 12, 13], [3, 7, 13, 14], [8, 3, 14, 15], [4, 8, 15, 16],
        [9, 16, 24, 17], [10, 9, 17, 21], [11, 10, 21, 18], [12, 11, 18, 22],
        [13, 12, 22, 19], [14, 13, 19, 23], [15, 14, 23, 20], [16, 15, 20, 24], 
        [17, 24, 25, 21], [18, 21, 25, 22], [19, 22, 25, 23], [ 20, 23, 25, 24 ]
    ] ) [deltoidal_icositetrahedron_points, deltoidal_icositetrahedron_faces];

// Returns the distance between two any points.
function distance( a, b ) = norm( b - a );

// Dodecahedron definition
function dodecahedron_seed( r = 1 ) = let(
    phi = 1.6180339887498948482045868343656,
    phi_inv = 1 / phi, // 0.61803398874989484820458683436564
    dodecahedron_radius_factor = 1.7320508075688772935274463415059, // Square root of 3
    dodecahedron_points =[ 
        [0, phi_inv, phi], [0, -phi_inv, phi], 
        [1, 1, 1], [1, -1, 1], [-1, -1, 1], [-1, 1, 1], 
        [phi, 0, phi_inv], [-phi, 0, phi_inv], 
        [phi_inv, phi, 0], [phi_inv, -phi, 0], [-phi_inv, -phi, 0], [-phi_inv, phi, 0],
        [phi, 0, -phi_inv], [-phi, 0, -phi_inv],
        [ 1, 1, -1], [1, -1, -1], [-1, -1, -1], [-1, 1, -1],
        [0, phi_inv, -phi], [0, -phi_inv, -phi] 
    ] * r / dodecahedron_radius_factor,
    dodecahedron_faces = [ 
        [ 0, 2, 6, 3, 1], [ 0, 1, 4, 7, 5 ],
        [ 0, 5, 11, 8, 2 ], [ 1, 3, 9, 10, 4 ],
        [ 2, 8, 14, 12, 6 ], [ 3, 6, 12, 15, 9 ], [ 4, 10, 16, 13, 7 ], [ 5, 7, 13, 17, 11 ],
        [ 8, 11, 17, 18, 14 ], [ 10, 9, 15, 19, 16 ],
        [ 12, 14, 18, 19, 15 ], [ 13, 16, 19, 18, 17 ]
    ] ) [dodecahedron_points, dodecahedron_faces];

/* Flattens a matrix (removes outer nesting level). From OpenSCAD examples.
 * input : nested list
 * output : list with the outer level nesting removed
 */
function flatten_matrix(l) = [ for (a = l) for (b = a) b ] ;

/* Returns the center of the bounding box for a set of points.
 * @param method Method to use to find the center. Possible values are centroid, median, avg, and box or bounding_box.
 * @uses xy_centroid
 * @uses xyz_centroid_z_median
 * @uses array_median
 * @uses array_avg
 * @uses points_bounding_box_center
 */
function get_points_center( vec, method = undef ) =  let(
	points_ok = vec[0] == vec[len(vec) -1] ? array_slice( vec, 0, -1 ) : vec,
	n_dims = is_list( points_ok[0] ) ? len( points_ok[0] ) : 1,
	method_ok = is_undef( method ) ? 
		2 == n_dims ? "centroid" : "median"
		: method
	)
	"centroid" == method_ok ?
		2 == n_dims ? xy_centroid( vec ) : xyz_centroid_z_median( vec )
	: "median" == method_ok ? array_median( points_ok )
	: "avg" == method_ok ? array_avg( points_ok )
	: points_bounding_box_center( points_ok );

// Icosahedron definition
// phi = 1.6180339887498948482045868343656;
function icosahedron_seed( r = 10 ) = let(
    phi = 1.6180339887498948482045868343656,
    ico_r_factor = 1.9021130325903071442328786667587, // sqrt( pow( phi, 2 ) + 1 );
    icosahedron_points = [[0, 1, phi], [0, -1, phi], //0-1
        [phi, 0, 1], [-phi, 0, 1], // 2-3
        [1, phi, 0], [1, -phi, 0], [-1, -phi, 0], [-1, phi, 0], // 4-7
        [phi, 0, -1], [-phi, 0, -1], // 8-9
        [0, 1, -phi], [0, -1, -phi] //10-11
    ] * r / ico_r_factor,
    icosahedron_faces = [ [ 1,0,2 ], [ 0, 1, 3 ], 
        [ 0, 4, 2 ], [ 1, 2, 5 ], [ 1, 5, 6 ], [ 1, 6, 3 ], [ 0, 3, 7 ], [ 0, 7, 4 ], 
        [2, 4, 8], [ 2, 8, 5 ], [ 3, 6, 9 ], [3, 9, 7],	
        [ 4, 7, 10 ], [ 4, 10, 8 ], [ 5, 8, 11 ], [5, 11, 6], [ 6, 11, 9 ], [ 7, 9, 10 ], 
        [8,10, 11], [9,11,10]
    ]) [icosahedron_points, icosahedron_faces];

/* Returns an array of points defining a regular n-gon
 * @uses polygon_radius
 */
function ngon_points( n = 6, r = 10, rotation = 0, pos = [0, 0], clockwise = false, closed = false,
    side = undef ) = let(
        r_ok = is_undef( side ) ? r : polygon_radius( n = n, side = side ),
        ang_step = 360 / n, last_v = n - ( closed ? 0 : 1 ) 
    )
    [ for( i = [0:last_v], cur_a = clockwise ? 360 - ( ang_step * i ) : ( ang_step * i ) )
        [ r_ok * cos( rotation + cur_a ), r_ok * sin( rotation + cur_a ) ] + pos
    ];

// Octahedron definition
function octahedron_seed( r = 1 ) = let(
    octahedron_points=[ [0,0,1], [1,0,0], [0,-1,0], [-1,0,0], [0,1,0], [0,0,-1]] * r,
    octahedron_faces=[ [0, 1, 2], [0, 2, 3], [0,3,4], [0, 4, 1],
        [1, 5, 2], [2, 5, 3], [3, 5, 4], [4, 5, 1]] 
    ) [octahedron_points, octahedron_faces];

/* Canonical pentakis dodecahedron
 * Thanks to http://dmccooey.com
 */
function pentakis_dodecahedron_seed( r = 1 ) = let(
    C0 = 0.927050983124842272306880251548, // 3 * (sqrt(5) - 1) / 4
    C1 = 1.33058699733550141141687582919, // 9 * (9 + sqrt(5)) / 76
    C2 = 2.15293498667750705708437914596, // 9 * (7 + 5 * sqrt(5)) / 76
    C3 = 2.427050983124842272306880251548, // 3 * (1 + sqrt(5)) / 4
    pentakis_dodecahedron_radius_factor = 2.5980762113533159402911695122588, // sqrt( 3 * (1.5^2 ) )
    pentakis_dodecahedron_points = [
        [ 0, C0, C3], [ 0, -C0, C3 ], 
        [ C1, 0, C2 ], [ -C1, 0, C2 ], 
        [ 1.5, 1.5, 1.5 ], [ 1.5, -1.5, 1.5 ], [ -1.5, -1.5, 1.5 ], [ -1.5, 1.5, 1.5 ],
        [ 0, C2, C1 ], [ 0, -C2, C1 ],
        [ C3, 0, C0 ], [ -C3, 0, C0 ], 
        [ C0, C3, 0 ], [ C2, C1, 0 ], [ C2, -C1, 0 ], [ C0, -C3, 0 ], 
        [ -C0, -C3, 0 ], [ -C2, -C1, 0 ], [ -C2, C1, 0 ], [ -C0, C3, 0 ],
        [ C3, 0, -C0 ], [ -C3, 0, -C0 ],
        [ 0, C2, -C1 ], [ 0, -C2, -C1 ],
        [ 1.5, 1.5, -1.5 ], [ 1.5, -1.5, -1.5 ], [ -1.5, -1.5, -1.5 ], [ -1.5, 1.5, -1.5 ],
        [ C1, 0, -C2 ], [ -C1, 0, -C2 ],
        [ 0, C0, -C3 ], [ 0, -C0, -C3 ]
    ] * r / pentakis_dodecahedron_radius_factor,
    pentakis_dodecahedron_faces = [
        [ 0, 2, 1 ], [ 0, 1, 3 ],
        [ 0, 8, 4 ], [ 2, 0, 4 ], [ 2, 4, 10 ], [ 2, 10, 5 ],
        [ 1, 2, 5 ], [ 1, 5, 9 ], [ 1, 9, 6 ], [ 3, 1, 6 ],
        [ 3, 6, 11 ], [ 3, 11, 7 ], [ 0, 3, 7 ], [ 0, 7, 8 ],
        [ 8, 19, 12 ], [ 4, 8, 12 ],
        [ 4, 12, 13 ], [ 10, 4, 13 ], [ 5, 10, 14 ], [ 5, 14, 15 ],
        [ 9, 5, 15 ], [ 9, 15, 16 ], [ 6, 9, 16 ], [ 6, 16, 17 ], 
        [ 11, 6, 17 ], [ 7, 11, 18 ], [ 7, 18, 19 ], [ 8, 7, 19 ],
        [ 12, 19, 22 ], [ 12, 22, 24 ],
        [ 13, 12, 24 ], [ 20, 13, 24 ], [ 10, 13, 20 ], [ 14, 10, 20 ],
        [ 14, 20, 25 ], [ 15, 14, 25 ], [ 15, 25, 23 ], [ 16, 15, 23 ],
        [ 16, 23, 26 ], [ 17, 16, 26 ], [ 21, 17, 26 ], [ 11, 17, 21 ],
        [ 18, 11, 21 ], [ 18, 21, 27 ], [ 19, 18, 27 ], [ 19, 27, 22 ],
        [ 24, 22, 30 ], [ 24, 30, 28 ], [ 20, 24, 28 ], [ 25, 20, 28 ], 
        [ 25, 28, 31 ], [ 23, 25, 31 ],[ 26, 23, 31 ], [ 26, 31, 29 ],
        [ 21, 26, 29 ], [ 27, 21, 29 ], [ 27, 29, 30 ], [ 22, 27, 30 ],
        [ 28, 30, 31 ], [ 30, 29, 31 ]
    ] ) [ pentakis_dodecahedron_points, pentakis_dodecahedron_faces ];

/* Returns the center of the bounding box for a set of points.
 * @uses array_min
 * @uses array_max
 */
function points_bounding_box_center( vec ) = let( 
		u_bound = array_max( vec ), l_bound = array_min( vec )
	)
	l_bound + ( ( u_bound - l_bound ) / 2 );

/* Returns the area defined by a set of polygon points, with sign
 * Clockwise-ordered points define a negative area, so hollow polygons are possible
 * This does not work with self-intersecting polygons
 * See http://paulbourke.net/geometry/polygonmesh/
 * @uses vector_sum
 */
function points_signed_area( points ) = let(
	points_ok = points[0] == points[len(points) -1] ? array_slice( points, 0, -1 ) : points,
	n_points =  len( points_ok ),
	carried_sum = [ for( i = [0:n_points-1] ) let( next_i = ( i + 1 ) % n_points )
		( points_ok[i][0] * points_ok[next_i][1] ) - (points_ok[next_i][0] * points_ok[i][1])
	]
	)
	vector_sum( carried_sum ) / 2;

// Returns the apothem of a regular polygon of a given radius.
function polygon_apothem( n = 5, r = 1 ) = r * cos( 180 / n );

/* Returns the radius of a polygon by side or by apothem
 * @param sides Number of sides of the polygon
 * @param side Side length (optional, if 0 apothem will be used)
 * @param apothem Apothem length (optional, used only if side = 0).
 */
function polygon_radius( n = 4, side = 0, apothem = 0 ) = side > 0 ?
    	side / ( 2 * sin( 180 / n ) ) : apothem / cos( 180 / n );

/* Returns the edge lengths of a polyseed, optionally grouped by values (vector of [length, count])
 * @uses polyseed_edges
 * @uses distance        
 * @uses array_sort_on_desc
 * @uses vector_group_totals        
 */    
function polyseed_edge_lengths( polyseed, group_results = false ) = let(
    edges = polyseed_edges( polyseed, ignore_direction = true, return_xyz = true ),
    num_edges = len( edges ),
    lengths = [for( d =[0:num_edges - 1] ) distance( edges[d][0], edges[d][1] ) ],
    result = group_results ?
        array_sort_on_desc( array_sort_on_desc( vector_group_totals( lengths ), 0 ), 1 ):
        lengths
    ) result;

/* Returns all edges of a polyhedron set
 * @uses polyseed_face_edges
 * @uses array_unique
 * @uses flatten_matrix
 */
function polyseed_edges( polyseed, ignore_direction = true, return_xyz = false ) = let(
    points = polyseed[0], faces = polyseed[1], num_faces = len( faces ),
    unsorted_edges = array_unique( flatten_matrix( [for( ue = [0: num_faces - 1] )
        polyseed_face_edges( polyseed, face_id = ue ) ] ) ),
    num_unsorted_edges = len( unsorted_edges ),
    sorted_edges = !ignore_direction ? unsorted_edges: 
        array_unique( [for( se = [0: num_unsorted_edges - 1] )
            unsorted_edges[se][0] < unsorted_edges[se][1] ? unsorted_edges[se] :
                [unsorted_edges[se][1], unsorted_edges[se][0] ]
        ] ),
    num_edges = len( sorted_edges )
    ) return_xyz ? [for( exyz = [0:num_edges - 1] )
        [points[sorted_edges[exyz][0]], points[sorted_edges[exyz][1]] ] ] :
    sorted_edges;

/* Gets all the face centers
 * @uses polyseed_faces_xyz
 * @uses vector_round_dec    
 * @uses get_points_center
 */
function polyseed_face_centers( polyseed, center = [0, 0, 0], precision = 14 ) = let(
	points = polyseed[0], faces = polyseed[1], num_faces = len( faces ),
	faces_xyz = polyseed_faces_xyz( polyseed ),
	centers = [ for( c = [0: num_faces - 1] ) 
        vector_round_dec( get_points_center( faces_xyz[c], "avg" ) - center,
            precision = precision ) ]
	) centers;

/* Returns the edges of a face, with points as id or coordinates.
 */
function polyseed_face_edges( polyseed, face_id, return_xyz = false ) = let(
    points = polyseed[0], faces = polyseed[1], face = faces[ face_id ],
    face_len = is_undef( face ) || !is_list( face ) ? 0 : len( face ), last_point = face_len - 1,
    edge_ids = 0 == face_len ? [] : 
        [for( i = [0:last_point] ) [face[i], i == last_point ? face[0] : face[i+1] ] ]
    ) return_xyz ? [ for( edge = edge_ids )
        [ points[edge[0]], points[edge[1]] ] ]:
        edge_ids;

/* Returns the coordinates of all the points in a face
 */
function polyseed_face_points( polyseed, face_id ) = let( 
    points = polyseed[0], faces = polyseed[1], face = faces[ face_id ],
    face_len = len( face ), last_point = face_len - 1 )
    [ for( i = [0:last_point]) points[face[i]] ];

/* Returns all the faces of a polyhedron set in coordinates.
 */
function polyseed_faces_xyz( polyseed ) = let(
	points = polyseed[0], faces = polyseed[1], num_faces = len( faces ),
	faces_xyz = [ for( f = [0:num_faces - 1] ) let( face = faces[f], num_points = len( face ) )
		[ for( fp = [0 : num_points - 1] ) points[ face[fp] ] ] ]
	) faces_xyz;

/* Gets the maximum dimension of the inradius (radius of the sphere tangent to the faces )
 * @uses get_points_center
 * @uses xyz2polar_points
 * @uses polyseed_face_centers
 * @uses array_column
 */
function polyseed_max_inradius( polyseed, center = undef, precision = 14 ) = let(
	points = polyseed[0],
	src_center = is_undef( center ) ? get_points_center( points, "avg" ): center,
	centers_p = xyz2polar_points(
		polyseed_face_centers( polyseed, src_center, precision = precision ), center = src_center,
            precision = precision ),
	max_r = max( array_column( centers_p, 0 ) )
	) max_r;

/* Gets the minimum dimension of the inradius (radius of the sphere tangent to the faces )
 * @uses get_points_center
 * @uses xyz2polar_points
 * @uses polyseed_face_centers
 * @uses array_column
 */
function polyseed_min_inradius( polyseed, center = undef, precision = 14 ) = let(
	points = polyseed[0],
	src_center = is_undef( center ) ? get_points_center( points, "avg" ): center,
	centers_p = xyz2polar_points(
		polyseed_face_centers( polyseed, src_center, precision ), center = src_center,
        precision = precision ),
	min_r = min( array_column( centers_p, 0 ) )
	) min_r;

/* Returns the height of a regular antiprism
 */
function regular_antiprism_height( n = 5, r = 1 ) =
    r * 2 * sqrt( ( cos( 180 / n ) - cos( 360 / n ) ) / 2 );

/* Returns the height of a regular trapezohedron
 * @uses polygon_apothem
 * @uses regular_antiprism_height 
 */
function regular_trapezohedron_height( n = 5, r = 1 ) = let(
    apothem = polygon_apothem( n = n, r = r ),
    delta = r - apothem, 
    antiprism_h = regular_antiprism_height( n = n, r = r ),
    ratio = antiprism_h / delta )
    ( 2 * apothem * ratio ) + antiprism_h;

// Rhombic dodecahedron
function rhombic_dodecahedron_seed( r = 1 ) = let(
    rhombic_dodecahedron_radius_factor = 2,
    rhombic_dodecahedron_points = [
        [0, 0, 2],
        [1, 1, 1], [1, -1, 1], [-1, -1, 1], [-1, 1, 1],
        [2, 0, 0], [0, 2, 0], [-2, 0, 0], [0, -2, 0], 
        [1, 1, -1], [1, -1, -1], [-1, -1, -1], [-1, 1, -1],
        [0, 0, -2]
    ] * r / rhombic_dodecahedron_radius_factor,
    rhombic_dodecahedron_faces = [
        [0, 1, 5, 2], [0, 2, 8, 3], [0, 3, 7, 4], [0, 4, 6, 1],
        [1, 6, 9, 5], [2, 5, 10, 8], [3, 8, 11, 7], [4, 7, 12, 6],
        [6, 12, 13, 9], [5, 9, 13, 10], [8, 10, 13, 11], [7, 11, 13, 12]
    ] ) [ rhombic_dodecahedron_points, rhombic_dodecahedron_faces ];

/* Rhombic triacontrahedron
 * Thanks to http://dmccooey.com
 */
function rhombic_triacontahedron_seed( r = 1 ) = let(
    rhombic_triacontahedron_radius_factor = 1.7204774005889669227590119773848,
    C0 = 0.559016994374947424102293417183, // sqrt(5) / 4
    C1 = 0.904508497187473712051146708591, // (5 + sqrt(5)) / 8
    C2 = 1.46352549156242113615344012577, // (5 + 3 * sqrt(5)) / 8
    rhombic_triacontahedron_points = [
        [ 0,  C0,  C2 ], [ C1, 0,  C2 ], [ 0, -C0,  C2 ], [ -C1, 0, C2 ], 
        [ 0,  C2, C1 ], [ C1,  C1, C1 ], [  C1, -C1, C1 ],
        [ 0, -C2, C1 ], [-C1, -C1, C1 ], [ -C1,  C1, C1 ],
        [ C2, 0,  C0 ],	 [ -C2, 0,  C0 ], 
        [ C0,  C2, 0 ], [ C2,  C1, 0 ], [ C2, -C1, 0 ], [ C0, -C2, 0 ],
        [ -C0, -C2, 0 ], [ -C2, -C1, 0 ],  [ -C2,  C1, 0 ],  [ -C0,  C2, 0], 
        [ C2, 0, -C0 ], [ -C2, 0, -C0 ],
        [ 0,  C2, -C1 ], [ C1,  C1, -C1 ], [  C1, -C1, -C1 ],
        [ 0, -C2, -C1 ], [-C1, -C1, -C1 ], [ -C1,  C1, -C1 ],
        [ 0,  C0, -C2 ], [ C1, 0, -C2 ], [0, -C0, -C2 ], [ -C1, 0, -C2 ]
    ] * r / rhombic_triacontahedron_radius_factor, 
    rhombic_triacontahedron_faces = [
        [ 0, 1, 2, 3], 
        [ 0, 4, 5, 1 ], [ 2, 1, 6, 7 ], [ 3, 2, 7, 8 ], [ 0, 3, 9, 4 ],
        [ 5, 4, 12, 13 ], [ 1, 5, 13, 10 ], [ 1, 10, 14, 6 ], [ 7, 6, 14, 15 ],
        [ 8, 7, 16, 17 ], [ 3, 8, 17, 11 ], [ 3, 11, 18, 9], [ 4, 9, 18, 19 ], 
        [ 4, 19, 22, 12], [ 13, 12, 22, 23 ], [ 10, 13, 20, 14 ], [ 15, 14, 24, 25 ], 
        [ 7, 15, 25, 16 ], [ 16, 25, 26, 17 ], [ 11, 17, 21, 18 ], [ 19, 18, 27, 22 ],
        [ 23, 22, 28, 29 ], [ 13, 23, 29, 20 ], [ 14, 20, 29, 24 ], [ 25, 24, 29, 30 ],
        [ 26, 25, 30, 31 ], [ 21, 17, 26, 31 ], [ 18, 21, 31, 27 ], [ 22, 27, 31, 28 ], 
        [ 31, 30, 29, 28 ]
    ] ) [ rhombic_triacontahedron_points, rhombic_triacontahedron_faces ];

/* Rotates a polyhedron seed
 * @uses get_points_center
 * @uses vec2vec3
 * @uses rotate_xyz_points
 * @uses rotate_zyx_points
 */
function rotate_polyseed( polyseed, a = 0, center = undef, zyx = true, precision = 14  ) = let(
    points = polyseed[0], faces = polyseed[1],
    src_center = is_undef( center ) ?
        vector_round_dec( get_points_center( points, "avg" ), precision = precision )  : center,
    angle = !is_list( a ) ? [0, 0, a] : vec2vec3( a, 0, 0 ),
    new_points = zyx ? rotate_zyx_points( points, angle = angle, center = src_center ) :
        rotate_xyz_points( points, angle = angle, center = src_center )
    ) [ new_points, faces ];

/* Rotates a vec2 of point coordinates the given number of degrees along the x axis,
 * rendering a vec3
 * @uses vec2vec3
 * @uses vector_round_dec    
 */
function rotate_x_point( point, a, center = [0, 0, 0], precision = 14 ) = let(
    center_ok = vec2vec3( center, 0, 0 ),
    delta = point - center_ok, 
    delta_r = [ delta[0], ( delta[1] * cos( -a ) ) + ( delta[2] * sin( -a ) ),
        ( -sin( -a ) * delta[1] ) + ( cos( -a ) * delta[2] ) ],
    rotated_xyz = delta_r + center_ok,
    rotated_xyz_ok = vector_round_dec( rotated_xyz, precision = precision )
    ) 0 == a ? point : rotated_xyz_ok;

/* Rotates a vec3 around x, y, z axes (in this order) the designed amount of degrees
 * @uses rotate_x_point
 * @uses rotate_y_point
 * @uses rotate_z_point
 * @uses vec2vec3
 */
function rotate_xyz_point( point, angle = [0, 0, 0], center = [0, 0, 0], precision = 14 ) = let(
    angle_ok = vec2vec3( angle, 0, 0 ), center_ok = vec2vec3( center, 0, 0 ),
    xa = angle_ok[0], ya = angle_ok[1], za = angle_ok[2]
    )
    rotate_z_point(
        rotate_y_point(
            rotate_x_point( point, xa, center_ok, precision = precision ),
            ya, center_ok, precision = precision ),
        za, center_ok, precision = precision );

/* Rotates a series of vec3 around x, y, z axes (in this order) the designed amount of degrees
 * @uses get_points_center
 * @uses vec2vec3
 * @uses rotate_xyz_point
 */
function rotate_xyz_points( points, angle = [0, 0, 0], center = undef, precision = 14 ) = let( 
    p_num = len( points ),
    center_ok = is_undef( center ) ?
        vector_round_dec( vec2vec3( get_points_center( points, "avg" ), 0, 0 ),
            precision = precision ) :
        center,
    angle_ok = vec2vec3( angle , 0, 0 )
    )
    [for (i = [0: p_num -1]) rotate_xyz_point( points[i], angle_ok, center_ok, 
        precision = precision ) ];

/* Rotates a vec2 of point coordinates the given number of degrees along the y axis,
 * rendering a vec3
 * @uses vec2vec3
 * @uses vector_round_dec
 */
function rotate_y_point( point, a, center = [0, 0, 0], precision = 14 ) = let(
    center_ok = vec2vec3( center, 0, 0 ),
    delta = point - center_ok, 
    delta_r = [ ( delta[0] * cos( -a ) ) + ( -sin( -a ) * delta[2]), delta[1],
        (sin( -a ) * delta[0]) + ( delta[2] * cos( -a ) )],
    rotated_xyz = delta_r + center_ok,
    rotated_xyz_ok = vector_round_dec( rotated_xyz, precision = precision )
    ) 0 == a ? point : rotated_xyz_ok;

/* Rotates a vec2 or vec3 of point coordinates the given number of degrees along the z axis,
 * rendering a vec3.
 * @uses vec2vec3
 * @uses vector_round_dec    
 */		
function rotate_z_point( point, a, center = [0, 0, 0], precision = 14  ) = let(
    center_ok = vec2vec3( center, 0, 0 ),
    delta = point - center_ok, 
    delta_r = [ ( cos( -a ) * delta[0] ) + ( sin( -a ) * delta[1] ), 
        ( -sin( -a ) * delta[0] ) + ( cos( -a ) * delta[1] ), delta[2] ],
    rotated_xyz = delta_r + center_ok,
    rotated_xyz_ok = vector_round_dec( rotated_xyz, precision = precision )
    ) 0 == a ? point : rotated_xyz_ok;

/* Rotates a vec3 around x, y, z axes (in reverse order) the designed amount of degrees
 * @uses rotate_x_point
 * @uses rotate_y_point
 * @uses rotate_z_point
 * @uses vec2vec3
 */
function rotate_zyx_point( point, angle = [0, 0, 0], center = [0, 0, 0], precision = 14 ) = let(
    angle_ok = vec2vec3( angle, 0, 0 ), center_ok = vec2vec3( center, 0, 0 ),
    xa = angle_ok[0], ya = angle_ok[1], za = angle_ok[2]
    )
    rotate_x_point(
        rotate_y_point(
            rotate_z_point( point, za, center_ok, precision = precision ),
            ya, center_ok, precision = precision ),
        xa, center_ok, precision = precision );

/* Rotates a series of vec3 around x, y, z axes (in reverse order) the designed amount of degrees
 * @uses get_points_center
 * @uses vec2vec3
 * @uses vector_round_dec 
 * @uses rotate_xyz_point
 */
function rotate_zyx_points( points, angle = [0, 0, 0], center = undef, precision = 14 ) = let( 
    p_num = len( points ),
    center_ok = is_undef( center ) ?
        vector_round_dec( vec2vec3( get_points_center( points, "avg" ), 0, 0 ), precision ) :
        center,
    angle_ok = vec2vec3( angle , 0, 0 )
    )
    [for (i = [0: p_num -1]) rotate_zyx_point( points[i], angle_ok, center_ok,
        precision = precision ) ];

/* Rounds to a given number of decimals.
 */
function round_dec( value, precision = 14, direction = 0 ) = let( precision_ok =
    is_undef( precision ) ? 14 : max( precision, 0 ),
    min_values = [
	1, 1e-1, 1e-2, 1e-3, 1e-4, 1e-5, 1e-6, 1e-7, 1e-8, 1e-9,
	1e-10, 1e-11, 1e-12, 1e-13, 1e-14, 1e-15, 1e-16, 1e-17, 1e-18, 1e-19,
	1e-20, 1e-21, 1e-22, 1e-23, 1e-24, 1e-25, 1e-26, 1e-27, 1e-28, 1e-29,
	1e-30, 1e-31, 1e-32, 1e-33, 1e-34, 1e-35, 1e-36, 1e-37, 1e-38, 1e-39,
	1e-40, 1e-41, 1e-42, 1e-43, 1e-44, 1e-45, 1e-46, 1e-47, 1e-48, 1e-49,
	1e-50, 1e-51, 1e-52, 1e-53, 1e-54, 1e-55, 1e-56, 1e-57, 1e-58, 1e-59,
	1e-60, 1e-61, 1e-62, 1e-63, 1e-64, 1e-65, 1e-66, 1e-67, 1e-68, 1e-69
	],
	max_values = [
	1, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8, 1e9,
	1e10, 1e11, 1e12, 1e13, 1e14, 1e15, 1e16, 1e17, 1e18, 1e19,
	1e20, 1e21, 1e22, 1e23, 1e24, 1e25, 1e26, 1e27, 1e28, 1e29,
	1e30, 1e31, 1e32, 1e33, 1e34, 1e35, 1e36, 1e37, 1e38, 1e39,
	1e40, 1e41, 1e42, 1e43, 1e44, 1e45, 1e46, 1e47, 1e48, 1e49,
	1e50, 1e51, 1e52, 1e53, 1e54, 1e55, 1e56, 1e57, 1e58, 1e59,
	1e60, 1e61, 1e62, 1e63, 1e64, 1e65, 1e66, 1e67, 1e68, 1e69
    ] )
     1 == direction ? min_values[ precision_ok ] *  ceil( max_values[ precision_ok ] * value ) :
    -1 == direction ? min_values[ precision_ok ] * floor( max_values[ precision_ok ] * value ) :
    min_values[ precision_ok ] * round( max_values[ precision_ok ] * value );

// Tetrahedron definition	
function tetrahedron_seed( r = 1 ) = let(
    tetrahedron_radius_factor = 1.4142135623730950488016887242097, // Square root of 2
    tetrahedron_points =[[1, 1, 1], [-1, -1, 1], [-1, 1, -1], [1, -1, -1]] * r /
        tetrahedron_radius_factor,
    tetrahedron_faces = [[1, 0, 3], [0, 1, 2], [0, 2, 3] , [1, 3, 2]]
    ) [tetrahedron_points, tetrahedron_faces];

/* Canonical tetrakis hexahedron
 * Thanks to http://dmccooey.com
 */
function tetrakis_hexahedron_seed( r = 1 ) = let(
    C0 = 1.06066017177982128660126654316, // 3 * sqrt(2) / 4
    C1 = 1.59099025766973192990189981474, // 9 * sqrt(2) / 8
    tetrakis_hexahedron_radius_factor = 1.8371173070873835736479630560341,
    tetrakis_hexahedron_points = [
        [ 0, 0, C1 ],
        [ C0,  C0,  C0 ], [ C0, -C0,  C0 ], [ -C0, -C0, C0 ], [ -C0, C0, C0 ],
        [ 0, C1, 0 ], [ C1, 0, 0 ], [ 0, -C1, 0 ], [ -C1, 0, 0 ],
        [ C0, C0, -C0 ], [ C0, -C0, -C0 ], [ -C0, -C0, -C0 ], [ -C0,  C0, -C0 ],
        [ 0, 0, -C1 ]
    ] * r / tetrakis_hexahedron_radius_factor,
    tetrakis_hexahedron_faces = [
        [ 0, 4, 1 ], [ 0, 1, 2 ], [ 0, 2, 3 ], [ 0, 3, 4 ],
        [ 1, 4, 5 ], [ 2, 1, 6 ], [ 3, 2, 7 ], [ 4, 3, 8 ],
        [ 4, 8, 12 ], [ 4, 12, 5 ], [ 5, 12, 9 ], [ 1, 5, 9 ],
        [ 1, 9, 6 ], [ 6, 9, 10 ], [ 2, 6, 10 ], [ 7, 2, 10 ],
        [ 11, 7, 10 ], [ 3, 7, 11 ], [ 8, 3, 11 ], [ 8, 11, 12 ],
        [ 9, 12, 13 ], [ 10, 9, 13 ], [ 11, 10, 13 ], [ 12, 11, 13 ]
    ] ) [ tetrakis_hexahedron_points, tetrakis_hexahedron_faces ];

/* Transposes a matrix (columns become rows, rows become columns)
 * @uses array_column
 */
function transpose_matrix( arr = undef ) = let(
	vec_len = is_list( arr ) ? len( arr[0]) : undef )
	is_undef( vec_len ) ? [] :
	[ for(i = [0:vec_len -1]) array_column(arr, i)
	];

/* Trapezohedron. It can be viewed as an antibipyramid (gyroelongated pyramid) with coplanar faces
 * (although with edges removed)    
 * @uses regular_trapezohedron_height
 * @uses regular_antiprism_height    
 * @uses vec2vec3_points    
 * @uses ngon_points    
 */    
function trapezohedron_seed( r = 1, n = 5, h = undef, center = true ) = let(
    h_rev = ( is_undef( h ) && n > 8 ) ? 2 * r : h,
    base_height = regular_trapezohedron_height( r = r, n = n ),
    h_ratio = is_undef( h_rev ) ? 1 : h_rev / base_height,
    height = base_height * h_ratio,
    half_height = height / 2,
    belt_height = regular_antiprism_height( r = r, n = n ) * h_ratio,
    mid_belt_height = belt_height / 2,
    north_pole = [ [0, 0, center ? half_height : height] ],
    south_pole = [ [0, 0, center ? -half_height : 0 ] ],
    mid_hi_points = vec2vec3_points(
        ngon_points( r = r, n = n, clockwise = true, rotation = 180 / n ),
        center ? mid_belt_height : half_height + mid_belt_height ),
    mid_lo_points = vec2vec3_points(
        ngon_points( r = r, n = n, clockwise = true ),
        center ? -mid_belt_height : half_height - mid_belt_height ),
    trapezohedron_points = concat( north_pole, mid_hi_points, mid_lo_points, south_pole ),
    first_hi_point = 1, last_hi_point = n,
    first_lo_point = n + 1, last_lo_point = 2 * n,
    north_pole_idx = 0, south_pole_idx = ( 2 * n ) + 1,
    high_faces = [ for( hf = [0 : n - 1] ) let( cur_hi_point = first_hi_point + hf,
        cur_next_hi_point = hf == n - 1 ? first_hi_point : cur_hi_point + 1, 
        cur_lo_point = first_lo_point + hf )
        [ cur_hi_point, cur_lo_point, cur_next_hi_point, north_pole_idx ] ],
    low_faces = [ for( lf = [0: n-1] ) let( cur_hi_point = lf + first_hi_point, 
        cur_prev_lo_point = 0 == lf ? last_lo_point : first_lo_point + lf - 1,
        cur_next_lo_point = first_lo_point + lf )
        [cur_hi_point, cur_prev_lo_point, south_pole_idx, cur_next_lo_point]
    ], trapezohedron_faces = concat( high_faces, low_faces ) 
	)
    [trapezohedron_points, trapezohedron_faces ];

// Truncated octahedron
function truncated_octahedron_seed( r = 1 ) = let(
    truncated_octahedron_radius_factor = 2.2360679774997896964091736687313, // Square root of 5
    truncated_octahedron_points = [ [1, 0, 2], [0, -1, 2], [-1, 0, 2], [0, 1, 2], // Top
        [2, 0, 1], [0, -2, 1], [-2, 0, 1], [0, 2, 1], // Top-middle
        [2, 1, 0], [2, -1, 0], [1, -2, 0], [-1, -2, 0],
        [-2, -1, 0], [-2, 1, 0], [-1, 2, 0], [1, 2, 0],
        [2, 0, -1], [0, -2, -1], [-2, 0, -1], [0, 2, -1], // Bottom-middle
        [1, 0, -2], [0, -1, -2], [-1, 0, -2], [0, 1, -2]
    ] * r / truncated_octahedron_radius_factor,
    truncated_octahedron_faces = [ [0, 1, 2, 3],
        [3, 7, 15, 8, 4, 0], [0, 4, 9, 10, 5, 1], [2, 1, 5, 11, 12, 6], [2, 6, 13, 14, 7, 3],
        [4, 8, 16, 9], [5, 10, 17, 11], [6, 12, 18, 13], [7, 14, 19, 15],
        [8, 15, 19, 23, 20, 16],[10, 9, 16, 20, 21, 17], [12, 11, 17, 21, 22, 18],
        [14, 13, 18, 22, 23, 19], 
        [20, 23, 22, 21]
    ] ) [ truncated_octahedron_points, truncated_octahedron_faces ];

 // Truncated tetrahedron
function truncated_tetrahedron_seed( r = 1 ) = let(
    truncated_tetrahedron_r_factor = 3.3166247903553998491149327366707,
    truncated_tetrahedron_points = [
        [ 1, 1, 3 ], [ -1, -1, 3 ],
		[ 1, 3, 1 ], [ 3, 1, 1 ], [ -1, -3, 1 ], [ -3, -1, 1 ],  
        [ 3, -1, -1 ], [ 1, -3, -1 ], [ -3, 1, -1 ], [ -1, 3, -1],
        [ 1, -1, -3], [ -1, 1, -3]
    ] * r / truncated_tetrahedron_r_factor,
    truncated_tetrahedron_faces = [ 
        [ 0, 2, 3 ], [ 0, 3, 6, 7, 4, 1 ], [ 1, 4, 5 ], [ 0, 1, 5, 8, 9, 2 ], 
        [ 3, 2, 9, 11, 10, 6 ], [ 7, 6, 10 ], [ 4, 7, 10, 11, 8, 5], [ 9, 8, 11]
	] ) [ truncated_tetrahedron_points, truncated_tetrahedron_faces ];

/* Converts a scalar or vector to a vec3, filling the missing dimensions with default values.
 * If there is already a value in that dimension (be it y or z), it's unchanged.
 */
function vec2vec3( vec, z = 0, y = 0 ) = let( len_v = is_list( vec ) ? len( vec ) : 0 )
	0 == len_v ? [ vec, y, z ] :
	1 == len_v ? [ vec[0], y, z] :
	2 == len_v ? [ vec[0], vec[1], z] :
	vec;

/* Converts a matrix of scalars or vectors to a matrix of vec3,
 * filling the missing dims with defaults.
 * @uses vec2vec3
 */
function vec2vec3_points( arr, z = 0, y = 0 ) = let( len_a = len(arr) )
	[for( i = [0:len_a-1]) vec2vec3( arr[i], z = z, y = y )
	];

/* Gets the average value of a vector
 * @uses vector_sum    
 */
function vector_avg( vec ) = vector_sum( vec ) / len( vec );

/* Returns the values and their number of occurences in a vector
 * @uses vector_group_values
 */
function vector_group_totals( vec ) = let(
    grouped_vals = vector_group_values( vec ),
    num_values = len( grouped_vals )
    ) [ for( i = [0 : num_values - 1] ) 
    [ grouped_vals[i][0], len( grouped_vals[i][1] ) ] ];

/* Groups a vector by the values of the elements.
 * Returns an array of vec2 with [value, [element_ids]] form.
 * @uses array_unique
 * @uses array_search
 */
function vector_group_values( vec ) = let( vec_len = len( vec ),
    values = array_unique( vec ),
    num_values = len( values )
    ) [ for( v = [0 : num_values - 1] ) 
        [ values[v], array_search( values[v], vec,  show_all = true ) ] ];

/* Returns the median value of a vector
 * @uses array_sort
 */
function vector_median( vec ) = let( v_len = is_list( vec ) ? len( vec ) : 0,
    v_sorted = array_sort( vec ) )
    0 == v_len ? undef :
	1 == v_len % 2 ? v_sorted[ floor( v_len / 2 ) ] :
	( v_sorted[ ( v_len / 2 ) - 1 ] + v_sorted[ v_len / 2 ] ) / 2;

/* Rounds values in a vector with the given precision
 * @uses round_dec
 */
function vector_round_dec( vec, precision = 15, direction = 0 ) = let(
    vec_len = !is_list( vec ) ? undef : len( vec ) )
	is_undef( vec_len ) ? [] : [for( i = [0:vec_len - 1] ) 
        round_dec( vec[i], precision = precision, direction = direction )
    ];

/* Sums all the elements in a vector
 */
function vector_sum( vec, cur_start = 0, carried_len = undef ) = let(
		v_len = is_undef( carried_len ) ? len(vec) : carried_len )
		cur_start == v_len - 1 ? vec[v_len - 1] : 
		vec[cur_start] + vector_sum(vec, cur_start + 1, v_len);

/* Returns the centroid for a set of 2D points.
 * @uses array_slice    
 * @uses points_signed_area
 * @uses vector_sum
 */
function xy_centroid( points ) = let(
	points_ok = points[0] == points[len(points) -1] ? array_slice( points, 0, -1 ) : points,
	n_points = len( points_ok ),
	signed_area = points_signed_area( points_ok ),
	xy_factors = [ for( i = [0:n_points-1] ) let( next_i = ( i + 1 ) % n_points,
			xi = points_ok[i][0], xi1 = points_ok[next_i][0],
			yi = points_ok[i][1], yi1 = points_ok[next_i][1] )
		( xi * yi1 ) - ( xi1 * yi )
	],
	x_carried_sum = [ for( i = [0:n_points-1] ) let( next_i = ( i + 1 ) % n_points,
			xi = points_ok[i][0], xi1 = points_ok[next_i][0],
			yi = points_ok[i][1], yi1 = points_ok[next_i][1] )
		(xi + xi1) * xy_factors[i]
	],
	y_carried_sum = [ for( i = [0:n_points-1] ) let( next_i = ( i + 1 ) % n_points,
			xi = points_ok[i][0], xi1 = points_ok[next_i][0],
			yi = points_ok[i][1], yi1 = points_ok[next_i][1] )
		( yi + yi1 ) * xy_factors[i]
	],
	ox = vector_sum( x_carried_sum ) / ( 6 * signed_area ),
	oy = vector_sum( y_carried_sum ) / ( 6 * signed_area )
	)
	[ox, oy];

/* Very crude approximation, but good for same-z arrays.
 * @uses vector_median
 * @uses array_column    
 */
function xyz_centroid_z_median( points ) = let(
	xy = xy_centroid( points ),
	z_median = vector_median( array_column( points, 2 ) )
)
 [ xy[0], xy[1], z_median ];

/* Converts a vec3 of x, y, z coordinates to a vec3 of [radius, azimuth, elevation]
 * This order does not follow the ISO convention, but is compatible with xy2polar azimuth angle.
 * You can simply remove the third argument (elevation angle) and have a 2d projection.
 * Note that "north pole" is 90 elevation, and "south pole" is -90 elevation.
 * Whilst "north pole" is 0 inclination, and south pole is 180 inclination.
 * @uses round_dec
 */
function xyz2polar( coords, center = [0, 0, 0], z_default = 0, precision = 15,
    use_inclination = false ) = let(
    xyz = coords - center, 
	x = xyz[0], y = xyz[1], z = is_undef( xyz[2] ) ? z_default : xyz[2],
	r = sqrt( pow( x, 2 ) + pow( y, 2 ) + pow( z, 2 ) ),
	phi = atan2( y, x ),
	theta = atan2( z, sqrt( pow( x, 2 ) + pow( y, 2 ) ) ),
	r_ok = round_dec( r, precision ),
	theta_pre_ok = 0 == r_ok ? 0 : round_dec( theta, precision ),
    theta_ok = use_inclination ? 90 - theta_pre_ok : theta_pre_ok,
	phi_ok = 0 == r_ok || 90 == theta_pre_ok || -90 == theta_pre_ok ? 0 : 
        round_dec( phi, precision )
	) [ r_ok, phi_ok, theta_ok ];

/* Converts a vector of vec3 of x, y, z coordinates to [radius, azimuth, elevation] coordinates
 * @uses vec2vec3
 * @uses get_points_center
 * @uses xyz2polar
 */
function xyz2polar_points( vec, center = undef, z_default = 0, precision = 15,
    use_inclination = false ) = let(
		a_len = len(vec),
		center_ok = vec2vec3( is_undef( center ) ? get_points_center( vec ) : center, z_default, 0 ) )
	[ for( i =[0:a_len - 1] ) xyz2polar( vec[i], center = center_ok, z_default = z_default,
       precision = precision, use_inclination = use_inclination ) ];
    
}
{ /* Custom methods and functions */
/* Independently-corner-rounded or chamfered square
 * @uses arc_points
 * @uses ngon_points
 */
function multi_rounded_square_points( size = [10, 10], corner_r = 5, sides = [1, 1, 1, 1], 
    center = true, fn = 180, pos = [0, 0], limit_corner_r = true ) = let( 
    size_ok = !is_list( size ) ? [size, size] : size,
    sides_ok = !is_list( sides ) ? [sides, sides, sides, sides] :
        4 != len( sides ) ? [for( so = [0:3] ) sides[so % len( sides )] ] :
        sides,
    corner_r_raw = !is_list( corner_r ) ? [corner_r] : corner_r,
    corner_r_ok = limit_corner_r ? [for( cr = [0:3] )
        0 == sides[cr] ? 0 :
        min( corner_r_raw[cr % len( corner_r_raw )], size_ok.x / 2, size_ok.y / 2 ) ] :
        corner_r_raw,
    half_w = size_ok.x / 2, half_d = size_ok.y / 2,
    corners = [ pos + ( center ? [ half_w, half_d] : [size_ok.x, size_ok.y] ),
        pos + ( center ? [ -half_w, half_d] : [0, size_ok.y] ),
        pos + ( center ? [ -half_w, -half_d] : [0, 0] ),
        pos + ( center ? [ half_w, -half_d] : [size_ok.x, 0] ),
    ],
    is_square = ( 0 == corner_r_ok[0] ) && ( 0 == corner_r_ok[1] ) && ( 0 == corner_r_ok[2] )
         && ( 0 == corner_r_ok[3] ),
    is_circle = ( corner_r_ok[0] + corner_r_ok[1] == size_ok.x ) &&
        ( corner_r_ok[2] + corner_r_ok[3] == size_ok.x ) &&
        ( corner_r_ok[0] + corner_r_ok[3] == size_ok.y ) &&
        ( corner_r_ok[1] + corner_r_ok[2] == size_ok.y ) && ( size_ok.x == size_ok.y )
        && ( 1 == sides_ok[0] && 1 == sides_ok[1] && 1 == sides_ok[2] && 1 == sides_ok[3] ),
    is_tall_pill = ( corner_r_ok[0] == corner_r_ok[1] ) && ( corner_r_ok[2] == corner_r_ok[3] ) &&
        ( corner_r_ok[0] == corner_r_ok[2] ) &&
        ( 1 == sides[0] ) && ( 1 == sides[2] ) &&
        ( sides[0] == sides[1] ) && ( sides[2] == sides[3] ) &&
         ( corner_r_ok[0] +  corner_r_ok[1] ) == size_ok.x,
    is_wide_pill = ( corner_r_ok[0] == corner_r_ok[1] ) && ( corner_r_ok[2] == corner_r_ok[3] ) &&
        ( corner_r_ok[0] == corner_r_ok[2] ) &&
        ( 1 == sides[0] ) && ( 1 == sides[2] ) &&
        ( sides[0] == sides[1] ) && ( sides[2] == sides[3] ) &&    
         ( corner_r_ok[0] +  corner_r_ok[1] ) == size_ok.y,
    is_top_headstone = ( 1 == sides[0] ) && ( 1 == sides[1] ) && ( corner_r_ok[0] == corner_r_ok[1] )
        && ( size_ok.x == ( corner_r_ok[0] + corner_r_ok[1] ) ),
    is_bottom_headstone = ( 1 == sides[2] ) && ( 1 == sides[3] ) 
        && ( corner_r_ok[2] == corner_r_ok[3] )
        && ( size_ok.x == ( corner_r_ok[2] + corner_r_ok[3] ) ),
    is_right_headstone = ( 1 == sides[0] ) && ( 1 == sides[3] ) 
        && ( corner_r_ok[0] == corner_r_ok[3] )
        && ( size_ok.y == ( corner_r_ok[0] + corner_r_ok[3] ) ),
    is_left_headstone = ( 1 == sides[1] ) && ( 1 == sides[2] ) 
        && ( corner_r_ok[1] == corner_r_ok[2] )
        && ( size_ok.y == ( corner_r_ok[1] + corner_r_ok[2] ) ),
    angles_4_s = [ ( -1 == sides[0] ? -90 : 0 ), ( -1 == sides[1] ? 0 : 90 ),
        ( -1 == sides[2] ? 90 : 180 ), ( -1 == sides[3] ? 180 : -90 )
    ],
    angles_4_e = [ ( -1 == sides[0] ? -180 : 90 ), ( -1 == sides[1] ? -90 : 180 ),
        ( -1 == sides[2] ? 0 : 270 ), ( -1 == sides[3] ? 90 : 0 )
    ],
    angles_2t_s = [ 0, 180],
    angles_2t_e = [ 180 * sides[0], 360 * sides[2] ],
    angles_2w_s = [ -90, 90 ],
    angles_2w_e = [ -1 == sides[0] ? -270 : 90, -1 == sides[0] ? -90 : 270 ],


    pos4 = [ corners[0] - (-1 == sides_ok[0] ? [0, 0] : [corner_r_ok[0], corner_r_ok[0] ] ),
        corners[1] - (-1 == sides_ok[1] ? [0, 0] : [-corner_r_ok[1], corner_r_ok[1] ] ),
        corners[2] - (-1 == sides_ok[2] ? [0, 0] : [-corner_r_ok[2], -corner_r_ok[2] ] ),
        corners[3] - (-1 == sides_ok[3] ? [0, 0] : [corner_r_ok[3], -corner_r_ok[3] ] )
    ],
    pos2t = [ corners[0] - [half_w, -1 == sides[0] ? 0 : corner_r_ok[0] ],
        corners[3] - [half_w, -1 == sides[3] ? 0 : -corner_r_ok[3] ] ],
    pos2w = [ corners[0] - [(-1 == sides[0] ? 0 : corner_r_ok[0]), half_d ],
        corners[1] - [-1 == sides[1] ? 0 : -corner_r_ok[1], half_d ] ],        
    arc_n = round( fn / 4 ),
    fn2 = round( fn / 2 ),
 

    points = is_square ? corners :
        // Full circle/ngon
        is_circle ? ngon_points( r = corner_r_ok[0], n = fn, 
            pos = pos + ( center ? [0, 0] : [corner_r_ok[0], corner_r_ok[0] ] ) ) :
        // Tall pill (taller than wide)
        is_tall_pill ? [ for( tpa = [0:1] ) each arc_points( n = fn2, r = corner_r_ok[ 1 + tpa],
            a1 = angles_2t_s[tpa], a2 = angles_2t_e[tpa], pos = pos2t[tpa] )
        ] :
        // Wide pill (wider than tall)
        is_wide_pill ? [ for( wpa = [0:1] ) each arc_points( n = fn2, r = corner_r_ok[ wpa],
            a1 = angles_2w_s[wpa], a2 = angles_2w_e[wpa], pos = pos2w[wpa] )
        ] :        
        // Top headstone ( top full rounded )
        is_top_headstone ? concat(
            arc_points( n = fn2, r = corner_r_ok[0], a1 = angles_2t_s[0], a2 = angles_2t_e[0], 
                pos = pos2t[0] ),
            0 == sides[2] ? [corners[2] ] :
                arc_points( n = arc_n, r = corner_r_ok[2], a1 = angles_4_s[2], a2 = angles_4_e[2],
                    pos = pos4[2] ),
            0 == sides[3] ? [corners[3] ] :
                arc_points( n = arc_n, r = corner_r_ok[3], a1 = angles_4_s[3], a2 = angles_4_e[3],
                    pos = pos4[3] )        
        ) :
        // Bottom headstone ( bottom full rounded )
        is_bottom_headstone ? concat(
            0 == sides[0] ? [corners[0] ] :
                arc_points( n = arc_n, r = corner_r_ok[0], a1 = angles_4_s[0], a2 = angles_4_e[0],
                    pos = pos4[0] ),
            0 == sides[1] ? [corners[1] ] :
                arc_points( n = arc_n, r = corner_r_ok[1], a1 = angles_4_s[1], a2 = angles_4_e[1],
                    pos = pos4[1] ),        
            arc_points( n = fn2, r = corner_r_ok[2], a1 = angles_2t_s[1], a2 = angles_2t_e[1], 
                pos = pos2t[1] )
        ) :
        // Right headstone (right full rounded )
        is_right_headstone ? concat(
            arc_points( n = fn2, r = corner_r_ok[0], a1 = angles_2w_s[0], a2 = angles_2w_e[0], 
                pos = pos2w[0] ),
            0 == sides[1] ? [corners[1] ] :
                arc_points( n = arc_n, r = corner_r_ok[1], a1 = angles_4_s[1], a2 = angles_4_e[1],
                    pos = pos4[1] ),
            0 == sides[2] ? [corners[2] ] :
                arc_points( n = arc_n, r = corner_r_ok[2], a1 = angles_4_s[2], a2 = angles_4_e[2],
                    pos = pos4[2] )        
        ) :
        // Left headstone ( left full rounded )
        is_left_headstone ? concat(
            0 == sides[0] ? [corners[0] ] :
                arc_points( n = arc_n, r = corner_r_ok[0], a1 = angles_4_s[0], a2 = angles_4_e[0],
                    pos = pos4[0] ),
            arc_points( n = fn2, r = corner_r_ok[1], a1 = angles_2w_s[1], a2 = angles_2w_e[1], 
                pos = pos2w[1] ),
            0 == sides[3] ? [corners[3] ] :
                arc_points( n = arc_n, r = corner_r_ok[3], a1 = angles_4_s[3], a2 = angles_4_e[3],
                    pos = pos4[3] )        
        ) :
        // Round/chamfered square.
        [for( rc = [0:3] ) each sides_ok[rc] == 0 ? [ corners[rc] ] :
            arc_points( n = arc_n, r = corner_r_ok[rc],
                a1 =  angles_4_s[rc], a2 = angles_4_e[rc], pos = pos4[rc] )
        ]
    ) points;        
    
    
}

// Main var population

d_clearance = Dice_clearance;
lay_on_flat = Lay_dice_flat;
lay_on_flat_depth = Flat_dice_hole_depth;
tray_floor_thickness = Tray_thickness;
base_floor_thickness = Base_thickness;
precision = Precision;
width = Width;
depth = Depth;
pattern_w  = Width - ( 2 * Width_margin );
pattern_d = Depth - ( 2 * Depth_margin );
pattern_r_w = ( pattern_w / 2  ) * ( 0.5 + ( Pattern_radius_adjustment / 2 ) );
pattern_r_d = ( pattern_d / 2 ) * ( 0.5 + ( Pattern_radius_adjustment / 2 ) ) ;

is_matrix_pattern = 7 == Dice_pattern;
alt_rows = 0 != Dice_matrix_type;
alt_odd_rows = 1 == Dice_matrix_type;
alt_even_rows = 2 == Dice_matrix_type;
alt_row_r_factor = Indented_matrix_row_spacing_adjustment;
cols = Dice_columns;
rows = Dice_rows;
x_step = pattern_w / cols;
y_step = pattern_d / rows;

magnet_n = Magnets;
magnet_d = Magnet_diameter + ( 2 * Magnet_clearance );
magnet_h = Magnet_height + Magnet_clearance;
magnet_pattern_r_x = ( 
    ( ( ( width - magnet_d ) / 2 ) * ( 1 + Magnet_radius_x_adjustment ) )
    - Magnet_width_margin 
);
magnet_pattern_r_y = ( 
    ( ( ( depth - magnet_d ) / 2 ) * ( 1 + Magnet_radius_y_adjustment ) )
    - Magnet_depth_margin 
);
magnet_start_a = Magnet_rotation;
magnet_a_step = 360 / magnet_n;



{ // D4 calculations
    d4_unit = tetrahedron_seed( r = 1 );
    d4_r_ok = ( d4_size + ( 2 * d_clearance ) ) / max( polyseed_edge_lengths( d4_unit ) ); 
    d4_raw = tetrahedron_seed( r = d4_r_ok );
    d4_point_polar = xyz2polar( d4_raw[0][0], use_inclination = true );
    d4_rotation = [0, d4_point_polar[2], d4_point_polar[1] ];       
    d4 = rotate_polyseed( 
                rotate_polyseed( d4_raw, d4_rotation, center = [0, 0, 0], zyx = true ),
            [0, 0, 90], center = [0, 0, 0], zyx = true 
    );
    d4_z = lay_on_flat ? -d4[0][3].z - lay_on_flat_depth : polyseed_min_inradius( d4 ) / 1.5;
}
{ // D6 calculations
    d6_unit = cube_seed( r = 1 );
    d6_r_ok = ( d6_size + ( 2 * d_clearance ) ) / max( polyseed_edge_lengths( d6_unit ) ); 
    d6_raw = cube_seed( r = d6_r_ok );    
    d6_point_polar = xyz2polar(
        lay_on_flat ? 
            get_points_center( polyseed_face_points( d6_raw, 0 ), "avg") : d6_raw[0][0], 
        use_inclination = true );     
    d6_rotation = [0, d6_point_polar[2], d6_point_polar[1] ];    
    d6 = rotate_polyseed( 
        rotate_polyseed( d6_raw, d6_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, lay_on_flat ? 45 : 30], center = [0, 0, 0], zyx = true
    );
    d6_z = lay_on_flat ? d6[0][1].z - lay_on_flat_depth : d6[0][1].z; 
}
{ // D8 calculations
    d8_unit = octahedron_seed( r = 1 );
    d8_r_ok = ( d8_size + ( 2 * d_clearance ) ) / ( 2 * polyseed_max_inradius( d8_unit ) ); 
    d8_raw = octahedron_seed( r = d8_r_ok );    
    d8_point_polar = xyz2polar(
        lay_on_flat ? 
            get_points_center( polyseed_face_points( d8_raw, 0 ), "avg") : d8_raw[0][0], 
        use_inclination = true );     
    d8_rotation = [0, d8_point_polar[2], d8_point_polar[1] ];    
    d8 = rotate_polyseed( 
        rotate_polyseed( d8_raw, d8_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, lay_on_flat ? 90: 45], center = [0, 0, 0], zyx = true
    );
    d8_z = lay_on_flat ? polyseed_min_inradius( d8 ) - lay_on_flat_depth : 
        polyseed_min_inradius( d8 ) / 2.5;      
}
{ // D10 calculations
    d10_unit = trapezohedron_seed( r = 1, n = 5, h = 2 );    
    d10_r_ok = ( d10_size + ( 2 * d_clearance ) ) / ( 2 * polyseed_max_inradius( d10_unit ) );
    d10_raw = trapezohedron_seed( r = d10_r_ok, n = 5, h = 2.5 * d10_r_ok );    
    d10_point_polar = xyz2polar( 
        lay_on_flat ? 
            get_points_center( polyseed_face_points( d10_raw, 0 ), "box") : d10_raw[0][0],
        use_inclination = true );    
    d10_rotation = [0, lay_on_flat ? 47.875 : d10_point_polar[2],
        d10_point_polar[1] + (lay_on_flat ? 36 : 0) ];   
    d10 = rotate_polyseed( 
        rotate_polyseed( d10_raw, d10_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, lay_on_flat ? -32: -18], center = [0, 0, 0], zyx = true
    );
    d10_z = lay_on_flat ? d10[0][5].z - lay_on_flat_depth : 
        polyseed_min_inradius( d10 ) / 2.5;// d10[0][5].z; //          
}
{ // D12 calculations
    d12_unit = dodecahedron_seed( r = 1 );
    d12_r_ok = ( d12_size + ( 2 * d_clearance ) ) / ( 2 * polyseed_max_inradius( d12_unit ) );  
    d12_raw = dodecahedron_seed( r = d12_r_ok );    
    d12_point_polar = xyz2polar( 
        lay_on_flat ? 
            get_points_center( polyseed_face_points( d12_raw, 0 ), "avg") : d12_raw[0][0],
        use_inclination = true );    
    d12_rotation = [0, d12_point_polar[2], d12_point_polar[1] ];    
    d12 = rotate_polyseed( 
        rotate_polyseed( d12_raw, d12_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, lay_on_flat ? -90 : 90], center = [0, 0, 0], zyx = true
    );
    d12_z = lay_on_flat ? polyseed_min_inradius( d12 ) - lay_on_flat_depth : d12[0][6].z;
}
{ // D20 calculations
    d20_unit = icosahedron_seed( r = 1 );
    d20_r_ok = ( d20_size + ( 2 * d_clearance ) ) / ( 2 * polyseed_max_inradius( d20_unit ) );  
    d20_raw = icosahedron_seed( r = d20_r_ok );    
    d20_point_polar = xyz2polar( 
        lay_on_flat ? 
            get_points_center( polyseed_face_points( d20_raw, 0 ), "avg") : d20_raw[0][0],
        use_inclination = true );    
    d20_rotation = [0, d20_point_polar[2], d20_point_polar[1] ];    
    d20 = rotate_polyseed( 
        rotate_polyseed( d20_raw, d20_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, lay_on_flat ? -90 : 90], center = [0, 0, 0], zyx = true
    );
    d20_z = lay_on_flat ? polyseed_min_inradius( d20 ) - lay_on_flat_depth : d20[0][1].z; 
}
{ // Truncated D4 calculations
    d4_tr_unit = truncated_tetrahedron_seed( r = 1 );
    d4_tr_r_ok = ( 
        ( d4_truncated_size + ( 2 * d_clearance ) ) 
        / max( polyseed_edge_lengths( d4_tr_unit ) )
   ); 
    d4_tr_raw = truncated_tetrahedron_seed( r = d4_tr_r_ok );
    d4_tr_point_polar = xyz2polar(
        get_points_center( polyseed_face_points( d4_tr_raw, 0 ), "avg"),
        use_inclination = true );
    d4_tr_rotation = [0, d4_tr_point_polar[2], d4_tr_point_polar[1] ];
    d4_tr = rotate_polyseed( 
        rotate_polyseed( d4_tr_raw, d4_tr_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, 90], center = [0, 0, 0], zyx = true 
    );
    d4_tr_z = lay_on_flat ? -d4_tr[0][7].z - lay_on_flat_depth: -d4_tr[0][3].z;
}
{ // Truncated D8 calculations
    d8_tr_unit = truncated_octahedron_seed( r = 1 );
    d8_tr_r_ok = (
        ( d8_truncated_size + ( 2 * d_clearance ) ) / ( 2 * polyseed_max_inradius( d8_tr_unit ) ) 
    );
    d8_tr_raw = truncated_octahedron_seed( r = d8_tr_r_ok );
    d8_tr_point_polar = xyz2polar(
        get_points_center( polyseed_face_points( d8_tr_raw, lay_on_flat ? 1 : 0 ), "avg"),
        use_inclination = true );  
    d8_tr_rotation = [0, d8_tr_point_polar[2], d8_tr_point_polar[1] ];    
    d8_tr = rotate_polyseed( 
        rotate_polyseed( d8_tr_raw, d8_tr_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, lay_on_flat ? 90 : 45], center = [0, 0, 0], zyx = true
    );
    d8_tr_z = lay_on_flat ? polyseed_min_inradius( d8_tr ) - lay_on_flat_depth : d8_tr[0][5].z;
}
{ // Rhombic d12 calculations
    d12_r_unit = rhombic_dodecahedron_seed( r = 1 );
    d12_r_r_ok = ( 
        ( d12_rhombic_size + ( 2 * d_clearance ) ) / ( 2 * polyseed_min_inradius( d12_r_unit ) ) 
    );
    d12_r_raw = rhombic_dodecahedron_seed( r = d12_r_r_ok );    
    d12_r_point_polar = xyz2polar(
        lay_on_flat ?
            get_points_center( polyseed_face_points( d12_r_raw, 0 ), "avg" ) : d12_r_raw[0][0],
        use_inclination = true );    
    d12_r_rotation = [0, d12_r_point_polar[2], d12_r_point_polar[1] ];    
    d12_r = rotate_polyseed( 
        rotate_polyseed( d12_r_raw, d12_r_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, lay_on_flat ? 0 : 45], center = [0, 0, 0], zyx = true
    );
    d12_r_z = d12_r[0][4].z - ( lay_on_flat ? lay_on_flat_depth : 0 );
}
{ // Deltoidal d24 calculations
    d24_unit = deltoidal_icositetrahedron_seed( r = 1 );
    d24_r_ok = ( 
        ( d24_deltoidal_size + (2 * d_clearance) ) / ( 2 * polyseed_max_inradius( d24_unit ) )
    ); 
    d24_raw = deltoidal_icositetrahedron_seed( r = d24_r_ok );    
    d24_point_polar = xyz2polar( 
        lay_on_flat ?
            get_points_center( polyseed_face_points( d24_raw, 0 ), "avg" ) : d24_raw[0][0],
        use_inclination = true );    
    d24_rotation = [0, d24_point_polar[2], d24_point_polar[1] ];    
    d24 = rotate_polyseed( 
        rotate_polyseed( d24_raw, d24_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, 90], center = [0, 0, 0], zyx = true
    );
    d24_z = lay_on_flat ? polyseed_min_inradius( d24 ) - lay_on_flat_depth : d24[0][1].z;
}
{ // Hexahedral d24 calculations
    d24_h_unit = tetrakis_hexahedron_seed( r = 1 );
    d24_h_r_ok = (
        ( d24_hexahedral_size + ( 2 * d_clearance ) ) / ( 2 * polyseed_max_inradius( d24_h_unit ) )
    );
    d24_h_raw = tetrakis_hexahedron_seed( r = d24_h_r_ok );    
    d24_h_point_polar = xyz2polar( 
        lay_on_flat ?
            [0, 0, 0] : d24_h_raw[0][0],
        use_inclination = true );    
    d24_h_rotation =  [lay_on_flat ? 18.435 : 0, d24_h_point_polar[2], d24_point_polar[1] ];    
    d24_h = rotate_polyseed( 
        rotate_polyseed( d24_h_raw, d24_h_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, lay_on_flat ? 0 : 90], center = [0, 0, 0], zyx = true
    );
    d24_h_z = lay_on_flat ? d24_h[0][4].z - lay_on_flat_depth : d24_h[0][1].z;
}
{ // D30 calculations
    d30_unit = rhombic_triacontahedron_seed( r = 1 );
    d30_r_ok = ( d30_size + ( 2 * d_clearance ) ) / ( 2 * polyseed_max_inradius( d30_unit ) ); 
    d30_raw = rhombic_triacontahedron_seed( r = d30_r_ok );    
    d30_point_polar = xyz2polar(
        lay_on_flat ?
            get_points_center( polyseed_face_points( d30_raw, 0 ), "avg" ) : d30_raw[0][0],
        use_inclination = true );    
    d30_rotation = [0, d30_point_polar[2], d30_point_polar[1] ];    
    d30 = rotate_polyseed( 
        rotate_polyseed( d30_raw, d30_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, 90], center = [0, 0, 0], zyx = true
    );
    d30_z = lay_on_flat ? polyseed_min_inradius( d30 ) - lay_on_flat_depth : d30[0][19].z;         
}
{ // Deltoidal d60 calculations
    d60_unit = deltoidal_hexecontahedron_seed( r = 1 );
    d60_r_ok = (
        ( d60_deltoidal_size + ( 2 * d_clearance ) ) / ( 2 * polyseed_max_inradius( d60_unit ) )
    );
    d60_raw = deltoidal_hexecontahedron_seed( r = d60_r_ok );    
    d60_point_polar = xyz2polar(
        lay_on_flat ?
            get_points_center( polyseed_face_points( d60_raw, 0 ), "avg" ) : d60_raw[0][0],
        use_inclination = true );    
    d60_rotation = [0, d60_point_polar[2], d60_point_polar[1] ];    
    d60 = rotate_polyseed( 
        rotate_polyseed( d60_raw, d60_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, lay_on_flat ? 11.5 : 90], center = [0, 0, 0], zyx = true
    );
    d60_z = lay_on_flat ? polyseed_min_inradius( d60 ) - lay_on_flat_depth : d60[0][9].z; 
}
{ // Dodecahedral d60 calculations
    d60_d_unit = pentakis_dodecahedron_seed( r = 1 );
    d60_d_r_ok = (
        ( d60_dodecahedral_size + ( 2 * d_clearance ) ) 
        / ( 2 * polyseed_max_inradius( d60_d_unit ) ) 
    );
    d60_d_raw = pentakis_dodecahedron_seed( r = d60_d_r_ok );    
    d60_d_point_polar = xyz2polar( 
        lay_on_flat ?
            get_points_center( polyseed_face_points( d60_d_raw, 0 ), "median" ) : d60_d_raw[0][0],
        use_inclination = true );    
    d60_d_rotation = [0, d60_d_point_polar[2] + ( lay_on_flat ? 11.6405 : 0 ),
        d60_d_point_polar[1] ];    
    d60_d = rotate_polyseed( 
        rotate_polyseed( d60_d_raw, d60_d_rotation, center = [0, 0, 0], zyx = true ),
        [0, 0, 90], center = [0, 0, 0], zyx = true
    );
    d60_d_z = lay_on_flat ? polyseed_min_inradius( d60_d ) - lay_on_flat_depth : d60_d[0][5].z;    
}


// Main calcs and main var population
dice_pool = [ d4, d6, d8, d10, d12, d20, d4_tr, d8_tr, d12_r, d24, d24_h, d30, d60, d60_d];
dice_pool_z = [ d4_z, d6_z, d8_z, d10_z, d12_z, d20_z, d4_tr_z, d8_tr_z, d12_r_z, d24_z, d24_h_z,
    d30_z, d60_z, d60_d_z ];
dice_r_pool = [ d4_r_ok, d6_r_ok, d8_r_ok, d10_r_ok, d12_r_ok, d20_r_ok, d4_tr_r_ok, d8_tr_r_ok,
    d12_r_r_ok, d24_r_ok, d24_h_r_ok, d30_r_ok, d60_r_ok, d60_d_r_ok];
dice_face_pool = [ "4", "6", "8", "10", "12", "20", "4", "8", "12", "24", "24", "30", "60", "60"];
// Types of dice, independently of the arrangement.
dice_types = [ dice_pool[ Type_of_die_1 ], dice_pool[ Type_of_die_2 ], dice_pool[ Type_of_die_3 ],
    dice_pool[ Type_of_die_4 ], dice_pool[ Type_of_die_5 ], dice_pool[ Type_of_die_6 ],
    dice_pool[ Type_of_die_7 ], dice_pool[ Type_of_die_8] , dice_pool[ Type_of_die_9 ],
    dice_pool[ Type_of_die_10 ], dice_pool[ Type_of_die_11 ], dice_pool[ Type_of_die_12 ],
    dice_pool[ Type_of_die_13 ], dice_pool[ Type_of_die_14 ] 
];

dice_z_types = [ dice_pool_z[ Type_of_die_1 ], dice_pool_z[ Type_of_die_2 ],
    dice_pool_z[ Type_of_die_3 ], dice_pool_z[ Type_of_die_4 ], dice_pool_z[ Type_of_die_5 ],
    dice_pool_z[ Type_of_die_6 ], dice_pool_z[ Type_of_die_7 ], dice_pool_z[ Type_of_die_8 ],
    dice_pool_z[ Type_of_die_9 ], dice_pool_z[ Type_of_die_10 ], dice_pool_z[ Type_of_die_11 ],
    dice_pool_z[ Type_of_die_12 ], dice_pool_z[ Type_of_die_13 ], dice_pool_z[ Type_of_die_14 ]
];

dice_r_types = [ dice_r_pool[ Type_of_die_1 ], dice_r_pool[ Type_of_die_2 ],
    dice_r_pool[ Type_of_die_3 ], dice_r_pool[ Type_of_die_4 ], dice_r_pool[ Type_of_die_5 ],
    dice_r_pool[ Type_of_die_6 ], dice_r_pool[ Type_of_die_7 ], dice_r_pool[ Type_of_die_8 ],
    dice_r_pool[ Type_of_die_9 ], dice_r_pool[ Type_of_die_10 ], dice_r_pool[ Type_of_die_11 ],
    dice_r_pool[ Type_of_die_12 ], dice_r_pool[ Type_of_die_13 ], dice_r_pool[ Type_of_die_14 ] 
];

dice_faces = [ dice_face_pool[ Type_of_die_1 ], dice_face_pool[ Type_of_die_2 ],
    dice_face_pool[ Type_of_die_3 ], dice_face_pool[ Type_of_die_4 ], 
    dice_face_pool[ Type_of_die_5 ], dice_face_pool[ Type_of_die_6 ], 
    dice_face_pool[ Type_of_die_7 ], dice_face_pool[ Type_of_die_8 ],
    dice_face_pool[ Type_of_die_9 ], dice_face_pool[ Type_of_die_10 ],
    dice_face_pool[ Type_of_die_11 ], dice_face_pool[ Type_of_die_12 ],
    dice_face_pool[ Type_of_die_13 ], dice_face_pool[ Type_of_die_14 ] 
];

// Populate dice array, dice z-coordinate and relative heights.

n_dice = 7 == Dice_pattern ? cols * rows :
    6 == Dice_pattern ? 6 : // Hexagonal pattern of 6   
    5 == Dice_pattern ? 5 : // Square pattern of 5
    4 == Dice_pattern ? 2 : // Line pattern of 2
    3 == Dice_pattern ? 4 : // Square pattern of 4
    2 == Dice_pattern ? 3 : // Triangular pattern of 3
    1 == Dice_pattern ? 7 : // Hexagonal pattern of 1 + 6    
    1; // Single dice

n_dice_types = len( dice_types );
    
dice = [for( d = [0: n_dice-1] ) dice_types[d % n_dice_types] ];    
dice_z = [for( dz = [0: n_dice-1] ) dice_z_types[dz % n_dice_types] ];        

// Get the effective height of the dice for the Prisms of Holding.    
dice_positive_z = [for( dzp = [0:n_dice-1] ) 
    let( cur_z = array_column( dice[dzp][0], 2 ), num_z = len( cur_z ) ) 
    [for( czp = [0:num_z-1] ) if( cur_z[czp] >= 0 ) cur_z[czp] ]
];    
dice_z_max = [for( dzm = [0:n_dice-1] ) max( dice_positive_z[dzm] )];
    
// prism_max_h = ( 33.55 - 9.11 ) * scaling;

// Get the real heights of the dice.
dice_z_coords = [for( dz = [0:n_dice-1] ) 
    array_column( dice[dz][0], 2 )
]; 
dice_h = [for( dh = [0: n_dice-1] ) max( dice_z_coords[dh] ) - min( dice_z_coords[dh] ) ];
dice_tray_h = [for( dth = [0:n_dice-1] ) dice_h[dth] - dice_z_max[dth] - dice_z[dth] ];
dice_prism_h = [for( dph = [0:n_dice-1] ) dice_z_max[dph] + dice_z[dph] ];    
    
tray_h = max( dice_tray_h ) + tray_floor_thickness;
base_h = max( dice_prism_h ) + base_floor_thickness;

echo( str( "Tray is ", tray_h, "mm tall. Base is ", base_h, "mm tall" ) );
echo( str( "Total height: ", tray_h + base_h, "mm" ) );

// Make it so!
if( 1 == Part_type ){ // Bottom part: the Tray of Readiness
    rotate( [0, 0, 180] )
    translate( [0, 0, tray_h] )
    union(){
        difference(){ // Holed tray
            // Main bottom shape
            color( Main_color )
            rotate( [0, 0, Main_rotation] )
            translate( [0, 0, -tray_h] )
            linear_extrude( tray_h, center = false )
                polygon( multi_rounded_square_points( [width, depth], corner_r = corner_r,
                    sides = corner_sides, fn = Precision, limit_corner_r = Limit_corner_radii ) );  
            
            // Die or dice trays
            if( is_matrix_pattern ){
                for( row = [0: rows -1] ){
                    is_odd_row = 1 == row % 2;
                    is_alt_row = (
                        ( is_odd_row && alt_odd_rows ) || ( !is_odd_row && alt_even_rows ) 
                    );
                    cur_cols = cols - ( is_alt_row ? 1 : 0 );
                    cur_y = y_step * ( row - ( ( rows - 1 )/ 2 ) );
                    for( col = [0: cur_cols-1] ){
                        cur_x = x_step * 
                            ( is_alt_row ? 1 + alt_row_r_factor : 1 ) * 
                            ( col - ( ( cur_cols -1 ) / 2 ) );
                        cur_idx = ( row * cols ) + col -
                            ( alt_rows ?
                                ( alt_odd_rows ? floor( row / 2 ) : ceil( row / 2 ) ) :
                            0 ) ;
                        translate( [cur_x, cur_y, dice_z[cur_idx] ] )
                        polyhedron( dice[cur_idx][0], dice[cur_idx][1] );
                    }
                }
            } else if( 6 == Dice_pattern ){ // Hex pattern
                for( die = [0: n_dice -1] ){
                    cur_a = 60 * ( die - 1 );
                    cur_coords = [ 
                        pattern_r_w * cos( cur_a ),
                        pattern_r_d * sin( cur_a ),
                        dice_z[die]
                    ]; 
                    translate( cur_coords )
                    polyhedron( dice[die][0], dice[die][1] );
                }
            } else if( 5 == Dice_pattern ){ // Square 1+4 pattern
                for( die = [0: n_dice -1] ){
                    cur_a = 90 * ( die - 1 );
                    cur_coords = concat( 
                        ( 0 == die ?
                            [0, 0] : 
                            [ pattern_r_w * cos( cur_a ), pattern_r_d * sin( cur_a )] 
                        ),
                        [ dice_z[die] ] 
                    );                       
                    translate( cur_coords )
                    polyhedron( dice[die][0], dice[die][1] );
                }
            } else if( 3 == Dice_pattern ){ // 4-square pattern
                for( die = [0: n_dice -1] ){
                    cur_a = 90 * ( die - 1 );
                    cur_coords = [ 
                        pattern_r_w * cos( cur_a ),
                        pattern_r_d * sin( cur_a ),
                        dice_z[die]
                    ]; 
                    translate( cur_coords )
                    polyhedron( dice[die][0], dice[die][1] );
                }
            } else if( 2 == Dice_pattern ){ // Triangular pattern
                for( die = [0: n_dice -1] ){
                    cur_a = 120 * ( die - 1 );
                    cur_coords = [ 
                        pattern_r_w * cos( cur_a ),
                        pattern_r_d * sin( cur_a ),
                        dice_z[die]
                    ]; 
                    translate( cur_coords )
                    polyhedron( dice[die][0], dice[die][1] );
                }
            } else if( 1 == Dice_pattern ){ // Hexagonal 1+6 pattern
                for( die = [0: n_dice -1] ){
                    cur_a = 60 * ( die - 1 );
                    cur_coords = concat( 
                        ( 0 == die ?
                            [0, 0] : 
                            [ pattern_r_w * cos( cur_a ), pattern_r_d * sin( cur_a )] 
                        ),
                        [ dice_z[die] ] 
                    );                       
                    translate( cur_coords )
                    polyhedron( dice[die][0], dice[die][1] );
                }
            } else { // Fallback, case 0: single dice pattern
                die = 0;
                translate( [0, 0, dice_z[die] ] )
                    polyhedron( dice[die][0], dice[die][1] );
            }  
            if( magnet_n > 0 ){ // Magnets
                for( m = [0:magnet_n - 1 ]){
                    cur_a = ( magnet_a_step * m ) + magnet_start_a;
                    translate( [ 
                        ( magnet_pattern_r_x * cos( cur_a ) ) - Magnet_x_displacement,
                        ( magnet_pattern_r_y * sin( cur_a ) ) - Magnet_y_displacement,
                        0
                    ] )
                    cylinder( d = magnet_d, h = magnet_h * 2, center = true, $fn = 180 );
                }
            }
        }
        if( $preview ){ // Helper texts
            if( is_matrix_pattern ){
                for( row = [0: rows -1] ){
                    is_odd_row = 1 == row % 2;
                    is_alt_row = (
                        ( is_odd_row && alt_odd_rows ) || ( !is_odd_row && alt_even_rows ) 
                    );
                   cur_cols = cols - ( is_alt_row ? 1 : 0 );
                    cur_y = y_step * ( row - ( ( rows - 1 )/ 2 ) );
                    for( col = [0: cur_cols-1] ){
                        cur_x = x_step * 
                            ( is_alt_row ? 1 + alt_row_r_factor : 1 ) * 
                            ( col - ( ( cur_cols -1 ) / 2 ) );
                        cur_idx = ( row * cols ) + col -
                            ( alt_rows ?
                                ( alt_odd_rows ? floor( row / 2 ) : ceil( row / 2 ) ) :
                            0 ) ;
                        color( "silver", 0.5 ) translate( [cur_x, cur_y, 0.5 ] )
                        rotate( [0, 0, 180] )
                        linear_extrude( 0.2, center = true )
                        text( dice_faces[cur_idx % n_dice_types],
                            size = dice_r_types[cur_idx % n_dice_types] * 0.875,
                            font = Text_font, halign ="center", valign = "center" );
                    }
                }                
            } else if( 6 == Dice_pattern ){ // Hex 6-pattern
                for( die = [0: n_dice -1] ){
                    cur_a = 60 * ( die - 1 );
                    cur_coords = [ pattern_r_w * cos( cur_a ), pattern_r_d * sin( cur_a ), 0.5 ]; 
                    color( "silver", 0.5 )
                    translate( cur_coords )
                    rotate( [0, 0, 180] )
                    linear_extrude( 0.2, center = true )
                    text( str( len( dice[die][1] )), size = dice_r_types[die] * 0.875,
                    font = Text_font, halign ="center", valign = "center" );
                }
            } else if( 5 == Dice_pattern ){ // Square 1+4 pattern
                for( die = [0: n_dice -1] ){
                    cur_a = 90 * ( die - 1 );
                    cur_coords = concat( 
                        ( 0 == die ?
                            [0, 0] : 
                            [ pattern_r_w * cos( cur_a ), pattern_r_d * sin( cur_a )] 
                        ),
                        [ 0.5 ] 
                    );    
                    color( "silver", 0.5 )
                    translate( cur_coords )
                    rotate( [0, 0, 180] )
                    linear_extrude( 0.2, center = true )
                    text( dice_faces[die], size = dice_r_types[die] * 0.875,
                    font = Text_font, halign ="center", valign = "center" );
                }
            } else if( 3 == Dice_pattern ){ // Square 4-pattern
                for( die = [0: n_dice -1] ){
                    cur_a = 90 * ( die - 1 );
                    cur_coords = [ pattern_r_w * cos( cur_a ), pattern_r_d * sin( cur_a ), 0.5 ]; 
                    color( "silver", 0.5 )
                    translate( cur_coords )
                    rotate( [0, 0, 180] )
                    linear_extrude( 0.2, center = true )
                    text( dice_faces[die], size = dice_r_types[die] * 0.875,
                    font = Text_font, halign ="center", valign = "center" );
                }
            } else if( 2 == Dice_pattern ){ // Triangular 3-pattern
                for( die = [0: n_dice -1] ){
                    cur_a = 120 * ( die - 1 );
                    cur_coords = [ pattern_r_w * cos( cur_a ), pattern_r_d * sin( cur_a ), 0.5 ]; 
                    color( "silver", 0.5 )
                    translate( cur_coords )
                    rotate( [0, 0, 180] )
                    linear_extrude( 0.2, center = true )
                    text( dice_faces[die], size = dice_r_types[die] * 0.875,
                    font = Text_font, halign ="center", valign = "center" );
                }
            } else if( 1 == Dice_pattern ){ // Hexagonal 1+6 pattern
                for( die = [0: n_dice -1] ){
                    cur_a = 60 * ( die - 1 );
                    cur_coords = concat( 
                        ( 0 == die ?
                            [0, 0] : 
                            [ pattern_r_w * cos( cur_a ), pattern_r_d * sin( cur_a )] 
                        ),
                        [ 0.5 ] 
                    );    
                    color( "silver", 0.5 )
                    translate( cur_coords )
                    rotate( [0, 0, 180] )
                    linear_extrude( 0.2, center = true )
                    text( dice_faces[die], size = dice_r_types[die] * 0.875,
                    font = Text_font, halign ="center", valign = "center" );
                }
            } else { // Fallback, case 0: single dice pattern
                die = 0;
                color( "silver", 0.5 ) translate( [0, 0, 0.5 ] )
                rotate( [0, 0, 180] )
                linear_extrude( 0.2, center = true )
                text( dice_faces[die], size = dice_r_types[die] * 0.875,
                    font = Text_font, halign ="center", valign = "center" );
            }
        }
    }
} else if( 2 == Part_type ){ // Base part: the Prisms of Holding
    translate( [0,0, base_h] )
    rotate( [180, 0, 0] )
    difference(){ // Shape with prisms
        // Main shape
        color( Main_color )
        rotate( [0, 0, Main_rotation] )
        linear_extrude( base_h, center = false )
        polygon( multi_rounded_square_points( [width, depth], corner_r = corner_r, 
            sides = corner_sides, fn = Precision, limit_corner_r = Limit_corner_radii ) );           
        // Hole diffs
        if( is_matrix_pattern ){
            for( row = [0: rows -1] ){
                is_odd_row = 1 == row % 2;
                is_alt_row = ( ( is_odd_row && alt_odd_rows ) || ( !is_odd_row && alt_even_rows ) );
                cur_cols = cols - ( is_alt_row ? 1 : 0 );
                cur_y = y_step * ( row - ( ( rows - 1 )/ 2 ) );
                for( col = [0: cur_cols-1] ){
                    cur_x = x_step * 
                        ( is_alt_row ? 1 + alt_row_r_factor : 1 ) * 
                        ( col - ( ( cur_cols -1 ) / 2 ) );
                    cur_idx = ( row * cols ) + col -
                        ( alt_rows ?
                            ( alt_odd_rows ? floor( row / 2 ) : ceil( row / 2 ) ) :
                        0 ) ;
                    translate( [cur_x, cur_y, -0.1 ] )
                    linear_extrude( dice_prism_h[cur_idx] + d_clearance + 0.1, 
                        center = false )
                    projection( cut = false ) polyhedron( dice[cur_idx][0], dice[cur_idx][1] );
                    if( Text_depth > 0 ){
                        // Text
                        color( "black") 
                        translate( [cur_x, cur_y, dice_prism_h[cur_idx] + d_clearance] )
                        rotate( [0, 180, 180] )
                        linear_extrude( 2 * Text_depth, center = true )
                        text( dice_faces[cur_idx % n_dice_types ],
                            size = dice_r_types[cur_idx % n_dice_types ] * 0.875,
                            font = Text_font, halign ="center", valign = "center" );
                    }
                }
            }
        } else if( 6 == Dice_pattern ){ // Hex 6-pattern
            for( die = [0: n_dice -1] ){
                cur_a = 60 * ( die - 1 );
                cur_coords = [ pattern_r_w * cos( cur_a ), pattern_r_d * sin( cur_a ), -0.1 ];
                translate( cur_coords )
                union(){
                    linear_extrude( dice_prism_h[die] + d_clearance + 0.1,
                        center = false )
                    projection( cut = false ) polyhedron( dice[die][0], dice[die][1] );
                    if( Text_depth > 0 ){
                        // Text
                        color( "black") 
                        translate( [0, 0, dice_prism_h[die] + d_clearance] )
                        rotate( [0, 180, 180] )
                        linear_extrude( 2 * Text_depth, center = true )
                        text( dice_faces[die], size = dice_r_types[die] * 0.875,
                            font = Text_font, halign ="center", valign = "center" );
                    }
                }
            }            
        } else if( 5 == Dice_pattern ){ // Square 1+4 pattern
            for( die = [0: n_dice -1] ){
                cur_a = 90 * ( die - 1 );
                cur_coords = concat( 
                    ( 0 == die ?
                        [0, 0] : 
                        [ pattern_r_w * cos( cur_a ), pattern_r_d * sin( cur_a )] 
                    ),
                    [ -0.1 ] 
                );
                translate( cur_coords )
                union(){
                    linear_extrude( dice_prism_h[die] + d_clearance + 0.1,
                        center = false )
                    projection( cut = false ) polyhedron( dice[die][0], dice[die][1] );
                    if( Text_depth > 0 ){
                        // Text
                        color( "black") 
                        translate( [0, 0, dice_prism_h[die] + d_clearance] )
                        rotate( [0, 180, 180] )
                        linear_extrude( 2 * Text_depth, center = true )
                        text( dice_faces[die], size = dice_r_types[die] * 0.875,
                            font = Text_font, halign ="center", valign = "center" );
                    }
                }
            }            
        } else if( 3 == Dice_pattern ){ // Square 4-pattern
            for( die = [0: n_dice -1] ){
                cur_a = 90 * ( die - 1 );
                cur_coords = [ pattern_r_w * cos( cur_a ), pattern_r_d * sin( cur_a ), -0.1 ];
                translate( cur_coords )
                union(){
                    linear_extrude( dice_prism_h[die] + d_clearance + 0.1,
                        center = false )
                    projection( cut = false ) polyhedron( dice[die][0], dice[die][1] );
                    if( Text_depth > 0 ){
                        // Text
                        color( "black") 
                        translate( [0, 0, dice_prism_h[die] + d_clearance] )
                        rotate( [0, 180, 180] )
                        linear_extrude( 2 * Text_depth, center = true )
                        text( dice_faces[die], size = dice_r_types[die] * 0.875,
                            font = Text_font, halign ="center", valign = "center" );
                    }
                }
            }            
        } else if( 2 == Dice_pattern ){ // Triangular 3-pattern
            for( die = [0: n_dice -1] ){
                cur_a = 120 * ( die - 1 );
                cur_coords = [ pattern_r_w * cos( cur_a ), pattern_r_d * sin( cur_a ), -0.1 ];
                translate( cur_coords )
                union(){
                    linear_extrude( dice_prism_h[die] + d_clearance + 0.1,
                        center = false )
                    projection( cut = false ) polyhedron( dice[die][0], dice[die][1] );
                    if( Text_depth > 0 ){
                        // Text
                        color( "black") 
                        translate( [0, 0, dice_prism_h[die] + d_clearance] )
                        rotate( [0, 180, 180] )
                        linear_extrude( 2 * Text_depth, center = true )
                        text( dice_faces[die], size = dice_r_types[die] * 0.875,
                            font = Text_font, halign ="center", valign = "center" );
                    }
                }
            }            
        } else if( 1 == Dice_pattern ){ // Hexagonal 1+6 pattern
            for( die = [0: n_dice -1] ){
                cur_a = 60 * ( die - 1 );
                cur_coords = concat( 
                    ( 0 == die ?
                        [0, 0] : 
                        [ pattern_r_w * cos( cur_a ), pattern_r_d * sin( cur_a )] 
                    ),
                    [ -0.1 ] 
                );
                translate( cur_coords )
                union(){
                    linear_extrude( dice_prism_h[die] + d_clearance + 0.1,
                        center = false )
                    projection( cut = false ) polyhedron( dice[die][0], dice[die][1] );
                    if( Text_depth > 0 ){
                        // Text
                        color( "black") 
                        translate( [0, 0, dice_prism_h[die] + d_clearance] )
                        rotate( [0, 180, 180] )
                        linear_extrude( 2 * Text_depth, center = true )
                        text( dice_faces[die], size = dice_r_types[die] * 0.875,
                            font = Text_font, halign ="center", valign = "center" );
                    }
                }
            }            
        } else { // Fallback, case 0: single dice pattern            
            die = 0;
            translate( [0, 0, -0.1] ) 
            linear_extrude( dice_prism_h[die] + d_clearance + 0.1, center = false )
            projection( cut = false ) polyhedron( dice[die][0], dice[die][1] );
            if( Text_depth > 0 ){
                // Text
                color( "black") 
                translate( [0, 0, dice_prism_h[die] + d_clearance] )
                rotate( [0, 180, 180] )
                linear_extrude( 2 * Text_depth, center = true )
                text( dice_faces[die], size = dice_r_types[die] * 0.875,
                    font = Text_font, halign ="center", valign = "center" );
            }
        }
        if( magnet_n > 0 ){ // Magnets
            for( m = [0:magnet_n - 1 ]){
                cur_a = ( magnet_a_step * m ) + magnet_start_a;
                translate( 
                    [ ( magnet_pattern_r_x * cos( cur_a ) ) - Magnet_x_displacement,
                    ( magnet_pattern_r_y * sin( cur_a ) ) - Magnet_y_displacement, 0] )
                cylinder( d = magnet_d, h = magnet_h * 2, center = true, $fn = 180 );
            }
        }        
    }
} else if( 3 == Part_type && magnet_n > 0 ){ // Negative volumes for magnets
    // Positioning fillet
    rotate( [0, 0, Main_rotation] )
    linear_extrude( 0.1, center = false )
    difference(){
        offset( delta = 5.1 )
        polygon( multi_rounded_square_points( [width, depth], corner_r = corner_r,
            sides = corner_sides, fn = Precision, limit_corner_r = Limit_corner_radii ) );          
        offset( delta = 5 )
        polygon( multi_rounded_square_points( [width, depth], corner_r = corner_r,
            sides = corner_sides, fn = Precision, limit_corner_r = Limit_corner_radii ) );     
    }
        // Magnets
        rotate( [0, 0, 180] )
            for( m = [0:magnet_n - 1 ]){
                cur_a = ( magnet_a_step * m ) + magnet_start_a;
                translate( [
                    ( magnet_pattern_r_x * cos( cur_a ) ) - Magnet_x_displacement,
                    ( magnet_pattern_r_y * sin( cur_a ) ) - Magnet_y_displacement,
                    Magnet_embedding_z_height
                ] )
                cylinder( d = magnet_d, h = magnet_h + Magnet_clearance, center = false, $fn = 180 );
            }       
}    

// The End
