#_ Vector _____________________________________________________________
# Test 3d vectors    
# Perl licence
# PhilipRBrenan@yahoo.com, 2004
#______________________________________________________________________

use Math::zap::vector;
use Test::Simple tests=>7;

my ($x, $y, $z) = vector::units();

ok(!$x                            == 1);
ok(2*$x+3*$y+4*$z                 == vector::new( 2,  3,   4));
ok(-$x-$y-$z                      == vector::new(-1, -1,  -1));
ok((2*$x+3*$y+4*$z) + (-$x-$y-$z) == vector::new( 1,  2,   3));
ok((2*$x+3*$y+4*$z) * (-$x-$y-$z) == -9);  
ok($x*2                           == vector::new( 2,  0,   0));
ok($y/2                           == vector::new( 0,  0.5, 0));

