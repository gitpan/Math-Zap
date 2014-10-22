=head1 Line2 ___________________________________________________________
Lines in 2d space

PhilipRBrenan@yahoo.com, 2004, Perl License

=head2 Synopsis_________________________________________________________
Example t/line2.t

 #_ Vector _____________________________________________________________
 # Test 2d lines    
 # philiprbrenan@yahoo.com, 2004, Perl License    
 #______________________________________________________________________
 
 use Math::Zap::Line2;
 use Math::Zap::Vector2;
 use Test::Simple tests=>12;
 
 my $x = vector2(1,0);
 my $y = vector2(0,1);
 my $c = vector2(0,0);
 
 my $a = line2( -$x,  +$x);
 my $b = line2( -$y,  +$y);
 my $B = line2(3*$y, 4*$y);
 
 ok($a->intersect($b) == $c);
 ok($b->intersect($a) == $c);
 ok($a->intersectWithin($b) == 1);
 ok($a->intersectWithin($B) == 0);
 ok($b->intersectWithin($a) == 1);
 ok($B->intersectWithin($a) == 1);
 ok($a->parallel($b) == 0);
 ok($B->parallel($b) == 1);
 ok(!$b->intersectWithin($B), 'Parallel intersection');
 ok( line2(-$x,       $x)->crossOver(line2(-$y,       $y)), 'Crosses 1');
 ok(!line2(-$x,       $x)->crossOver(line2( $y * 0.5, $y)), 'Crosses 2');
 ok(!line2( $x * 0.5, $x)->crossOver(line2( $y * 0.5, $y)), 'Crosses 3');
 

=head2 Description______________________________________________________
Manipulate lines in 2D space                                           
=cut____________________________________________________________________

package Math::Zap::Line2;
$VERSION=1.04;
use Math::Zap::Vector2 check=>'vector2Check';
use Math::Zap::Matrix2 new2v=>'matrix2New2v';
use Carp;
use constant debug => 0; # Debugging level

=head2 Constructors_____________________________________________________
=head3 new______________________________________________________________
Create a line from two vectors
=cut____________________________________________________________________

sub new($$)
 {vector2Check(@_) if debug;
  my $l = bless {a=>$_[0], b=>$_[1]};
  short($l, 1);
  $l; 
 }

=head3 line2 ___________________________________________________________
Create a line from two vectors
=cut____________________________________________________________________

sub line2($$) {new($_[0],$_[1])};

=head2 Methods__________________________________________________________
=head3 accuracy_________________________________________________________
Get/Set accuracy for comparisons
=cut____________________________________________________________________

my $accuracy = 1e-10;

sub accuracy
 {return $accuracy unless scalar(@_);
  $accuracy = shift();
 }

=head3 short ___________________________________________________________
Short line?                      
=cut____________________________________________________________________

sub short($$)
 {my $l = shift;  # Line       
  my $a = 1e-4;   # Accuracy
  my $A = shift;  # Action 0: return indicator, 1: confess 
  my $n =
     ($l->{a}{x}-$l->{b}{x})**2 + ($l->{a}{y}-$l->{b}{y})**2                                      
    < $a;
  confess "Short line2" if $n and $A;
  $n;      
 }

=head3 check ___________________________________________________________
Check its a line
=cut____________________________________________________________________

sub check(@)
 {unless (debug)
   {for my $l(@_)
     {confess "$l is not a line" unless ref($l) eq __PACKAGE__;
     }
   }
   @_;
 }

=head3 is_______________________________________________________________
Test its a line
=cut____________________________________________________________________

sub is(@)
 {for my $l(@_)
   {return 0 unless ref($l) eq __PACKAGE__;
   }
  'line2';
 }

=head3 a,b,ab,ba________________________________________________________
Components of line
=cut____________________________________________________________________

sub a($)  {check(@_) if (debug); $_[0]->{a}}
sub b($)  {check(@_) if (debug); $_[0]->{b}}
sub ab($) {check(@_) if (debug); vector2($_[0]->{b}{x}-$_[0]->{a}{x}, $_[0]->{b}{y}-$_[0]->{a}{y})}
sub ba($) {check(@_) if (debug); $_[0]->a-$_[0]->b}

=head3 clone ___________________________________________________________
Create a line from another line
=cut____________________________________________________________________

sub clone($)
 {my ($l) = check(@_); # Lines
  bless {a=>$l->a, b=>$l->b}; 
 }

=head3 print ___________________________________________________________
Print line
=cut____________________________________________________________________

sub print($)
 {my ($l) = check(@_); # Lines
  my ($a, $b) = ($l->a, $l->b);
  my ($A, $B) = ($a->print, $b->print);  
  "line2($A, $B)";
 } 

=head3 angle ___________________________________________________________
Angle between two lines
=cut____________________________________________________________________

sub angle($$)
 {my ($a, $b) = check(@_); # Lines
  $a->a-$a->b < $b->a-$b->b;     
 } 

=head3 parallel_________________________________________________________
Are two lines parallel
=cut____________________________________________________________________

sub parallel($$)
 {my ($a, $b) = check(@_); # Lines

# return 1 if abs(1 - abs($a->ab->norm * $b->ab->norm)) < $accuracy;
  return 1 if abs(1 - abs($a->ab->norm * $b->ab->norm)) < 1e-3;     
  0;
 }

=head3 intersect________________________________________________________
Intersection of two lines
=cut____________________________________________________________________

sub intersect($$)
 {my ($a, $b) = check(@_); # Lines

  return 0 if $a->parallel($b);
  my $i = matrix2New2v($a->ab, $b->ba) / ($b->a - $a->a);

  $a->a+$i->x*$a->ab;
 }

=head3 intersectWithin__________________________________________________
Intersection of two lines occurs within second line?
=cut____________________________________________________________________

sub intersectWithin($$)
 {my ($a, $b) = check(@_); # Lines

  return 0 if $a->parallel($b);
  my $i = matrix2New2v($a->ab, $b->ba) / ($b->a - $a->a);

  0 <= $i->y and $i->y <= 1;
 } 

=head3 crossOver________________________________________________________
Do the two line segments cross over each other?
=cut____________________________________________________________________

sub crossOver($$)
 {my ($a, $b) = check(@_); # Lines

  return 0 if $a->parallel($b);
  my $i = matrix2New2v($a->ab, $b->ba) / ($b->a - $a->a);

  0 <= $i->x and $i->x <= 1 and 0 <= $i->y and $i->y <= 1;
 } 

=head2 Exports__________________________________________________________
Export L</line2>
=cut____________________________________________________________________

use Math::Zap::Exports qw(
  line2  ($$)
 );

#_ Line2 ______________________________________________________________
# Package loaded successfully
#______________________________________________________________________

1;


=head2 Credits

=head3 Author

philiprbrenan@yahoo.com

=head3 Copyright

philiprbrenan@yahoo.com, 2004

=head3 License

Perl License.


=cut
