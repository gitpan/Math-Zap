
=head1 Matrix2

2*2 matrix manipulation    

PhilipRBrenan@yahoo.com, 2004, Perl License


=head2 Synopsis

Example t/matrix2.t

 #_ Matrix _____________________________________________________________
 # Test 2*2 matrices    
 # philiprbrenan@yahoo.com, 2004, Perl License    
 #______________________________________________________________________
 
 use Math::Zap::Matrix2 identity=>i;
 use Math::Zap::Vector2;
 use Test::Simple tests=>8;
 
 my ($a, $b, $c, $v);
 
 $a = matrix2
  (8, 0,
   0, 8,
  );
 
 $b = matrix2
  (4, 2,
   2, 4,
  );
 
 $c = matrix2
  (2, 2,
   1, 2,
  );
 
 $v = vector2(1,2);
 
 ok($a/$a           == i());
 ok($b/$b           == i());
 ok($c/$c           == i());
 ok(2/$a*$a/2       == i());
 ok(($a+$b)/($a+$b) == i());
 ok(($a-$c)/($a-$c) == i());
 ok(-$a/-$a         == i());
 ok(1/$a*($a*$v)    == $v);
 



=head2 Description

2*2 matrix manipulation    

=cut


package Math::Zap::Matrix2;
$VERSION=1.07;
use Math::Zap::Vector2 check=>'vector2Check', is=>'vector2Is';
use Carp;
use constant debug => 0; # Debugging level


=head2 Constructors


=head3 new 

Create a matrix

=cut


sub new($$$$)
 {my
  ($a11, $a12,
   $a21, $a22,
  ) = @_;

  my $m = round(bless(
   {11=>$a11, 12=>$a12,
    21=>$a21, 22=>$a22,
   }));
  singular($m, 1);
  $m;
 }


=head3 matrix2

Create a matrix. Synonym for L</new>.

=cut


sub matrix2($$$$)
 {new($_[0],$_[1],$_[2],$_[3]);
 }


=head3 identity

Identity matrix

=cut


sub identity()
 {bless
   {11=>1, 21=>0,                              
    12=>0, 22=>1,                              
   }; 
 }


=head3 new2v

Create a matrix from two vectors

=cut


sub new2v($$)
 {vector2Check(@_) if debug;
  my ($a, $b, $c) =  @_;
  my $m = round(bless(
   {11=>$a->{x}, 12=>$b->{x},
    21=>$a->{y}, 22=>$b->{y},
   }));
  singular($m, 1);
  $m;
 }


=head2 Methods


=head3 check

Check its a matrix

=cut


sub check(@)
 {if (debug)
   {for my $m(@_)
     {confess "$m is not a matrix2" unless ref($m) eq __PACKAGE__;
     } 
   }
  return (@_)
 }


=head3 is

Test its a matrix

=cut


sub is(@)
 {for my $m(@_)
   {return 0 unless ref($m) eq __PACKAGE__;
   }
  'matrix2';
 }


=head3 accuracy

Get/Set accuracy 

=cut


my $accuracy = 1e-10;

sub accuracy
 {return $accuracy unless scalar(@_);
  $accuracy = shift();
 }


=head3 round

Round: round to nearest integer if within accuracy of that integer 

=cut


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


=head3 singular

Singular matrix?

=cut


sub singular($$)
 {my $m = shift;  # Matrix   
  my $a = 1e-2;   # Accuracy
  my $A = shift;  # Action 0: return indicator, 1: confess 
  my $n = abs
    ($m->{11} * $m->{22} -                                        
     $m->{12} * $m->{21})
    < $a;
  confess "Singular matrix2" if $n and $A;
  $n;      
 }


=head3 clone

Create a matrix from another matrix

=cut


sub clone($)
 {my ($m) = check(@_); # Matrix
  round bless
   {11=>$m->{11}, 12=>$m->{12},
    21=>$m->{21}, 22=>$m->{22},
   }; 
 }


=head3 print

Print matrix

=cut


sub print($)
 {my ($m) = check(@_); # Matrix 
  'matrix2('.$m->{11}.', '.$m->{12}. 
        ', '.$m->{21}.', '.$m->{22}.
  ')';
 } 


=head3 add

Add matrices

=cut


sub add($$)
 {my ($a, $b) = check(@_); # Matrices
  my $m = round bless
   {11=>$a->{11}+$b->{11}, 12=>$a->{12}+$b->{12}, 
    21=>$a->{21}+$b->{21}, 22=>$a->{22}+$b->{22}, 
   }; 
  singular($m, 1);
  $m;
 }


=head3 negate

Negate matrix

=cut


sub negate($)
 {my ($a) = check(@_); # Matrices
  my $m = round bless
   {11=>-$a->{11}, 12=>-$a->{12},
    21=>-$a->{21}, 22=>-$a->{22},
   }; 
  singular($m, 1);
  $m;
 }


=head3 subtract

Subtract matrices

=cut


sub subtract($$)
 {my ($a, $b) = check(@_); # Matrices
  my $m = round bless
   {11=>$a->{11}-$b->{11}, 12=>$a->{12}-$b->{12},
    21=>$a->{21}-$b->{21}, 22=>$a->{22}-$b->{22},
   }; 
  singular($m, 1);
  $m;
 }


=head3 matrixVectorMultiply

Vector = Matrix * Vector     

=cut


