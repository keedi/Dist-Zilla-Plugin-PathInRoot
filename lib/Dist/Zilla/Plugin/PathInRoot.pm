package Dist::Zilla::Plugin::PathInRoot;
# ABSTRACT: Puts the build files in the project root

use Moose;

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

1;
__END__

