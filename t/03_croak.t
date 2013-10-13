use strict;
use Test::More;

use CSS::clessc qw(less_compile);

subtest invalid_arg => sub {
    for my $less (undef, +{}, []) {
        eval { less_compile($less) };
        ok $@;
    }
};

subtest invalid_less => sub {
    my $invalid = 'h1 { color:';
    eval { less_compile($invalid); };
    ok $@;
};


done_testing;

