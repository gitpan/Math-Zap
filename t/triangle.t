#_ Triangle ___________________________________________________________
# Test 3d triangles    
# Perl licence
# PhilipRBrenan@yahoo.com, 2004
#______________________________________________________________________

use Math::zap::vector;
use Math::zap::vector2;
use Math::zap::triangle;
use Test::Simple tests=>25;
 
$t = triangle::new
 (vector::new( 0,  0,  0), 
  vector::new( 0,  0,  4), 
  vector::new( 4,  0,  0),
 );
 
$u = triangle::new
 (vector::new( 0,  0,  0), 
  vector::new( 0,  1,  4), 
  vector::new( 4,  1,  0),
 );

$T = triangle::new
 (vector::new( 0,  1,  0), 
  vector::new( 0,  1,  1), 
  vector::new( 1,  1,  0),
 );

$c = vector::new(1, 1, 1);

#_ Triangle ___________________________________________________________
# Distance to plane
#______________________________________________________________________

ok($t->distance($c)   == 1, 'Distance to plane');
ok($T->distance($c)   == 0, 'Distance to plane');
ok($t->distance(2*$c) == 2, 'Distance to plane');
ok($t->distanceToPlaneAlongLine(vector::new(0,-1,0), vector::new(0,1,0)) == 1, 'Distance to plane towards a point');
ok($T->distanceToPlaneAlongLine(vector::new(0,-1,0), vector::new(0,1,0)) == 2, 'Distance to plane towards a point');

#_ Triangle ___________________________________________________________
# Permute the points of a triangle
#______________________________________________________________________

ok($t->permute                   == $t, 'Permute 1');
ok($t->permute->permute          == $t, 'Permute 2');
ok($t->permute->permute->permute == $t, 'Permute 3');

#_ Triangle ___________________________________________________________
# Intersection of a line with a plane defined by a triangle
#______________________________________________________________________

#ok($t->intersection($c, vector::new(1,  -1,  1)) == vector::new(1, 0, 1), 'Intersection of line with plane');
#ok($t->intersection($c, vector::new(-1, -1, -1)) == vector::new(0, 0, 0), 'Intersection of line with plane');

#_ Triangle ___________________________________________________________
# Test whether a point is in front or behind a plane relative to another
# point
#______________________________________________________________________
 
ok($t->frontInBehind($c, vector::new(1,  0.5,  1)) == +1, 'Front');
ok($t->frontInBehind($c, vector::new(1,    0,  1)) ==  0, 'In');
ok($t->frontInBehind($c, vector::new(1, -0.5,  1)) == -1, 'Behind');

#_ Triangle ___________________________________________________________
# Parallel
#______________________________________________________________________
 
ok($t->parallel($T) == 1, 'Parallel');
ok($t->parallel($u) == 0, 'Not Parallel');

#_ Triangle ___________________________________________________________
# Coplanar
#______________________________________________________________________
 
#ok($t->coplanar($t) == 1, 'Coplanar');
#ok($t->coplanar($u) == 0, 'Not coplanar');
#ok($t->coplanar($T) == 0, 'Not coplanar');

#_ Triangle ___________________________________________________________
# Project one triangle onto another
#______________________________________________________________________

$p = vector::new(0, 2, 0);
$s = $t->project($T, $p);

ok($s == triangle::new
 (vector::new(0,   0,   2),
  vector::new(0.5, 0,   2),
  vector::new(0,   0.5, 2),
 ), 'Projection of corner 3');

#_ Triangle ___________________________________________________________
# Convert space to plane coordinates and vice versa
#______________________________________________________________________

ok($t->convertSpaceToPlane(vector::new(2, 2, 2))   == vector::new(0.5,0.5,2), 'Space to Plane');
ok($t->convertPlaneToSpace(vector2::new(0.5, 0.5)) == vector::new(2, 0, 2),   'Plane to Space');

#_ Triangle ___________________________________________________________
# Divide 
#______________________________________________________________________

$it = triangle::new          # Intersects t
 (vector::new(  0, -1,  2), 
  vector::new(  0,  2,  2), 
  vector::new(  3,  2,  2),
 );

@d = $t->divide($it);

ok($d[0] == triangle::new(vector::new(0, -1, 2), vector::new(0, 0, 2), vector::new(1, 0, 2)));
ok($d[1] == triangle::new(vector::new(0,  2, 2), vector::new(0, 0, 2), vector::new(1, 0, 2)));
ok($d[2] == triangle::new(vector::new(0,  2, 2), vector::new(1, 0, 2), vector::new(3, 2, 2)));

$it = triangle::new          # Intersects t
 (vector::new(  3,  2,  2),
  vector::new(  0,  2,  2), 
  vector::new(  0, -1,  2), 
 );

@d = $t->divide($it);

ok($d[0] == triangle::new(vector::new(0, -1, 2), vector::new(0, 0, 2), vector::new(1, 0, 2)));
ok($d[1] == triangle::new(vector::new(3,  2, 2), vector::new(1, 0, 2), vector::new(0, 0, 2)));
ok($d[2] == triangle::new(vector::new(3,  2, 2), vector::new(0, 0, 2), vector::new(0, 2, 2)));

$it = triangle::new          # Intersects t
 (vector::new(  3,  2,  2),
  vector::new(  0, -1,  2), 
  vector::new(  0,  2,  2), 
 );

@d = $t->divide($it);

ok($d[0] == triangle::new(vector::new(0, -1, 2), vector::new(1, 0, 2), vector::new(0, 0, 2)));
ok($d[1] == triangle::new(vector::new(3,  2, 2), vector::new(1, 0, 2), vector::new(0, 0, 2)));
ok($d[2] == triangle::new(vector::new(3,  2, 2), vector::new(0, 0, 2), vector::new(0, 2, 2)));
