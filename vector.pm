=head1 Vector__________________________________________________________
Manipulate 3D vectors

PhilipRBrenan@yahoo.com, 2004, Perl licence

=head2 Synopsis_________________________________________________________
Example t/vector.t

 #_ Vector _____________________________________________________________
 # Test 3d vectors    
 # philiprbrenan@yahoo.com, 2004, Perl License    
 #______________________________________________________________________
 
 use Math::Zap::Vector vector=>'v', units=>'u';
 use Test::Simple tests=>7;
 
 my ($x, $y, $z) = u();
 
 ok(!$x                            == 1);
 ok(2*$x+3*$y+4*$z                 == v( 2,  3,   4));
 ok(-$x-$y-$z                      == v(-1, -1,  -1));
 ok((2*$x+3*$y+4*$z) + (-$x-$y-$z) == v( 1,  2,   3));
 ok((2*$x+3*$y+4*$z) * (-$x-$y-$z) == -9);  
 ok($x*2                           == v( 2,  0,   0));
 ok($y/2                           == v( 0,  0.5, 0));
 

=head2 Description______________________________________________________
Manipulate 3 dimensional vectors via operators.
=cut____________________________________________________________________

package Math::Zap::Vector; 
$VERSION=1.03;
use Math::Trig;
use Carp;
use constant debug => 0; # Debugging level

=head3 Constructors____________________________________________________
=head4 new_____________________________________________________________
Create a vector from numbers
=cut___________________________________________________________________

sub new($$$)
 {return round(bless({x=>$_[0], y=>$_[1], z=>$_[2]})) if debug; 
  bless {x=>$_[0], y=>$_[1], z=>$_[2]}; 
 }

sub vector($$$) {new($_[0], $_[1], $_[2])}

=head4 units___________________________________________________________
Unit vectors              
=cut___________________________________________________________________

sub units() {($x, $y, $z)}

=head3 Methods_________________________________________________________
=head4 check___________________________________________________________
Check its a vector
=cut___________________________________________________________________

sub check(@)
 {if (debug)
   {for my $v(@_)
     {confess "$v is not a vector" unless ref($v) eq __PACKAGE__;
     }
   }
  return (@_)
 }

=head4 is______________________________________________________________
Test its a vector
=cut___________________________________________________________________

sub is(@)
 {for my $v(@_)
   {return 0 unless ref($v) eq __PACKAGE__;
   }
  'vector';
 }

=head4 accuracy________________________________________________________
Get/Set accuracy for comparisons
=cut___________________________________________________________________

my $accuracy = 1e-10;

sub accuracy
 {return $accuracy unless scalar(@_);
  $accuracy = shift();
 }

=head4 round___________________________________________________________
Round: round to nearest integer if within accuracy of that integer 
=cut___________________________________________________________________

sub round($)
 {unless (debug)
   {return $_[0];
   }
  else
   {my ($a) = @_;
    for my $k(keys(%$a))
     {my $n = $a->{$k};
      my $N = int($n);
      $a->{$k} = $N if abs($n-$N) < $accuracy;
     }
    return $a;
   }
 }

=head4 x,y,z___________________________________________________________
x,y,z components of vector
=cut___________________________________________________________________

sub x($) {check(@_) if debug; $_[0]->{x}}
sub y($) {check(@_) if debug; $_[0]->{y}}
sub z($) {check(@_) if debug; $_[0]->{z}}

$x = new(1,0,0);
$y = new(0,1,0);
$z = new(0,0,1);

=head4 clone___________________________________________________________
Create a vector from another vector
=cut___________________________________________________________________

sub clone($)
 {my ($v) = check(@_); # Vectors
  round bless {x=>$v->x, y=>$v->y, z=>$v->z}; 
 }

=head4 length__________________________________________________________
Length of a vector
=cut___________________________________________________________________

sub length($)
 {my ($v) = check(@_[0..0]); # Vectors
  sqrt($v->x**2+$v->y**2+$v->z**2);
 } 

=head4 print___________________________________________________________
Print vector
=cut___________________________________________________________________

sub print($)
 {my ($v) = check(@_); # Vectors
  my ($x, $y, $z) = ($v->x, $v->y, $v->z);

  "vector($x, $y, $z)";
 } 

=head4 norm____________________________________________________________
Normalize vector
=cut___________________________________________________________________

sub norm($)
 {my ($v) = check(@_); # Vectors
     $v = $v->clone;   # Copy vector
  my $l = $v->length;

  $l > 0 or confess "Cannot normalize zero length vector $v";

  $v->{x} /= $l;
  $v->{y} /= $l;
  $v->{z} /= $l;
  $v;
 } 

=head4 dot_____________________________________________________________
Dot product
=cut___________________________________________________________________

sub dot($$)
 {my ($a, $b) = check(@_); # Vectors
  $a->x*$b->x+$a->y*$b->y+$a->z*$b->z;
 } 

=head4 angle___________________________________________________________
Angle between two vectors
=cut___________________________________________________________________

