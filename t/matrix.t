#_ Matrix _____________________________________________________________
# Test 3*3 matrices    
# Perl licence
# PhilipRBrenan@yahoo.com, 2004
#______________________________________________________________________

use Math::Zap::matrix;
use Math::Zap::vector;
use Test::Simple tests=>8;

my ($a, $b, $c, $v);

$a = matrix::new
 (8, 0, 0,
  0, 8, 0,
  0, 0, 8
 );

$b = matrix::new
 (4, 2, 0,
  2, 4, 2,
  0, 2, 4
 );

$c = matrix::new
 (4, 2, 1,
  2, 4, 2,
  1, 2, 4
 );

$v = vector::new(1,2,3);

ok($a/$a           == matrix::i);
ok($b/$b           == matrix::i);
ok($c/$c           == matrix::i);
ok(2/$a*$a/2       == matrix::i);
ok(($a+$b)/($a+$b) == matrix::i);
ok(($a-$c)/($a-$c) == matrix::i);
ok(-$a/-$a         == matrix::i);
ok(1/$a*($a*$v)    == $v);

