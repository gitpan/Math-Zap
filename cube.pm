#!perl -w
=head1 Cube ___________________________________________________________
Cubes in 3d space
    
PhilipRBrenan@yahoo.com, 2004, Perl License

=head2 Synopsis_________________________________________________________
Example t/cube.t

 #_ Cube _______________________________________________________________
 # Test cube      
 # philiprbrenan@yahoo.com, 2004, Perl License    
 #______________________________________________________________________
 
 use Math::Zap::Cube unit=>u;
 use Test::Simple tests=>5;
 
 ok(u    eq 'cube(vector(0, 0, 0), vector(1, 0, 0), vector(0, 1, 0), vector(0, 0, 1))');
 ok(u->a eq 'vector(0, 0, 0)');
 ok(u->x eq 'vector(1, 0, 0)');
 ok(u->y eq 'vector(0, 1, 0)');
 ok(u->z eq 'vector(0, 0, 1)');
 

=head2 Description_____________________________________________________
Define and manipulate a cube in 3 dimensions
=cut____________________________________________________________________

package Math::Zap::Cube;
$VERSION=1.03;
use Math::Zap::Unique;
use Math::Zap::Triangle;
use Math::Zap::Vector check=>vectorCheck;     
use Carp;

=head2 Constructors____________________________________________________
=head3 new_____________________________________________________________
Create a rectangle from 3 vectors:
=over
=item a position of corner
=item x first side
=item y second side
=item z third side
=back
=cut___________________________________________________________________

sub new($$$$)
 {my ($a, $x, $y, $z) = vectorCheck(@_);
  bless {a=>$a, x=>$x, y=>$y, z=>$z}; 
 }

=head3 cube____________________________________________________________
Synonym for L</new>
=cut___________________________________________________________________

sub cube($$$$) {new($_[0], $_[1], $_[2], $_[3])};

=head3 unit____________________________________________________________
Unit cube                   
=cut___________________________________________________________________

sub unit()
 {cube(vector(0,0,0), vector(1,0,0), vector(0,1,0), vector(0,0,1));
 }

=head2 Methods_________________________________________________________
=head3 Check___________________________________________________________
Check that an anonymous reference is a reference to a cube and confess
if it is not.
=cut___________________________________________________________________

sub check(@)
 {for my $c(@_)
   {confess "$c is not a cube" unless ref($c) eq __PACKAGE__;
   }
  return (@_)
 }

=head3 is_______________________________________________________________
Same as L</check> but return the result to the caller.   
=cut____________________________________________________________________

sub is(@)
 {for my $r(@_)
   {return 0 unless ref($r) eq __PACKAGE__;
   }
  'cube';
 }

=head3 a, x, y, z______________________________________________________
Components of cube
=cut___________________________________________________________________

sub a($) {my ($c) = check(@_); $c->{a}}
sub x($) {my ($c) = check(@_); $c->{x}}
sub y($) {my ($c) = check(@_); $c->{y}}
sub z($) {my ($c) = check(@_); $c->{z}}

=head3 Clone___________________________________________________________
Create a cube from another cube
=cut___________________________________________________________________

sub clone($)
 {my ($c) = check(@_); # Cube
  bless {a=>$c->a, x=>$c->x, y=>$c->y, z=>$c->z};
 }

=head3 Accuracy________________________________________________________
Get/Set accuracy for comparisons
=cut___________________________________________________________________

my $accuracy = 1e-10;

sub accuracy
 {return $accuracy unless scalar(@_);
  $accuracy = shift();
 }

=head3 Add_____________________________________________________________
Add a vector to a cube                   
=cut___________________________________________________________________

sub add($$)
 {my ($c) =       check(@_[0..0]); # Cube       
  my ($v) = vectorCheck(@_[1..1]); # Vector     
  new($c->a+$v, $c->x, $c->y, $c->z);                         
 }

=head3 Subtract________________________________________________________
Subtract a vector from a cube                   
=cut___________________________________________________________________

sub subtract($$)
 {my ($c) =       check(@_[0..0]); # Cube       
  my ($v) = vectorCheck(@_[1..1]); # Vector     
  new($c->a-$v, $c->x, $c->y, $c->z);                         
 }

=head3 Multiply________________________________________________________
Cube times a scalar
=cut___________________________________________________________________

sub multiply($$)
 {my ($a) = check(@_[0..0]); # Cube   
  my ($b) =       @_[1..1];  # Scalar
  
  new($a->a, $a->x*$b, $a->y*$b, $a->z*$b);
 }

=head3 Divide__________________________________________________________
Cube divided by a non zero scalar
=cut___________________________________________________________________

sub divide($$)
 {my ($a) = check(@_[0..0]); # Cube   
  my ($b) =       @_[1..1];  # Scalar
  
  confess "$b is zero" if $b == 0;
  new($a->a, $a->x/$b, $a->y/$b, $a->z/$b);
 }

