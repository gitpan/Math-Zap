=head1 Vector2__________________________________________________________
Manipulate 2D vectors    
    
PhilipRBrenan@yahoo.com, 2004, Perl License

=head2 Synopsis_________________________________________________________
Example t/vector2.t

 #_ Vector _____________________________________________________________
 # Test 2d vectors    
 # philiprbrenan@yahoo.com, 2004, Perl License    
 #______________________________________________________________________
 
 use Math::Zap::Vector2 vector2=>v, units=>u;
 use Test::Simple tests=>7;
 
 my ($x, $y) = u();
 
 ok(!$x                    == 1);
 ok(2*$x+3*$y              == v( 2,  3));
 ok(-$x-$y                 == v(-1, -1));
 ok((2*$x+3*$y) + (-$x-$y) == v( 1,  2));
 ok((2*$x+3*$y) * (-$x-$y) == -5);  
 ok($x*2                   == v( 2,  0));
 ok($y/2                   == v( 0,  0.5));
 

=head2 Description______________________________________________________
Manipulate 2D vectors    
=cut____________________________________________________________________

package Math::Zap::Vector2; 
$VERSION=1.04;
use Math::Trig;
use Carp;
use constant debug => 0; # Debugging level

=head2 Constructors_____________________________________________________
=head3 new______________________________________________________________
Create a vector from numbers
=cut____________________________________________________________________

sub new($$)
 {return bless {x=>$_[0], y=>$_[1]} unless debug;
  my ($x, $y) = @_; 
  round(bless({x=>$x, y=>$y})); 
 }

=head3 vector2__________________________________________________________
Create a vector from numbers - synonym for L</new>
=cut____________________________________________________________________

sub vector2($$) {new($_[0],$_[1])}

=head3 units____________________________________________________________
Unit vectors                                        
=cut____________________________________________________________________

$x = new(1,0);
$y = new(0,1);

sub units() {($x, $y)}

=head2 Methods__________________________________________________________
=head3 check____________________________________________________________
Check its a vector
=cut____________________________________________________________________

sub check(@)
 {if (debug)
   {for my $v(@_)
     {confess "$v is not a vector2" unless ref($v) eq __PACKAGE__;
     }
   }
  return (@_)
 }

=head3 is_______________________________________________________________
Test its a vector
=cut____________________________________________________________________

sub is(@)
 {for my $v(@_)
   {return 0 unless ref($v) eq __PACKAGE__;
   }
  1;
 }

=head3 accuracy_________________________________________________________
Get/Set accuracy for comparisons
=cut____________________________________________________________________

my $accuracy = 1e-10;

sub accuracy
 {return $accuracy unless scalar(@_);
  $accuracy = shift();
 }

=head3 round____________________________________________________________
Round: round to nearest integer if within accuracy of that integer 
=cut____________________________________________________________________

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

=head3 components_______________________________________________________
x,y components of vector
=cut____________________________________________________________________

sub x($) {check(@_) if debug; $_[0]->{x}}
sub y($) {check(@_) if debug; $_[0]->{y}}

=head3 clone____________________________________________________________
Create a vector from another vector
=cut____________________________________________________________________

sub clone($)
 {my ($v) = check(@_); # Vectors
  round bless {x=>$v->x, y=>$v->y}; 
 }

=head3 length___________________________________________________________
Length of a vector
=cut____________________________________________________________________

sub length($)
 {check(@_[0..0]) if debug; # Vectors
  sqrt($_[0]->{x}**2+$_[0]->{y}**2);
 } 

=head3 print____________________________________________________________
Print vector
=cut____________________________________________________________________

sub print($)
 {my ($v) = check(@_); # Vectors
  my ($x, $y) = ($v->x, $v->y);

  "vector2($x, $y)";
 } 

=head3 normalize________________________________________________________
Normalize vector
=cut____________________________________________________________________

sub norm($)
 {my ($v) = check(@_); # Vectors
  my $l = $v->length;

  $l > 0 or confess "Cannot normalize zero length vector $v";

  new($v->x / $l, $v->y / $l);
 }

=head3 rightAngle_______________________________________________________
At right angles
=cut____________________________________________________________________

sub rightAngle($)
 {my ($v) = check(@_); # Vectors
  new(-$v->y, $v->x);
 } 

=head3 dot______________________________________________________________
Dot product
=cut____________________________________________________________________