sub angle($$)
 {my ($a, $b) = check(@_); # Vectors
  acos($a->norm->dot($b->norm));
 } 

=head4 cross___________________________________________________________
Cross product
=cut___________________________________________________________________

sub cross($$)
 {my ($a, $b) = check(@_); # Vectors

	new
  ((($a->y * $b->z) - ($a->z * $b->y)),
	 (($a->z * $b->x) - ($a->x * $b->z)),
	 (($a->x * $b->y) - ($a->y * $b->x))
  );
 }

=head4 add_____________________________________________________________
Add vectors
=cut___________________________________________________________________

sub add($$)
 {my ($a, $b) = check(@_); # Vectors
  new($a->x+$b->x, $a->y+$b->y, $a->z+$b->z);
 }

=head4 subtract________________________________________________________
Subtract vectors
=cut___________________________________________________________________

sub subtract($$)
 {check(@_) if debug; # Vectors
  new($_[0]->{x}-$_[1]->{x}, $_[0]->{y}-$_[1]->{y}, $_[0]->{z}-$_[1]->{z});
 }

=head4 multiply________________________________________________________
Vector times a scalar
=cut___________________________________________________________________

sub multiply($$)
 {my ($a) = check(@_[0..0]); # Vector 
  my ($b) =       @_[1..1];  # Scalar
  
  confess "$b is not a scalar" if ref($b);
  new($a->x*$b, $a->y*$b, $a->z*$b);
 }

=head4 divide__________________________________________________________
Vector divided by a non zero scalar
=cut___________________________________________________________________

sub divide($$)
 {my ($a) = check(@_[0..0]); # Vector 
  my ($b) =       @_[1..1];  # Scalar

  confess "$b is not a scalar" if ref($b);
  confess "$b is zero"         if $b == 0;
  new($a->x/$b, $a->y/$b, $a->z/$b);
 }

=head4 equals__________________________________________________________
Equals to within accuracy
=cut___________________________________________________________________

sub equals($$)
 {my ($a, $b) = check(@_); # Vectors
  abs($a->x-$b->x) < $accuracy and
  abs($a->y-$b->y) < $accuracy and
  abs($a->z-$b->z) < $accuracy;
 }

=head4 Operator Overloads______________________________________________
Operator overloads
=cut___________________________________________________________________

use overload
 '+'        => \&add3,      # Add two vectors
 '-'        => \&subtract3, # Subtract one vector from another
 '*'        => \&multiply3, # Times by a scalar, or vector dot product 
 '/'        => \&divide3,   # Divide by a scalar
 'x'        => \&cross3,    # BEWARE LOW PRIORITY! Cross product
 '<'        => \&angle3,    # Angle in radians between two vectors
 '>'        => \&angle3,    # Angle in radians between two vectors
 '=='       => \&equals3,   # Equals
 '""'       => \&print3,    # Print
 '!'        => \&length,    # Length
 'fallback' => FALSE;

=head4 Add operator____________________________________________________
Add operator, see L</add>
=cut___________________________________________________________________

sub add3
 {my ($a, $b) = @_;
  $a->add($b);
 }

=head4 Subtract Operator_______________________________________________
Subtract operator.
=cut___________________________________________________________________

sub subtract3
 {return new($_[0]->{x}-$_[1]->{x}, $_[0]->{y}-$_[1]->{y}, $_[0]->{z}-$_[1]->{z}) if ref($_[1]);
  new(-$_[0]->{x}, -$_[0]->{y}, -$_[0]->{z});
 }

=head4 Multiply Operator_______________________________________________
Multiply operator, see L</multiply>
=cut___________________________________________________________________

sub multiply3
 {my ($a, $b) = @_;
  return $a->dot     ($b) if ref($b);
  return $a->multiply($b);
 }

=head4 Divide Operator_________________________________________________
Divide operator, see L</divide>
=cut___________________________________________________________________

sub divide3
 {my ($a, $b, $c) = @_;
  return $a->divide($b);
 }

=head4 Cross Operator__________________________________________________
Cross operator, see L</cross>
=cut___________________________________________________________________

sub cross3
 {my ($a, $b, $c) = @_;
  return $a->cross($b);
 }

=head4 Angle Operator__________________________________________________
Angle operator, see L</angle>
=cut___________________________________________________________________

sub angle3
 {my ($a, $b, $c) = @_;
  return $a->angle($b);
 }

=head4 Equals Operator_________________________________________________
Equals operator, see L</equals>
=cut___________________________________________________________________

sub equals3
 {my ($a, $b, $c) = @_;
  return $a->equals($b);
 }

=head4 Print Operator__________________________________________________
Print a vector, see L</print>
=cut___________________________________________________________________

sub print3
 {my ($a) = @_;
  return $a->print;
 }

=head2 Export Definitions______________________________________________
Export L</vector>, L</units>, L</check>, L</is>
=cut___________________________________________________________________

use Math::Zap::Exports qw(
  vector ($$$)
  units  ()
  check  (@)
  is     (@)
 );

#______________________________________________________________________
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
