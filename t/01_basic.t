use strict;
use Test::More;

use CSS::clessc qw(less_compile);

my $less = <<'...';
@color: #4D926F;
header {
    color: @color;
}
h2 {
    color: @color;
}
...

my $css = less_compile($less);

is $css, "header{color:#4D926F}h2{color:#4D926F}";

done_testing;

