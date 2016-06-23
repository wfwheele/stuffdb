package StuffDB;

use 5.006;
use strict;
use warnings;

=head1 NAME

StuffDB - The great new StuffDB!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use Carp qw/croak/;
use Getopt::Long;
use Pod::Usage;
use File::Slurp;

=head1 SYNOPSIS

Quick summary of what the module does.

=head1 SUBROUTINES/METHODS

=cut

sub _process_command_line {
    my $self   = shift;
    my %config = ();
    return %config if not @ARGV;

    GetOptions(
        'config=s'      => \$config{config},
        'setup_cmds=s@' => \$config{setup_cmds},
        'schemas=s@'    => \$config{schemas},
        'help'          => sub { pod2usage(1) },
    ) or pod2usage(2);

    if (@ARGV) {
        pod2usage(
            -msg     => "unparseable arguments received: " . join( ',', @ARGV ),
            -exitval => 2,
        );
    }

    return %config;
}

sub _read_config_from_file {
    my ( $self, %config ) = @_;

    my $config_file
        = exists $config{config} ? $config{config} : $self->_find_config_file();

    croak 'no config file specified or found' if not $config_file;

    my %config_from_file;
    my $file_contents = load_file $config_file;

    if ( $config_file =~ /\.ya?ml$/mx ) {
        require YAML::XS;
        %config_from_file = %{ YAML::XS::Load($file_contents) };
    }
    elsif ( $config_file =~ /\.json$/mx ) {
        require JSON::XS;
        %config_from_file = %{ JSON::XS::decode_json($file_contents) };
    }

		#merge the two hashes preferring what came from the command line
    return (%config_from_file, %config);
}

=head2 run

equivalent to running F<stuffdb>.

=cut

sub run {
    my $self   = shift;
    my %config = $self->_process_command_line();
    %config = $self->_read_config_from_file(%config);

    $self->create_schemas( $config{schemas} );
    $self->run_commands( $config{commands} );

    return 1;
}

=head1 AUTHOR

William Frank Wheeler II, C<< <wfwheele at buffalo.edu> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-stuffdb at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=StuffDB>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc StuffDB


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=StuffDB>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/StuffDB>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/StuffDB>

=item * Search CPAN

L<http://search.cpan.org/dist/StuffDB/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2016 William Frank Wheeler II.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1;    # End of StuffDB
