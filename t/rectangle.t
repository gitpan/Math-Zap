#_ Rectangle __________________________________________________________
# Test 3d rectangles          
# Perl licence
# PhilipRBrenan@yahoo.com, 2004
#______________________________________________________________________

use Math::Zap::rectangle;
use Math::Zap::vector;
use Test::Simple tests=>3;

my ($a, $b, $c, $d) =
 (vector::new(0,    0, +1),
  vector::new(0, -1.9, -1),
  vector::new(0, -2.0, -1),
  vector::new(0, -2.1, -1)
 );

my $r = rectangle::new
 (vector::new(-1,-1, 0),
  vector::new( 2, 0, 0),
  vector::new( 0, 2, 0)
 );

ok($r->intersects($a, $b) == 1);
ok($r->intersects($a, $c) == 1);
ok($r->intersects($a, $d) == 0);

