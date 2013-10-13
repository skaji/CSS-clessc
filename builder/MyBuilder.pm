package builder::MyBuilder;
use strict;
use warnings;

use parent 'Module::Build::XSUtil';
use Config;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(
        generate_ppport_h    => "lib/CSS/ppport.h",
        needs_compiler_cpp   => 1,
        include_dirs         => "clessc/src",
        extra_linker_flags   => "-Lclessc/src -llessc",
        @_,
    );
}

sub ACTION_code {
    my $self = shift;
    if (!-f "clessc/src/liblessc.a") {
        !system join(' && ',
            "cd clessc",
            "./configure --without-libpng --without-libjpeg",
            $Config{make},
        ) or die "failed to make clessc";
    }
    $self->SUPER::ACTION_code(@_);
}

sub ACTION_clean {
    my $self = shift;
    if (-f "clessc/Makefile") {
        system "cd clessc && $Config{make} clean &>/dev/null";
    }
    $self->SUPER::ACTION_clean(@_);
}
sub ACTION_realclean {
    my $self = shift;
    if (-f "clessc/Makefile") {
        system "cd clessc && $Config{make} distclean &>/dev/null";
    }
    $self->SUPER::ACTION_realclean(@_);
}

1;
