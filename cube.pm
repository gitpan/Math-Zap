#!perl -w
#_ Cube _______________________________________________________________
# Cubes in 3d space    
# Perl licence
# PhilipRBrenan@yahoo.com, 2004
#______________________________________________________________________

package Math::zap::cube;
$VERSION=1.01;

use Math::zap::unique;
use Math::zap::triangle;
use Math::zap::vector;     
use Carp;

#_ Cube _______________________________________________________________
# Exports 
#______________________________________________________________________

require Exporter;
use vars qw( @ISA $VERSION @EXPORT);

@ISA    = qw(Exporter);
@EXPORT = qw(cube);

#_ Cube _______________________________________________________________
# Check its a cube
#______________________________________________________________________

sub check(@)
 {for my $c(@_)
   {confess "$c is not a cube" unless ref($c) eq __PACKAGE__;
   }
  return (@_)
 }

#_ Cube _______________________________________________________________
# Test its a cube     
#______________________________________________________________________

sub is(@)
 {for my $r(@_)
   {return 0 unless ref($r) eq __PACKAGE__;
   }
  'cube';
 }

#_ Cube _______________________________________________________________
# Create a rectangle from 3 vectors:
# a position of any corner
# x first side
# y second side.
# z third side.
#______________________________________________________________________

sub new($$$$)
 {my ($a, $x, $y, $z) = vector::check(@_);
  bless {a=>$a, x=>$x, y=>$y, z=>$z}; 
 }

sub cube($$$$) {new($_[0], $_[1], $_[2], $_[3])};

#_ Cube _______________________________________________________________
# Components of cube
#______________________________________________________________________

sub a($) {my ($c) = check(@_); $c->{a}}
sub x($) {my ($c) = check(@_); $c->{x}}
sub y($) {my ($c) = check(@_); $c->{y}}
sub z($) {my ($c) = check(@_); $c->{z}}

#_ Cube _______________________________________________________________
# Create a cube from another cube
#______________________________________________________________________

sub clone($)
 {my ($c) = check(@_); # Cube
  bless {a=>$c->a, x=>$c->x, y=>$c->y, z=>$c->z};
 }

#_ Cube _______________________________________________________________
# Get/Set accuracy for comparisons
#______________________________________________________________________

my $accuracy = 1e-10;

sub accuracy
 {return $accuracy unless scalar(@_);
  $accuracy = shift();
 }

#_ Cube _______________________________________________________________
# Unit cube                   
#______________________________________________________________________

sub unit()
 {cube(vector(0,0,0), vector(1,0,0), vector(0,1,0), vector(0,0,1));
 }

#_ Cube _______________________________________________________________
# Add a vector to a cube                   
#______________________________________________________________________

sub add($$)
 {my ($c) =         check(@_[0..0]); # Cube       
  my ($v) = vector::check(@_[1..1]); # Vector     
  new($c->a+$v, $c->x+$v, $c->y+$v, $c->z+$v);                         
 }

#_ Cube _______________________________________________________________
# Subtract a vector from a cube                   
#______________________________________________________________________

sub subtract($$)
 {my ($c) =         check(@_[0..0]); # Cube       
  my ($v) = vector::check(@_[1..1]); # Vector     
  new($c->a-$v, $c->x-$v, $c->y-$v, $c->z-$v);                         
 }

#_ Cube _______________________________________________________________
# Cube times a scalar
#______________________________________________________________________

sub multiply($$)
 {my ($a) = check(@_[0..0]); # Cube   
  my ($b) =       @_[1..1];  # Scalar
  
  new($a->a, $a->x*$b, $a->y*$b, $a->z*$b);
 }

#_ Cube _______________________________________________________________
# Cube divided by a non zero scalar
#______________________________________________________________________

sub divide($$)
 {my ($a) = check(@_[0..0]); # Cube   
  my ($b) =       @_[1..1];  # Scalar
  
  confess "$b is zero" if $b == 0;
  new($a->a, $a->x/$b, $a->y/$b, $a->z/$b);
 }

#_ Cube _______________________________________________________________
# Print cube     
#______________________________________________________________________

sub print($)
 {my ($t) = check(@_); # Cube       
  my ($a, $x, $y, $z) = ($t->a, $t->x, $t->y, $t->z);
  "cube($a, $x, $y, $z)";
 }

#_ Cube _______________________________________________________________
# Triangulate
#______________________________________________________________________

