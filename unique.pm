=head1 Unique__________________________________________________________
Unique id    

PhilipRBrenan@yahoo.com, 2004, Perl license

=head2 Synopsis_________________________________________________________
Example t/unique.t

 #_ Unique _____________________________________________________________
 # Unique           
 # philiprbrenan@yahoo.com, 2004, Perl License    
 #______________________________________________________________________
 
 use Math::Zap::Unique;
 use Test::Simple tests=>3;
    
 ok(unique() ne unique());
 ok(unique() ne unique());
 ok(unique() ne unique());
 


=head2 Description______________________________________________________
Returns a unique id each time it is called.
=cut____________________________________________________________________

package Math::Zap::Unique;
$VERSION=1.03;
use Carp;

=head2 Constructors____________________________________________________
=head3 unique__________________________________________________________
Return new unique id
=cut___________________________________________________________________

my $unique = 0;

sub unique() {++$unique}

=head3 new_____________________________________________________________
Return new unique id, synonym for L</unique>
=cut___________________________________________________________________

sub new {unique()}

=head2 Exports__________________________________________________________
Export L</unique>
=cut____________________________________________________________________

use Math::Zap::Exports qw(
  unique ()
 );

#_ Unique _____________________________________________________________
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
