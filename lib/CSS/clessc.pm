package CSS::clessc;
use 5.008005;
use strict;
use warnings;
use XSLoader;

our $VERSION = "0.01";

use Exporter 'import';
our @EXPORT_OK = qw(less_compile);

XSLoader::load __PACKAGE__, $VERSION;


1;
__END__

=encoding utf-8

=head1 NAME

CSS::clessc - binding for clessc

=head1 SYNOPSIS

    use CSS::clessc qw(less_compile);

    my $css = less_compile(<'...');
    @color: #4D926F;
    #header {
      color: @color;
    }
    h2 {
      color: @color;
    }
    ...

    print $css; # header{color:#4D926F}h2{color:#4D926F}

=head1 DESCRIPTION

CSS::clessc is a Perl binding for
L<clessc|https://github.com/BramvdKroef/clessc>
that is a LESS CSS compiler written in C++.

This module exports no function by default.
You can import explicitly the following function:

=over 4

=item C<less_compile()>

It takes LESS string and returns compiled CSS string.
If it fails to compile the LESS string, it croaks.

=back

=head1 SEE ALSO

L<clessc|https://github.com/BramvdKroef/clessc>

L<LESS|http://lesscss.org/>

=head1 LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Shoichi Kaji E<lt>skaji@outlook.comE<gt>

=cut

