#_ Matrix _____________________________________________________________
# Test 2*2 matrices    
# Perl licence
# PhilipRBrenan@yahoo.com, 2004
#______________________________________________________________________

use Math::Zap::matrix2;
use Math::Zap::vector2;
use Test::Simple tests=>8;

my ($a, $b, $c, $v);

$a = matrix2::new
 (8, 0,
  0, 8,
 );

$b = matrix2::new
 (4, 2,
  2, 4,
 );

$c = matrix2::new
 (2, 2,
  1, 2,
 );

$v = vector2::new(1,2);

ok($a/$a           == matrix2::i);
ok($b/$b           == matrix2::i);
ok($c/$c           == matrix2::i);
ok(2/$a*$a/2       == matrix2::i);
ok(($a+$b)/($a+$b) == matrix2::i);
ok(($a-$c)/($a-$c) == matrix2::i);
ok(-$a/-$a         == matrix2::i);
ok(1/$a*($a*$v)    == $v);

