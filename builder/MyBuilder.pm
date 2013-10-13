package builder::MyBuilder;
use strict;
use warnings;

use parent 'Module::Build::XSUtil';
use Config;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(
        @_,
        generate_ppport_h    => "lib/CSS/ppport.h",
        needs_compiler_cpp   => 1,

        # c_source dirs are automatically added to include_dirs
        # include_dirs       => "clessc/src",
        c_source             => [qw(clessc/src)],
    );
}

sub ACTION_code {
    my $self = shift;
    if (!-f "clessc/src/liblessc.a") {
        $self->do_system(join(' && ',
            "cd clessc",
            "./configure --without-libpng --without-libjpeg",
        )) if !-f "clessc/Makefile";

        $self->do_system(join(' && ',
            "cd clessc/src",
            "$Config{make} liblessc.a",
        )) or die "failed to make clessc";
    }
    $self->SUPER::ACTION_code(@_);
}

sub ACTION_clean {
    my $self = shift;
    if (-f "clessc/Makefile") {
        $self->do_system("cd clessc && $Config{make} clean &>/dev/null");
    }
    $self->SUPER::ACTION_clean(@_);
}
sub ACTION_realclean {
    my $self = shift;
    if (-f "clessc/Makefile") {
        $self->do_system(
            "cd clessc && $Config{make} distclean &>/dev/null"
        );
    }
    $self->SUPER::ACTION_realclean(@_);
}

1;
