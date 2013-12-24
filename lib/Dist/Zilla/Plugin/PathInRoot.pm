package Dist::Zilla::Plugin::PathInRoot;
# ABSTRACT: Puts the build files in the project root

use Moose;
with 'Dist::Zilla::Role::AfterBuild';

use namespace::autoclean;

sub mvp_multivalue_args { qw( paths_to_copy ) }
sub mvp_aliases         { +{ copy => 'paths_to_copy' } }

has paths_to_copy => (
    is       => 'ro',
    isa      => 'ArrayRef[Str]',
    required => 1,
);

around dump_config => sub {
    my ( $orig, $self ) = @_;
    my $config = $self->$orig;

    my $this_config = { paths_to_copy => $self->paths_to_copy, };

    $config->{ '' . __PACKAGE__ } = $this_config;

    return $config;
};

sub after_build {
    my ( $self, $args ) = @_;

    my @paths = @{ $self->paths_to_copy };
    for my $path (@paths) {
        my $src  = path( "$args->{build_root}/$path" );
        my $dest = path( $self->zilla->root . "/$path" );

        unless ( -e $src ) {
            $self->log("$path does not exist in build root");
            next;
        }

        $self->log([ 'PathInRoot updating contents of %s in root', $path ]);
        $dest->spew_raw( $src->slurp_raw );
    }

    return;
}

1;
__END__