sub matrixVectorMultiply($$)
 {       check(@_[0..0]) if debug; # Matrix
  vector2Check(@_[1..1]) if debug; # Vector 
  my ($a, $b) = @_;
  vector2
   ($a->{11}*$b->{x}+$a->{12}*$b->{y},
    $a->{21}*$b->{x}+$a->{22}*$b->{y},
   );
 }


=head3 matrixScalarMultiply

Matrix = Matrix * scalar      

=cut


sub matrixScalarMultiply($$)
 {my ($a) = check(@_[0..0]); # Matrix
  my ($b) = @_[1..1];        # Scalar
  confess "$b is not a scalar" if ref($b);   
  round bless
   {11=>$a->{11}*$b, 12=>$a->{12}*$b,
    21=>$a->{21}*$b, 22=>$a->{22}*$b,
   }; 
 }


=head3 matrixMatrixMultiply

Matrix = Matrix * Matrix      

=cut


sub matrixMatrixMultiply($$)
 {my ($a, $b) = check(@_); # Matrices
  round bless
   {11=>$a->{11}*$b->{11}+$a->{12}*$b->{21}, 12=>$a->{11}*$b->{12}+$a->{12}*$b->{22},
    21=>$a->{21}*$b->{11}+$a->{22}*$b->{21}, 22=>$a->{21}*$b->{12}+$a->{22}*$b->{22},
   }; 
 }


=head3 matrixScalarDivide

Matrix=Matrix / non zero scalar

=cut


sub matrixScalarDivide($$)
 {my ($a) = check(@_[0..0]); # Matrices
  my ($b) = @_[1..1];        # Scalar
  confess "$b is not a scalar" if ref($b);   
  confess "$b is zero"         if $b == 0;   
  round bless
   {11=>$a->{11}/$b, 12=>$a->{12}/$b,
    21=>$a->{21}/$b, 22=>$a->{22}/$b,
   }; 
 }


=head3 det

Determinant of matrix.

=cut


sub det($)
 {my ($a) = check(@_); # Matrices

+$a->{11}*$a->{22}
-$a->{12}*$a->{21}
 }


=head3 inverse

Inverse of matrix

=cut


sub inverse($)
 {my ($a) = check(@_); # Matrices

  my $d = det($a);
  return undef if $d == 0;

  round bless
   {11=> $a->{22}/$d, 21=>-$a->{21}/$d,
    12=>-$a->{12}/$d, 22=> $a->{11}/$d,
   }; 
 }


=head3 rotate

Rotation matrix: rotate anti-clockwise by t radians

=cut


sub rotate($)
 {my ($a) = @_;
   bless
   {11=>cos($t), 21=>-sin($t),                              
    12=>sin($t), 22=> cos($t),                              
   }; 
 }


=head3 equals

Equals to within accuracy

=cut


sub equals($$)
 {my ($a, $b) = check(@_); # Matrices
  abs($a->{11}-$b->{11}) < $accuracy and
  abs($a->{12}-$b->{12}) < $accuracy and

  abs($a->{21}-$b->{21}) < $accuracy and
  abs($a->{22}-$b->{22}) < $accuracy;
 }


=head2 Operators 

Operator overloads

=cut


use overload
 '+'        => \&add3,      # Add two vectors
 '-'        => \&subtract3, # Subtract one vector from another
 '*'        => \&multiply3, # Times by a scalar, or vector dot product 
 '/'        => \&divide3,   # Divide by a scalar
 '!'        => \&det3,      # Determinant                       
 '=='       => \&equals3,   # Equals (to accuracy)
 '""'       => \&print3,    # Print
 'fallback' => FALSE;


=head3 add operator

Add operator.

=cut


sub add3
 {my ($a, $b) = @_;
  $a->add($b);
 }


=head3 subtract operator

Subtract operator.

=cut


sub subtract3
 {my ($a, $b, $c) = @_;

  return $a->subtract($b) if $b;
  negate($a);
 }


=head3 multiply operator

Multiply operator.

=cut


sub multiply3
 {my ($a, $b) = @_;
  return $a->matrixScalarMultiply($b) unless ref($b);
  return $a->matrixVectorMultiply($b) if vector2Is($b);
  return $a->matrixMatrixMultiply($b) if is($b);
  confess "Cannot multiply $a by $b\n";
 }


=head3 divide operator

Divide operator.

=cut


sub divide3
 {my ($a, $b, $c) = @_;
  if (!ref($b))
   {return $a->matrixScalarDivide($b)            unless $c;
    return $a->inverse->matrixScalarMultiply($b) if     $c;
   }
  else 
   {return $a->inverse->matrixVectorMultiply($b) if vector2Is($b);
    return $a->matrixMatrixMultiply($b->inverse) if is($b);
    confess "Cannot multiply $a by $b\n";
   }
 }


=head3 equals operator

Equals operator.

=cut


sub equals3
 {my ($a, $b, $c) = @_;
  return $a->equals($b);
 }


=head3 determinant operator

Determinant of a matrix

=cut


sub det3
 {my ($a, $b, $c) = @_;
  $a->det;
 }


=head3 print operator

Print a vector.

=cut


sub print3
 {my ($a) = @_;
  return $a->print;
 }


=head2 Exports

Export L</matrix2>, L</identity>

=cut


use Math::Zap::Exports qw(
  matrix2  ($$$$)
  new2v    ($$)
  identity ()
 );

#_ Matrix2 ____________________________________________________________
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
