#_ Unique _____________________________________________________________
# Unique           
# Perl licence
# PhilipRBrenan@yahoo.com, 2004
#______________________________________________________________________

use Math::Zap::unique;
use Math::Zap::triangle;
use Math::Zap::vector;     
use Carp;
use Test::Simple tests=>3;

my $u = unique();         
my $v = unique();         
print "$u $v\n";
ok($u ne '');
ok($v ne '');
ok($u ne $v);

