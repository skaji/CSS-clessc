use strict;
use warnings;
use Test::More;
use Test::LeakTrace;
use CSS::clessc qw(less_compile);


no_leaks_ok {
    my $less = '
    @color: #4D926F;
    header {
        color: @color;
    }
    h2 {
        color: @color;
    }
    ';

    my $css = less_compile($less);
};

no_leaks_ok {
    for my $less (undef, +{}, []) {
        eval { less_compile($less) };
    }
    my $invalid = 'h1 { color:';
    eval { less_compile($invalid); };
};


done_testing;

