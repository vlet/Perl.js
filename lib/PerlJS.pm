package PerlJS;
use strict;
use warnings;

use JavaScript::V8;
use Data::Dumper;
use File::Basename;
use Cwd;
use File::Spec;

our $VERSION = '0.1';

sub new {
    my $class = shift;
    my $self  = {};

    $self->{context} = JavaScript::V8::Context->new();
    $self->{perljs}  = {
        fn => {
            loadfile => sub {
                my $file = shift;
                return { "error" => "file not defined" }
                  unless ( defined $file );
                my $ret = {
                    error   => 0,
                    content => '',
                    path    => $file,
                    path    => ( $file =~ m{^/} )
                    ? $file
                    : File::Spec->catfile( getcwd(), $file ),
                };
                $ret->{dir} = dirname( $ret->{path} );
                if ( open my $fh, "<", $ret->{path} ) {
                    local $/;
                    $ret->{content} = <$fh>;
                    close $fh;
                    $ret->{path} = Cwd::abs_path( $ret->{path} );
                }
                else {
                    $ret->{error} =
                      "Error while opening file: $ret->{path}" . $!;
                }
                return $ret;
            },
        }
    };

    $self->{context}->bind( perljs    => $self->{perljs} );
    $self->{context}->bind( print     => sub { print @_, "\n" } );
    $self->{context}->bind( dump => sub { print Dumper \@_ } );

    bless $self, $class;
}

sub evalfile {
    my $self = shift;
    my $fn   = $self->{perljs}->{fn};
    my $ret  = $fn->{loadfile}->( shift() );
    if ( $ret->{error} ) {
        warn $ret->{error};
    }
    else {
        $self->{context}->eval( $ret->{content} );
        warn @_ if ($@);
    }
}

sub init {
    my $self = shift;
    $self->evalfile( File::Spec->catfile( dirname(__FILE__), "perl.js" ) );
}

1;
__END__

=pod

=head1 NAME

PerlJS - Node.js emulator for Perl

=head1 DESCRIPTION

This module implements some basic part of Node.JS API. It can be used for running JavaScript libraries that normally requires Node.js.

=head1 SYNOPSIS

    my $perljs = PerlJS->new();

    # init Node.js emulator
    $perljs->init();
    $perljs->evalfile("./test.js");

=head1 DEPENDENCIES

JavaScript::V8 - Perl interface to the V8 JavaScript engine

=head1 COPYRIGHT AND LICENSE

Copyright 2012 by crux E<lt>crux@cpan.orgE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
