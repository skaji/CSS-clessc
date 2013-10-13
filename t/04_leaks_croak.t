use strict;
use warnings;
use Test::More;
use Test::LeakTrace;
use CSS::clessc qw(less_compile);


no_leaks_ok {
    for my $less (undef, +{}, []) {
        eval { less_compile($less) };
    }
    my $invalid = 'h1 { color:';
    eval { less_compile($invalid); };
};


done_testing;

