package Array::Group;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

use Carp;

require Exporter;

our @ISA = qw(Exporter DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Array::Group ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
                                   ngroup
				   dissect
                                  ) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw();

our $VERSION = '3.0';

# Preloaded methods go here.
sub ngroup {
  my ($size, $r_list) = &_validate_params;

  my @list = @{$r_list};
  my @lol;

  push @lol, [splice @list, 0, $size] while @list;

  return wantarray ? @lol : \@lol;
}

sub dissect {
  my ($size, $r_list) = &_validate_params;

  my @lol;
  my ($i, $j) = (0, 0);

  foreach (@$r_list) {
    $lol[$i]->[$j] = $_;
    $i = 0, $j++ unless (++$i % $size);
  }

  return wantarray ? @lol : \@lol;
}


# Internal parameter validation function
sub _validate_params {
  # Check we've been called with at least one argument
  Carp::confess( "Called with no arguments" ) if $#_ == -1;

  # First param might be a class (if invoked as a class method). Discard it if so.
  shift if $_[0] =~ /^[a-zA-Z0-9]+ (?: :: [a-zA-Z0-9]+ )$/x;

  # Check we have at least 2 arguments remaining
  Carp::confess( "Called with insufficient arguments" ) if( $#_ < 1 );

  # Next argument is size. check it is a valid positive integer.
  my $size = shift;
  if( $size !~ /^\+?\d+$/ ) {
    Carp::confess( "Size '$size' is not a valid positive integer" );
  } elsif( $size == 0 ) {
    Carp::confess( "'$size' is an invalid array size" );
  }

  # If only one argument remains, check to see if it is an arrayref, otherwise, reate a reference to it
  my $r_list;
#  if( ($#_ == 0) &&
#      (ref($_[0]) eq 'ARRAY') ) {
  $r_list = $_[0];
#   } else {
#     $r_list = \@_;
#   }

  return $size, $r_list;
}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

Array::Group - Convert an array into array of arrayrefs of uniform size N.

=head1 SYNOPSIS

  use Array::Group qw( :all );

  @sample = ( 1 .. 10 );
  $rowsize = 3;

  ngroup $rowsize => \@sample ;
  # yields
         (
            [   1,   2,   3   ],
            [   4,   5,   6   ],
            [   7,   8,   9   ],
            [   10   ]
          );

  dissect $rowsize => \@sample ;
  # yields
         (
            [   1,   5,   9   ],
            [   2,   6,  10   ],
            [   3,   7   ],
            [   4,   8   ]
          );



=head1 DESCRIPTION

The C<ngroup> method reformats a list into a list of
arrayrefs. It is often used for formatting data into HTML tables, amongst
other things.

C<dissect()> returns a list of lists where the first
element of each sublist will be one of the first elements of the
source list, and the last element will be one of the last.
This behaviour is much more useful when the input list is sorted.

The key difference between the two methods is that C<dissect()> takes
elements from the start of the list provided and pushes them onto each
of the subarrays sequentially, rather than simply dividing the list
into discrete chunks.

Both methods can be called as either functions or class methods (to
ensure compatibility with previous releases), and the array to be
reformed can be passed as a reference.



=head1 AUTHOR

The ongoing saga between princepawn, davorg and kilinrax over who did 
when in terms of getting this out is rather long-winded.
They have their side of the story and I have mine. As is usual, it is
princepawn versus some other majority. But what more could you expect from
the black sheep of the Perl community?

One thing is for certain
there is a bug in L<Array::Reform|Array::Reform> 
and two months have passed and the
author has done nothing about my RT bug patch submitted 1/21/06:
L<http://rt.cpan.org/Public/Bug/Display.html?id=17201>

Not to mention that I held the Array::Reform namespace and when I turned it 
overto him, he did not even acknowledge this. 

The test suite for L<HTML::Element::Library|HTML::Element::Library> 
depends on this
functionality and since I have people complaining about the wacky errors
coming out of kilinrax's version of this module, and since he does not
respond to emails, it is clear it is time to drop any reliance on his module.

So, I wont say who the author is of what... this is free software anyway.


=head1 SEE ALSO

=over 4

=item * L<Array::Reform>

=back

=cut
