#!perl -w
#_ Line2 ______________________________________________________________
# Lines in 2d space
# Perl licence
# PhilipRBrenan@yahoo.com, 2004
#______________________________________________________________________

package Math::Zap::line2;
$VERSION=1.02;

use Math::Zap::vector2;
use Math::Zap::matrix2;
use Carp;
use constant debug => 0; # Debugging level

#_ Line2 ______________________________________________________________
# Exports 
#______________________________________________________________________

require Exporter;
use vars qw( @ISA $VERSION @EXPORT);

@ISA    = qw(Exporter);
@EXPORT = qw(line2);

#_ Line2 ______________________________________________________________
# Get/Set accuracy for comparisons
#______________________________________________________________________

my $accuracy = 1e-10;

sub accuracy
 {return $accuracy unless scalar(@_);
  $accuracy = shift();
 }

#_ Line2 ______________________________________________________________
# Short line?                      
#______________________________________________________________________

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

#_ Line2 ______________________________________________________________
# Create a line from two vectors
#______________________________________________________________________

sub new($$)
 {vector2::check(@_) if debug;
  my $l = bless {a=>$_[0], b=>$_[1]};
  short($l, 1);
  $l; 
 }

sub line2($$) {new($_[0],$_[1])};

#_ Line2 ______________________________________________________________
# Check its a line
#______________________________________________________________________

sub check(@)
 {unless (debug)
   {for my $l(@_)
     {confess "$l is not a line" unless ref($l) eq __PACKAGE__;
     }
   }
   @_;
 }

#_ Line2 ______________________________________________________________
# Test its a line
#______________________________________________________________________

sub is(@)
 {for my $l(@_)
   {return 0 unless ref($l) eq __PACKAGE__;
   }
  'line2';
 }

#_ Line2 ______________________________________________________________
# Components of line
#______________________________________________________________________

sub a($)  {check(@_) if (debug); $_[0]->{a}}
sub b($)  {check(@_) if (debug); $_[0]->{b}}
sub ab($) {check(@_) if (debug); vector2($_[0]->{b}{x}-$_[0]->{a}{x}, $_[0]->{b}{y}-$_[0]->{a}{y})}
sub ba($) {check(@_) if (debug); $_[0]->a-$_[0]->b}

#_ Line2 ______________________________________________________________
# Create a line from another line
#______________________________________________________________________

sub clone($)
 {my ($l) = check(@_); # Lines
  bless {a=>$l->a, b=>$l->b}; 
 }

#_ Line2 ______________________________________________________________
# Print line
#______________________________________________________________________

sub print($)
 {my ($l) = check(@_); # Lines
  my ($a, $b) = ($l->a, $l->b);
  my ($A, $B) = ($a->print, $b->print);  
  "line2($A, $B)";
 } 

#_ Line2 ______________________________________________________________
# Angle between two lines
#______________________________________________________________________

sub angle($$)
 {my ($a, $b) = check(@_); # Lines
  $a->a-$a->b < $b->a-$b->b;     
 } 

#_ Line2 ______________________________________________________________
# Are two lines parallel
#______________________________________________________________________

sub parallel($$)
 {my ($a, $b) = check(@_); # Lines

# return 1 if abs(1 - abs($a->ab->norm * $b->ab->norm)) < $accuracy;
  return 1 if abs(1 - abs($a->ab->norm * $b->ab->norm)) < 1e-3;     
  0;
 }

#_ Line2 ______________________________________________________________
# Intersection of two lines
#______________________________________________________________________

sub intersect($$)
 {my ($a, $b) = check(@_); # Lines

  return 0 if $a->parallel($b);
  my $i = matrix2::new2v($a->ab, $b->ba) / ($b->a - $a->a);

  $a->a+$i->x*$a->ab;
 }

#_ Line2 ______________________________________________________________
# Intersection of two lines occurs within second line?
#______________________________________________________________________

sub intersectWithin($$)
 {my ($a, $b) = check(@_); # Lines

  return 0 if $a->parallel($b);
  my $i = matrix2::new2v($a->ab, $b->ba) / ($b->a - $a->a);

  0 <= $i->y and $i->y <= 1;
 } 

#_ Line2 ______________________________________________________________
# Do the two line segments cross over each other?
#______________________________________________________________________

sub crossOver($$)
 {my ($a, $b) = check(@_); # Lines

  return 0 if $a->parallel($b);
  my $i = matrix2::new2v($a->ab, $b->ba) / ($b->a - $a->a);

  0 <= $i->x and $i->x <= 1 and 0 <= $i->y and $i->y <= 1;
 } 

#_ Line2 ______________________________________________________________
# Package loaded successfully
#______________________________________________________________________

1;
