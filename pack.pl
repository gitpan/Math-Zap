#!perl -w
#______________________________________________________________________
# Zap: packaging for CPAN
# PhilipRBrenan@yahoo.com, 2004, Perl License.
#______________________________________________________________________

$VERSION = '1.04';
$d       = 'i';                           # Build directory for install
$package = 'Math::Zap';                   # Package
$abstract= 'Draw 3D objects in 2D';       # Abstract

$author  = 'philiprbrenan@yahoo.com';     # Author

$copyright = <<"END";

=head2 Credits

=head3 Author

$author

=head3 Copyright

$author, 2004

=head3 License

Perl License.

END

&install();

#______________________________________________________________________
# Read a file - return as array
#______________________________________________________________________

sub readFile($)
 {my $f = shift; # File to read
  my $i;

  open  $i, "<$f" or die "Cannot read $i\n";
  my @l = <$i>;
  close $i;

  @l;
 }

#______________________________________________________________________
# Write to a file.
#______________________________________________________________________

sub writeFile($@)
 {my $f = shift; # File to write to
  my $o;

  open  $o, ">$f" or die "Cannot write $f\n";
  print $o join('', @_);
  close $o;
 }

#______________________________________________________________________
# Set up install.
#______________________________________________________________________

sub install()
 {print `rm -fr $d/* lib`;
  mkdir("$d");
  mkdir("$d/eg");
  mkdir("$d/html");
  mkdir("$d/lib");
  mkdir("$d/lib/Math");
  mkdir("$d/lib/Math/Zap");
  mkdir("$d/pod");
  mkdir("$d/t");
  mkdir("lib");
  mkdir("lib/Math");
  mkdir("lib/Math/Zap");

  my @pack = glob('*.pm');
  for (@pack)
   {next unless /^(\w+)\./;
    $pack{$1} = 1;
    print `cp $_ lib/Math/Zap/$_`;
   }

#______________________________________________________________________
# Make file.
#______________________________________________________________________

   my $dist   = "$package";
      $dist   =~ s/::/-/g;           

   writeFile("$d/Makefile.PL", << "END");
use ExtUtils::MakeMaker;

WriteMakefile
 (NAME     => "${package}::zzz",
  DISTNAME => "$dist",
  VERSION  => "$VERSION",	
  ABSTRACT => "$abstract",
  AUTHOR   => "$author",
  PREREQ_PM=> 
   {Tk           => 0,
    Math::Trig   => 0,
    Test::Simple => 0,   }
 );
END

#______________________________________________________________________
# README
#______________________________________________________________________

  my $readme = <<"END";
=head1 README: $package

This package supplies methods to draw a scene, containing three dimensional
objects, as a two dimensional image, using lighting and shadowing to assist the
human observer in reconstructing the original three dimensional scene.

#example zap.pl

See directory B<eg> for further examples.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. 

This is alpha code. It is written in pure Perl. It uses the standard
Perl install mechanism.

Download Math-Zap-XXX.tar.gz from CPAN, untar and:

  perl Makefile.PL
  make
  make test
  make install

If you are on Windows, use nmake, available at:

http://download.microsoft.com/download/vc15/Patch/1.52/W95/EN-US/Nmake15.exe

Help with this project would be appreciated.

For bug reports or suggestions please send email to:
$author

END

  $readme =~ s/XXX/$VERSION/;
  writeFile("README.pod", $readme);

#______________________________________________________________________
# TODO
#______________________________________________________________________

  writeFile("TODO.pod", <<"END");
=head1 TODO: $package

Optimization - help would be appreciated.

Cylinders, spheres, torii

Integration of incident power

More object types

Lighting effects

Textures for each plane

END

#______________________________________________________________________
# CHANGES
#______________________________________________________________________

  writeFile("CHANGES.pod", <<"END");
=head1 CHANGES: $package

2004/06/11 1.04 Created lib directory in order to create a more perfect
distribution

2004/06/09 1.03 First letter of package names capitalized and source
files edited to match following helpful comments from:
murat.uenalan\@gmx.de

2004/06/08 1.02 Cube triangulated

2004/06/01 1.01 Triangles successfuly shadowed

END

#______________________________________________________________________
# Copy and edit source files.
#______________________________________________________________________

# Each file
  for my $f(glob('t/*.t'), glob('eg/*.pl'), glob('lib/Math/Zap/*.pm'), 
            qw(zap.pl README.pod CHANGES.pod TODO.pod))
   {my ($i, $o) = ($f, "$d/$f");
    print "Edit $i to $o\n";
    my @l = readFile($i);

# Package
    for (@l)
     {if (/^package\s+(\w+)(.+)$/)
       {my ($a, $b) = (ucfirst($1), $2);
        $_ = "package $package\:\:$a$b\n\$VERSION=$VERSION;\n";
       }
# Use
      elsif (/^(\s?)use\s+(\w+)(.*)$/)
       {next unless defined($pack{$2});
        my ($s, $a, $b) = ($1, ucfirst($2), $3);

        $_ = $s."use $package\:\:$a$b\n";
       }

# Routine in package - hopefully eliminated by exports.pm
      elsif (/^(.*?)(\w+)::(\w+.+)$/)
       {next if $f =~ /pod$|^exports/;
        $_ = $1.$package.'::'.ucfirst($2).'::'.$3."\n";
        warn "$f: $_";
       }

# Example
      elsif (/^#example (.+)$/i)
       {my @e = readFile("$d/$1");
        my $e = join(' ', @e);  
        $_ = "Example $1\n\n $e\n";
       }

# Debug - set off
      elsif (/^use constant debug/)
       {$_ = 'use constant debug => 0;';
       }
     }

    push @l, "\n$copyright\n=cut\n" if $f =~ /pm$/;
    writeFile("$o", @l);
   }

#______________________________________________________________________
# Text versions of README, CHANGES, TODO
#______________________________________________________________________

  for my $f(qw(README CHANGES TODO))
   {print `pod2text.bat          $d/$f.pod           $d/$f`;  
    print `pod2html.bat --infile=$d/$f.pod --outfile=$d/html/$f.html`;
    print `mv                    $d/$f.pod           $d/pod/$f.pod`;  
   }
#______________________________________________________________________
# Special copies
#______________________________________________________________________

  print `cp pack.pl $d/pack.pl`;  

#______________________________________________________________________
# Create documentation.
#______________________________________________________________________

  my (@html, @pod);
  for $p(sort(keys(%pack)))
   {my @l = readFile("lib/Math/Zap/$p.pm");
    next unless join("\n", @l) =~ /\n=cut/;
    push @html, "html/$p.html";
    push @pod,  "pod/$p.pod";

    my $in = 0;
    for(@l)
     {$_ = "$1\n"     if /^(=[^_]+?)(_+)$/; #=...____
      $_ = "\n"       if /^____/;           # _______
      $_ = "\n$_\n\n" if /^=/;              # =...
      if (/^\s*=cut/)
       {$_ = "\n";
        $in = 1;
       }
      elsif ($in and /^\s*=/)
       {$in = 0;
        $_ = "\n$_";
       }
      elsif ($in)
       {$_ = " $_";
       }
     }
    writeFile("$d/$p.pod", @l);  
    print `pod2html.bat --infile=$d/$p.pod --outfile=$d/html/$p.html`;
    print `mv                    $d/$p.pod           $d/pod/$p.pod`;  
   }

#______________________________________________________________________
# Meta file per SM
#______________________________________________________________________

  writeFile("$d/META.yml", <<"END");
--- #YAML:1.0
name:     Math-Zap
version:  $VERSION
abstract: Zap objects in 3d space
license:  perl
distribution_type: module
requires:
recommends:
build_requires:
dynamic_config: 0
END

#______________________________________________________________________
# Manifest.
#______________________________________________________________________

   my $f = <<'END';
Makefile.PL
README
CHANGES
TODO   
html/CHANGES.html  
html/README.html  
html/TODO.html  
pod/CHANGES.pod  
pod/README.pod  
pod/TODO.pod  
MANIFEST
META.yml
pack.pl
END
   $f = join("\n", split(/\n/, $f),
          sort(glob('zap.pl')),
          sort(glob('lib/Math/Zap/*.pm')),
          sort(glob('t/*.t')),
          sort(glob('eg/*.pl')),
          sort(@pod),
#         sort(@html),
         );
   writeFile("$d/MANIFEST", $f);
 
#______________________________________________________________________
# Create distribution for CPAN
#______________________________________________________________________

  chdir("./$d");
  print `perl Makefile.PL`;
  print `nmake`;
  print `nmake dist`;
  chdir('..');
 
#______________________________________________________________________
# Clean up
#______________________________________________________________________

  `rm pod2htm*`;
 }