sub dot($$)
 {my ($a, $b) = check(@_); # Vectors
  $a->x*$b->x+$a->y*$b->y;
 } 

=head3 angle____________________________________________________________
Angle between two vectors
=cut____________________________________________________________________

sub angle($$)
 {my ($a, $b) = check(@_); # Vectors
  acos($a->norm->dot($b->norm));
 } 

=head3 add______________________________________________________________
Add vectors
=cut____________________________________________________________________

sub add($$)
 {my ($a, $b) = check(@_); # Vectors
  new($a->x+$b->x, $a->y+$b->y);
 }

=head3 subtract_________________________________________________________
Subtract vectors
=cut____________________________________________________________________

sub subtract($$)
 {check(@_) if debug; # Vectors
  new($_[0]->{x}-$_[1]->{x}, $_[0]->{y}-$_[1]->{y});
 }

=head3 multiply_________________________________________________________
Vector times a scalar
=cut____________________________________________________________________

sub multiply($$)
 {my ($a) = check(@_[0..0]); # Vector 
  my ($b) =       @_[1..1];  # Scalar
  
  confess "$b is not a scalar" if ref($b);
  new($a->x*$b, $a->y*$b);
 }

=head3 divide___________________________________________________________
Vector divided by a non zero scalar
=cut____________________________________________________________________

sub divide($$)
 {my ($a) = check(@_[0..0]); # Vector 
  my ($b) =       @_[1..1];  # Scalar

  confess "$b is not a scalar" if ref($b);
  confess "$b is zero"         if $b == 0;
  new($a->x/$b, $a->y/$b);
 }

=head3 equals___________________________________________________________
Equals to within accuracy
=cut____________________________________________________________________

sub equals($$)
 {my ($a, $b) = check(@_); # Vectors
  abs($a->x-$b->x) < $accuracy and
  abs($a->y-$b->y) < $accuracy;
 }

=head2 Operators________________________________________________________
# Operator overloads
=cut____________________________________________________________________

use overload
 '+'        => \&add3,      # Add two vectors
 '-'        => \&subtract3, # Subtract one vector from another
 '*'        => \&multiply3, # Times by a scalar, or vector dot product 
 '/'        => \&divide3,   # Divide by a scalar
 '<'        => \&angle3,    # Angle in radians between two vectors
 '>'        => \&angle3,    # Angle in radians between two vectors
 '=='       => \&equals3,   # Equals
 '""'       => \&print3,    # Print
 '!'        => \&length,    # Length
 'fallback' => FALSE;

=head3 add______________________________________________________________
Add operator.
=cut____________________________________________________________________

sub add3
 {my ($a, $b) = @_;
  $a->add($b);
 }

=head3 subtract_________________________________________________________
Subtract operator.
=cut____________________________________________________________________

sub subtract3
 {#my ($a, $b, $c) = @_;
  #return $a->subtract($b) if ref($b);
  return new($_[0]->{x}-$_[1]->{x}, $_[0]->{y}-$_[1]->{y}) if ref($_[1]);
  new(-$_[0]->{x}, -$_[0]->{y});
 }

=head3 multiply_________________________________________________________
Multiply operator.
=cut____________________________________________________________________

sub multiply3
 {my ($a, $b) = @_;
  return $a->dot     ($b) if ref($b);
  return $a->multiply($b);
 }

=head3 divide___________________________________________________________
Divide operator.
=cut____________________________________________________________________

sub divide3
 {my ($a, $b, $c) = @_;
  return $a->divide($b);
 }

=head3 angle____________________________________________________________
Angle between two vectors.
=cut____________________________________________________________________

sub angle3
 {my ($a, $b, $c) = @_;
  return $a->angle($b);
 }

=head3 equals___________________________________________________________
Equals operator.
=cut____________________________________________________________________

sub equals3
 {my ($a, $b, $c) = @_;
  return $a->equals($b);
 }

=head3 print____________________________________________________________
Print a vector.
=cut____________________________________________________________________

sub print3
 {my ($a) = @_;
  return $a->print;
 }

=head2 Exports__________________________________________________________
Export L</vector2>, L</units>, L</check>, L</is>
=cut____________________________________________________________________

use Math::Zap::Exports qw(                               
  vector2 ($$)  
  units   ()
  check   (@)
  is      (@)
 );

#_ Vector2 ____________________________________________________________
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
