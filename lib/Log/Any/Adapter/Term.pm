package Log::Any::Adapter::Term;
use strict;
use warnings;
use Carp qw(confess);
use Log::Any::Adapter::Util qw(make_method);
use Term::ANSIColor;
use base qw(Log::Any::Adapter::Base);

our $VERSION = '0.02';

our %LOG_LEVEL;
{
    my $num = 0;
    %LOG_LEVEL = map { ($_ => $num++) } Log::Any->logging_methods;
}

# Stop color leaking out and messing up the terminal
$Term::ANSIColor::EACHLINE = "\n";

our %LEVEL_COLOR = (
    #debug     => ['blue'],
    info      => ['green'],
    notice    => ['magenta'],
    warning   => ['yellow'],
    error     => ['red'],
    critical  => ['red'],
    alert     => ['red'],
    emergency => ['red'],
);

# Set everything up. No API for changing settings so can pre calc eveything
sub init {
    my ($self) = @_;

    $self->{level}  ||= 'info';
    $self->{stdout} ||= 0;
    my $fh = $self->{_fh} ||= $self->{stdout} ? \*STDOUT : \*STDERR;
    $self->{use_color}     = (-t $fh ? 1 : 0) if not defined $self->{use_color};

    confess 'must supply a valid level'
        unless exists $LOG_LEVEL{ $self->{level} };

    $self->{level_num} = $LOG_LEVEL{ $self->{level} };
}

# Log to the screen, checking is_$level
#
foreach my $method ( Log::Any->logging_methods() ) {
    my $level = ucfirst $method;
    my $is_level = "is_$method";
    make_method( $method, sub {
        my ($self,$msg) = @_;
        return unless $self->$is_level;

        my $color = $self->{use_color} && $LEVEL_COLOR{$method};
        my $fh    = $self->{_fh};
        if ( $color ) {
            print $fh colored( $color, "$level\: $msg" ), "\n";
        }
        else {
            print $fh "$level\: $msg", "\n";
        }
    });
}

# Detection methods. Check the level.
#
foreach my $method ( Log::Any->detection_methods() ) {
    my $level = substr( $method, 3 );
    make_method( $method, sub {
        my $self = shift;
        return $LOG_LEVEL{ $level } >= $self->{level_num} ? 1 : 0;
    });
}

1;

__END__

=pod

=head1 NAME

Log::Any::Adapter::Term - A Log::Any screen logger.

=head1 VERSION

Version 0.02

=head1 SYNOPSIS

    use Log::Any qw($log);
    use Log::Any::Adapter::Term;
    Log::Any->set_adapter( 'Term', level => 'info' );

    $log->info("Hello");
    $log->notice("Lots happening");
    $log->warning("Looking dodgey");
    $log->error("Bang!");

=head1 DESCRIPTION

This L<Log::Any|Log::Any> adapter logs to the screen, for use with a command
line app. There is a single required parameter, I<level>, which is the minimum
level to log at.

Default logs to STDERR, pass C<stdout> option to go to STDOUT. If it is
connected to a tty then the default is to log in colour, otherwise no colour
(so the logs wont be full of esc chars if redirected to a file). Colours used
are based on the log level. Control with the use_color option.

There is no formal mechanism for changing the colours used at the moment. They
are stored in C<%Log::Ang::Adapter::Term::LEVEL_COLOR>, with a key of log level
and a value of an array ref of color names to give to L<Term::ANSIColor>. So
just hack that to change the colors. This may change in a future version.

=head1 OPTIONS

The following options can be passed into the C<set_adapter> call.

=head2 level

The minimum log level name to log at. e.g. 'error'.

=head2 use_color

Whether to color the log output based on the level. Default will test to see if
we are connected to a tty and use color if we are, no color otherwise.

=head2 stdout

Set to true to log to STDOUT instead of the default of STDERR.

=head1 ENVIRONMENT

=over 4

=item ANSI_COLORS_DISABLED

Set to a true value to disable coloring of log output.

=back

=head1 SEE ALSO

L<Log::Any|Log::Any>, L<Log::Any::Adapter|Log::Any::Adapter>,
L<Term::ANSIColor>.

=head1 BUGS

Please report any bugs or feature requests to C<bug-log-any-adapter-term at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Log-Any-Adapter-Term>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 TODO

Decide on a proper interface for setting the colours to use. Probably just pass
a hash to the constructor.

Finer grained (than just the level) highlightling system. More like colorize
and ccze.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Log::Any::Adapter::Term


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Log-Any-Adapter-Term>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Log-Any-Adapter-Term>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Log-Any-Adapter-Term>

=item * Search CPAN

L<http://search.cpan.org/dist/Log-Any-Adapter-Term/>

=back

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2010 Mark Pitchless.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
