#!perl -w
#_ Vector2 ____________________________________________________________
# 2 dimensional vectors: via operator overloading    
# Perl licence
# PhilipRBrenan@yahoo.com, 2004
#______________________________________________________________________

package Math::zap::vector2; 
$VERSION=1.01;

use Math::Trig;
use Carp;
use constant debug => 0; # Debugging level

#_ Vector2 ____________________________________________________________
# Exports
#______________________________________________________________________

require Exporter;
use vars qw( @ISA $VERSION @EXPORT);

@ISA    = qw(Exporter);
@EXPORT = qw(vector2);

#_ Vector2 ____________________________________________________________
# Check its a vector
#______________________________________________________________________

sub check(@)
 {if (debug)
   {for my $v(@_)
     {confess "$v is not a vector2" unless ref($v) eq __PACKAGE__;
     }
   }
  return (@_)
 }

#_ Vector2 ____________________________________________________________
# Test its a vector
#______________________________________________________________________

sub is(@)
 {for my $v(@_)
   {return 0 unless ref($v) eq __PACKAGE__;
   }
  1;
 }

#_ Vector2 ____________________________________________________________
# Get/Set accuracy for comparisons
#______________________________________________________________________

my $accuracy = 1e-10;

sub accuracy
 {return $accuracy unless scalar(@_);
  $accuracy = shift();
 }

#_ Vector2 ____________________________________________________________
# Round: round to nearest integer if within accuracy of that integer 
#______________________________________________________________________

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

#_ Vector2 ____________________________________________________________
# Create a vector from numbers
#______________________________________________________________________

sub new($$)
 {return bless {x=>$_[0], y=>$_[1]} unless debug;
  my ($x, $y) = @_; 
  round bless {x=>$x, y=>$y}; 
 }

sub vector2($$) {new($_[0],$_[1])}

#_ Vector2 ____________________________________________________________
# x,y components of vector
#______________________________________________________________________

$x = new(1,0);
$y = new(0,1);

sub x($) {check(@_) if debug; $_[0]->{x}}
sub y($) {check(@_) if debug; $_[0]->{y}}

sub units() {($x, $y)}

#_ Vector2 ____________________________________________________________
# Create a vector from another vector
#______________________________________________________________________

sub clone($)
 {my ($v) = check(@_); # Vectors
  round bless {x=>$v->x, y=>$v->y}; 
 }

#_ Vector2 ____________________________________________________________
# Length of a vector
#______________________________________________________________________

sub length($)
 {check(@_[0..0]) if debug; # Vectors
  sqrt($_[0]->{x}**2+$_[0]->{y}**2);
 } 

#_ Vector2 ____________________________________________________________
# Print vector
#______________________________________________________________________

sub print($)
 {my ($v) = check(@_); # Vectors
  my ($x, $y) = ($v->x, $v->y);

  "vector2($x, $y)";
 } 

#_ Vector2 ____________________________________________________________
# Normalize vector
#______________________________________________________________________

sub norm($)
 {my ($v) = check(@_); # Vectors
  my $l = $v->length;

  $l > 0 or confess "Cannot normalize zero length vector $v";

  new($v->x / $l, $v->y / $l);
 }

#_ Vector2 ____________________________________________________________
# At right angles
#______________________________________________________________________

sub rightAngle($)
 {my ($v) = check(@_); # Vectors
  new(-$v->y, $v->x);
 } 

#_ Vector2 ____________________________________________________________
# Dot product
#______________________________________________________________________

sub dot($$)
 {my ($a, $b) = check(@_); # Vectors
  $a->x*$b->x+$a->y*$b->y;
 } 

#_ Vector2 ____________________________________________________________
# Angle between two vectors
#______________________________________________________________________

sub angle($$)
 {my ($a, $b) = check(@_); # Vectors
  acos($a->norm->dot($b->norm));
 } 

#_ Vector2 ____________________________________________________________
# Add vectors
#______________________________________________________________________

sub add($$)
 {my ($a, $b) = check(@_); # Vectors
  new($a->x+$b->x, $a->y+$b->y);
 }

#_ Vector2 ____________________________________________________________
# Subtract vectors
#______________________________________________________________________

sub subtract($$)
 {check(@_) if debug; # Vectors
  new($_[0]->{x}-$_[1]->{x}, $_[0]->{y}-$_[1]->{y});
 }

#_ Vector2 ____________________________________________________________
# Vector times a scalar
#______________________________________________________________________

sub multiply($$)
 {my ($a) = check(@_[0..0]); # Vector 
  my ($b) =       @_[1..1];  # Scalar
  
  confess "$b is not a scalar" if ref($b);
  new($a->x*$b, $a->y*$b);
 }

#_ Vector2 ____________________________________________________________
# Vector divided by a non zero scalar
#______________________________________________________________________

sub divide($$)
 {my ($a) = check(@_[0..0]); # Vector 
  my ($b) =       @_[1..1];  # Scalar

  confess "$b is not a scalar" if ref($b);
  confess "$b is zero"         if $b == 0;
  new($a->x/$b, $a->y/$b);
 }

#_ Vector2 ____________________________________________________________
# Equals to within accuracy
#______________________________________________________________________

sub equals($$)
 {my ($a, $b) = check(@_); # Vectors
  abs($a->x-$b->x) < $accuracy and
  abs($a->y-$b->y) < $accuracy;
 }

#_ Vector2 ____________________________________________________________
# Operator overloads
#______________________________________________________________________

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

#_ Vector2 ____________________________________________________________
# Add operator.
#______________________________________________________________________

sub add3
 {my ($a, $b) = @_;
  $a->add($b);
 }

#_ Vector2 ____________________________________________________________
# Subtract operator.
#______________________________________________________________________

sub subtract3
 {#my ($a, $b, $c) = @_;
  #return $a->subtract($b) if ref($b);
  return new($_[0]->{x}-$_[1]->{x}, $_[0]->{y}-$_[1]->{y}) if ref($_[1]);
  new(-$_[0]->{x}, -$_[0]->{y});
 }

#_ Vector2 ____________________________________________________________
# Multiply operator.
#______________________________________________________________________

sub multiply3
 {my ($a, $b) = @_;
  return $a->dot     ($b) if ref($b);
  return $a->multiply($b);
 }

#_ Vector2 ____________________________________________________________
# Divide operator.
#______________________________________________________________________

sub divide3
 {my ($a, $b, $c) = @_;
  return $a->divide($b);
 }

#_ Vector2 ____________________________________________________________
# Angle between two vectors.
#______________________________________________________________________

sub angle3
 {my ($a, $b, $c) = @_;
  return $a->angle($b);
 }

#_ Vector2 ____________________________________________________________
# Equals operator.
#______________________________________________________________________

sub equals3
 {my ($a, $b, $c) = @_;
  return $a->equals($b);
 }

#_ Vector2 ____________________________________________________________
# Print a vector.
#______________________________________________________________________

sub print3
 {my ($a) = @_;
  return $a->print;
 }

#_ Vector2 ____________________________________________________________
# Package loaded successfully
#______________________________________________________________________

1;
