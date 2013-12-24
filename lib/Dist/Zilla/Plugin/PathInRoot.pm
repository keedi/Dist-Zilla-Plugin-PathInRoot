package Dist::Zilla::Plugin::PathInRoot;
# ABSTRACT: Puts the build files in the project root

use Moose;
with 'Dist::Zilla::Role::AfterBuild';
with 'Dist::Zilla::Role::BeforeBuild';

use namespace::autoclean;

use Path::Tiny;

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

sub before_build {
    my ( $self, $args ) = @_;

    my @paths = @{ $self->paths_to_copy };
    for my $path (@paths) {
        my $dest = path( $self->zilla->root . "/$path" );
        next unless -e $dest;

        $self->log("removing $path in root");
        $dest->remove_tree;
    }

    return;
}

__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 SYNOPSIS

In your F<dist.ini>

    [PathInRoot]
    copy = Makefile.PL
    copy = cpanfile


=head1 DESCRIPTION

Puts the specified files in the project root from build root.
The generated files can be included in the build or created in the
root of your dist for e.g. inclusion into version control.


=attr copy


=head1 SEE ALSO

=for :list
* L<Dist::Zilla::Plugin::ReadmeAnyFromPod>
* L<Dist::Zilla::Plugin::ManifestInRoot>


=cut
