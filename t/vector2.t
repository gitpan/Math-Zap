#_ Vector _____________________________________________________________
# Test 2d vectors    
# Perl licence
# PhilipRBrenan@yahoo.com, 2004
#______________________________________________________________________

use Math::zap::vector2;
use Test::Simple tests=>7;

my ($x, $y) = vector2::units();

ok(!$x                    == 1);
ok(2*$x+3*$y              == vector2::new( 2,  3));
ok(-$x-$y                 == vector2::new(-1, -1));
ok((2*$x+3*$y) + (-$x-$y) == vector2::new( 1,  2));
ok((2*$x+3*$y) * (-$x-$y) == -5);  
ok($x*2                   == vector2::new( 2,  0));
ok($y/2                   == vector2::new( 0,  0.5));