=head3 Print___________________________________________________________
Print cube     
=cut___________________________________________________________________

sub print($)
 {my ($t) = check(@_); # Cube       
  my ($a, $x, $y, $z) = ($t->a, $t->x, $t->y, $t->z);
  "cube($a, $x, $y, $z)";
 }

=head3 Triangulate_____________________________________________________
Triangulate cube
=cut___________________________________________________________________

sub triangulate($$)
 {my ($c)     = check(@_[0..0]); # Cube
  my ($color) =       @_[1..1];  # Color           
  my  $plane;                    # Plane    
   
  my @t;
  $plane = unique();           
  push @t, {triangle=>triangle($c->a,                   $c->a+$c->x,       $c->a+$c->y),       color=>$color, plane=>$plane};
  push @t, {triangle=>triangle($c->a+$c->x+$c->y,       $c->a+$c->x,       $c->a+$c->y),       color=>$color, plane=>$plane};
  $plane = unique();           
  push @t, {triangle=>triangle($c->a+$c->z,             $c->a+$c->x+$c->z, $c->a+$c->y+$c->z), color=>$color, plane=>$plane};
  push @t, {triangle=>triangle($c->a+$c->x+$c->y+$c->z, $c->a+$c->x+$c->z, $c->a+$c->y+$c->z), color=>$color, plane=>$plane};

# x y z 
# y z x
  $plane = unique();           
  push @t, {triangle=>triangle($c->a,                   $c->a+$c->y,       $c->a+$c->z),       color=>$color, plane=>$plane};
  push @t, {triangle=>triangle($c->a+$c->y+$c->z,       $c->a+$c->y,       $c->a+$c->z),       color=>$color, plane=>$plane};
  $plane = unique();           
  push @t, {triangle=>triangle($c->a+$c->x,             $c->a+$c->y+$c->x, $c->a+$c->z+$c->x), color=>$color, plane=>$plane};
  push @t, {triangle=>triangle($c->a+$c->y+$c->z+$c->x, $c->a+$c->y+$c->x, $c->a+$c->z+$c->x), color=>$color, plane=>$plane};

# x y z 
# z x y
  $plane = unique();           
  push @t, {triangle=>triangle($c->a,                   $c->a+$c->z,       $c->a+$c->x),       color=>$color, plane=>$plane};
  push @t, {triangle=>triangle($c->a+$c->z+$c->x,       $c->a+$c->z,       $c->a+$c->x),       color=>$color, plane=>$plane};
  $plane = unique();           
  push @t, {triangle=>triangle($c->a+$c->y,             $c->a+$c->z+$c->y, $c->a+$c->x+$c->y), color=>$color, plane=>$plane};
  push @t, {triangle=>triangle($c->a+$c->z+$c->x+$c->y, $c->a+$c->z+$c->y, $c->a+$c->x+$c->y), color=>$color, plane=>$plane};
  @t;
 }

unless (caller())
 {$c = cube(vector(0,0,0), vector(1,0,0), vector(0,1,0), vector(0,0,1));
  @t = $c->triangulate('red');
  print "Done";
 }

=head2 Operator Overloads______________________________________________
Operator overloads
=cut___________________________________________________________________

use overload
 '+',       => \&add3,      # Add a vector
 '-',       => \&sub3,      # Subtract a vector
 '*',       => \&multiply3, # Multiply by scalar
 '/',       => \&divide3,   # Divide by scalar 
 '=='       => \&equals3,   # Equals
 '""'       => \&print3,    # Print
 'fallback' => FALSE;

=head3 Add_____________________________________________________________
Add operator.
=cut___________________________________________________________________
sub add3
 {my ($a, $b, $c) = @_;
  return $a->add($b);
 }

=head3 Subtract________________________________________________________
Subtract operator.
=cut___________________________________________________________________

sub sub3
 {my ($a, $b, $c) = @_;
  return $a->subtract($b);
 }

=head3 Multiply________________________________________________________
Multiply operator.
=cut___________________________________________________________________

sub multiply3
 {my ($a, $b) = @_;
  return $a->multiply($b);
 }

=head3 Divide__________________________________________________________
Divide operator.
=cut___________________________________________________________________

sub divide3
 {my ($a, $b, $c) = @_;
  return $a->divide($b);
 }

=head3 Equals__________________________________________________________
Equals operator.
=cut___________________________________________________________________

sub equals3
 {my ($a, $b, $c) = @_;
  return $a->equals($b);
 }

=head3 Print___________________________________________________________
Print a cube
=cut___________________________________________________________________

sub print3
 {my ($a) = @_;
  return $a->print;
 }

=head2 Exports__________________________________________________________
Export L</cube>, L</unit>
=cut____________________________________________________________________

use Math::Zap::Exports qw(                               
  cube ($$$)  
  unit ()
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
