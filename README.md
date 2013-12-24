# NAME

Dist::Zilla::Plugin::PathInRoot - Puts the build files in the project root

# VERSION

version 0.001

# SYNOPSIS

In your `dist.ini`

    [PathInRoot]
    copy = Makefile.PL
    copy = cpanfile

# DESCRIPTION

Puts the specified files in the project root from build root.
The generated files can be included in the build or created in the
root of your dist for e.g. inclusion into version control.

# ATTRIBUTES

## copy

Copy the specified file from the build directory to the project root

# SEE ALSO

- [Dist::Zilla::Plugin::ReadmeAnyFromPod](https://metacpan.org/pod/Dist::Zilla::Plugin::ReadmeAnyFromPod)
- [Dist::Zilla::Plugin::ManifestInRoot](https://metacpan.org/pod/Dist::Zilla::Plugin::ManifestInRoot)

# AUTHOR

Keedi Kim - 김도형 <keedi@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Keedi Kim.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
