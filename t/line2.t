#_ Vector _____________________________________________________________
# Test 2d lines    
# Perl licence
# PhilipRBrenan@yahoo.com, 2004
#______________________________________________________________________

use Math::zap::line2;
use Math::zap::vector2;
use Test::Simple tests=>12;

my $x = vector2::new(1,0);
my $y = vector2::new(0,1);
my $c = vector2::new(0,0);

my $a = line2::new( -$x,  +$x);
my $b = line2::new( -$y,  +$y);
my $B = line2::new(3*$y, 4*$y);

ok($a->intersect($b) == $c);
ok($b->intersect($a) == $c);
ok($a->intersectWithin($b) == 1);
ok($a->intersectWithin($B) == 0);
ok($b->intersectWithin($a) == 1);
ok($B->intersectWithin($a) == 1);
ok($a->parallel($b) == 0);
ok($B->parallel($b) == 1);
ok(!$b->intersectWithin($B), 'Parallel intersection');
ok( line2::new(-$x,       $x)->crossOver(line2::new(-$y,       $y)), 'Crosses 1');
ok(!line2::new(-$x,       $x)->crossOver(line2::new( $y * 0.5, $y)), 'Crosses 2');
ok(!line2::new( $x * 0.5, $x)->crossOver(line2::new( $y * 0.5, $y)), 'Crosses 3');