sub triangulate($$)
 {my ($c)     = check(@_[0..0]); # Cube
  my ($color) =       @_[1..1];  # Color           
  my  $plane;                    # Plane    
   
  my @t;
  $plane = unique::new();           
  push @t, {triangle=>triangle($c->a,                   $c->a+$c->x,       $c->a+$c->y),       color=>$color, plane=>$plane};
  push @t, {triangle=>triangle($c->a+$c->x+$c->y,       $c->a+$c->x,       $c->a+$c->y),       color=>$color, plane=>$plane};
  $plane = unique::new();           
  push @t, {triangle=>triangle($c->a+$c->z,             $c->a+$c->x+$c->z, $c->a+$c->y+$c->z), color=>$color, plane=>$plane};
  push @t, {triangle=>triangle($c->a+$c->x+$c->y+$c->z, $c->a+$c->x+$c->z, $c->a+$c->y+$c->z), color=>$color, plane=>$plane};

# x y z 
# y z x
  $plane = unique::new();           
  push @t, {triangle=>triangle($c->a,                   $c->a+$c->y,       $c->a+$c->z),       color=>$color, plane=>$plane};
  push @t, {triangle=>triangle($c->a+$c->y+$c->z,       $c->a+$c->y,       $c->a+$c->z),       color=>$color, plane=>$plane};
  $plane = unique::new();           
  push @t, {triangle=>triangle($c->a+$c->x,             $c->a+$c->y+$c->x, $c->a+$c->z+$c->x), color=>$color, plane=>$plane};
  push @t, {triangle=>triangle($c->a+$c->y+$c->z+$c->x, $c->a+$c->y+$c->x, $c->a+$c->z+$c->x), color=>$color, plane=>$plane};

# x y z 
# z x y
  $plane = unique::new();           
  push @t, {triangle=>triangle($c->a,                   $c->a+$c->z,       $c->a+$c->x),       color=>$color, plane=>$plane};
  push @t, {triangle=>triangle($c->a+$c->z+$c->x,       $c->a+$c->z,       $c->a+$c->x),       color=>$color, plane=>$plane};
  $plane = unique::new();           
  push @t, {triangle=>triangle($c->a+$c->y,             $c->a+$c->z+$c->y, $c->a+$c->x+$c->y), color=>$color, plane=>$plane};
  push @t, {triangle=>triangle($c->a+$c->z+$c->x+$c->y, $c->a+$c->z+$c->y, $c->a+$c->x+$c->y), color=>$color, plane=>$plane};
  @t;
 }

unless (caller())
 {$c = cube(vector(0,0,0), vector(1,0,0), vector(0,1,0), vector(0,0,1));
  @t = $c->triangulate('red');
  print "Done";
 }

#_ Cube _______________________________________________________________
# Operator overloads
#______________________________________________________________________

use overload
 '+',       => \&add3,      # Add a vector
 '-',       => \&sub3,      # Subtract a vector
 '*',       => \&multiply3, # Multiply by scalar
 '/',       => \&divide3,   # Divide by scalar 
 '=='       => \&equals3,   # Equals
 '""'       => \&print3,    # Print
 'fallback' => FALSE;

#_ Cube _______________________________________________________________
# Add operator.
#______________________________________________________________________

sub add3
 {my ($a, $b, $c) = @_;
  return $a->add($b);
 }

#_ Cube _______________________________________________________________
# Subtract operator.
#______________________________________________________________________

sub sub3
 {my ($a, $b, $c) = @_;
  return $a->subtract($b);
 }

#_ Cube _______________________________________________________________
# Multiply operator.
#______________________________________________________________________

sub multiply3
 {my ($a, $b) = @_;
  return $a->multiply($b);
 }

#_ Cube _______________________________________________________________
# Divide operator.
#______________________________________________________________________

sub divide3
 {my ($a, $b, $c) = @_;
  return $a->divide($b);
 }

#_ Cube _______________________________________________________________
# Equals operator.
#______________________________________________________________________

sub equals3
 {my ($a, $b, $c) = @_;
  return $a->equals($b);
 }

#_ Cube _______________________________________________________________
# Print a cube
#______________________________________________________________________

sub print3
 {my ($a) = @_;
  return $a->print;
 }

#_ Cube _______________________________________________________________
# Package loaded successfully
#______________________________________________________________________

1;
