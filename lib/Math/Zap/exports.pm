
=head1 Exports

Export routines from a package with names specified by caller of the
package.


=head2 Synopsis

 use Math::Zap::Vector vector=>'v', units=>'u';

 my $x = v(1,0,0);
 my $y = u();

Rather than:

 my $x = Math::Zap::Vector::vector(1,0,0);
 my $y = Math::Zap::Vector::units();


=head2 Description

Export routines from a package with names specified by caller of the
package. The routines to be exported are defined in the exporting
package Math::Zap::As:
$VERSION=1.05;

 use Math::Zap::Exports qw(
   vector ($$$)
   units  ()
 );

A suitable sub import() is created, allowing the caller to specify:

 use Math::Zap::Vector vector=>'v', units=>'u';

The caller may then refer to Math::Zap::Vector::vector() as v() and
Math::Zap::Vector::units() as u().

The first routine exported is always imported by its export name unless
a new name is supplied. Thus:

 use Math::Zap::Vector;

and

 use Math::Zap::Vector vector=>'vector';

have identical effects.

The advantage of this is approach is that it allows the importing
package Math::Zap::To control the names of the exported routines in its name space
$VERSION=1.05;
rather than the developer of the exporting package, a facility I have
not been able to discover in the standard Perl Exporter.pm.
                                 
PhilipRBrenan@yahoo.com, 2004, Perl licence


=head2 Method: Exports

Construct import routine. 

=cut


##1
package Math::Zap::Exports;
$VERSION=1.05;

#______________________________________________________________________
# Import for exports: export from exporting package.
#______________________________________________________________________

sub import(@)
 {shift @_;               # Remove 'exports'
  scalar(@_) % 2 and      # Check number of parameters is even
    die "use exports: Odd number of parameters";
  my $q = join(' ', @_);  # Stringify parameters
  my $p = (caller())[0];  # Exporting package
  my $s =                 # Push data into space of exporting package 
'@'.$p.'::EXPORTS = qw('.$q.');';
  eval $s; die $@ if $@;  # Perform push and check it worked
# print "AAAA ", join(' ', @zzz::EXPORTS), "\n"; # Print pushed data

#______________________________________________________________________
# Construct import routine for exporting package.
#______________________________________________________________________

  $s  = 'pack'."age $p;\n". <<'END'; # Switch to exporting package
sub import(@)
 {shift @_;
  my @p = ($EXPORTS[0], $EXPORTS[0], @_);
  scalar(@p) % 2 and die "Odd number of parameters";

# Edit parameters and convert to hash
  s/^-// for(@p);
  my %p = @p;

# Switch to package requesting exported methods
  my $c = __PACKAGE__;    # Save exporting package
  my $s =                 # Switch to importing package   
'pack'.'age '.(caller())[0].";\n".
'no warnings \'redefine\';'."\n";

# Export valid methods
  my %e = @EXPORTS;
  for my $p(keys(%p))
   {defined $e{$p} or
      die "use $c: Bad method: $p requested.\nValid methods are ".
          join(', ', sort(keys(%e))). "\n";
    $s .= 'sub '.$p{$p}.$e{$p}.' {&'.$c.'::'.$p.'(@_)}'."\n";
   }

# Back to exporting package
  $s .= 'use warnings \'redefine\';'."\n".
        'pack'.'age '.$c.";\n";

# Push exports
# print "BBBB $s\n";
  eval($s); die $@ if $@;
 }
END

#______________________________________________________________________
# Push import routine  
#______________________________________________________________________

# print "CCCC $s\n";
  eval($s); die $@ if $@;
 }

##2
#______________________________________________________________________
# Package installed successfully
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
