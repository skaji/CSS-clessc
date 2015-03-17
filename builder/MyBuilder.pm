package builder::MyBuilder;
use strict;
use warnings;

use parent 'Module::Build::XSUtil';
use Config;
use File::pushd 'pushd';
use Devel::CheckBin qw(check_bin);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(
        needs_compiler_cpp   => 1,
        include_dirs         => "clessc/src",
        extra_linker_flags   => "-Lclessc/src -llessc",
        @_,
    );
}

sub create_build_script {
    my $self = shift;
    check_bin("sh");
    check_bin("autoreconf");
    $self->SUPER::create_build_script(@_);
}

sub run { !system @_ or die "Fail @_\n" }

sub ACTION_code {
    my $self = shift;
    if (!-f "clessc/src/liblessc.a") {
        my $guard = pushd "clessc";
        run qw(sh autogen.sh);
        run qw(sh configure --without-libglog --without-libpng --without-libjpeg);
        run $Config{make};
    }
    $self->SUPER::ACTION_code(@_);
}

sub ACTION_clean {
    my $self = shift;
    if (-f "clessc/Makefile") {
        my $guard = pushd "clessc";
        run $Config{make}, "clean";
    }
    $self->SUPER::ACTION_clean(@_);
}
sub ACTION_realclean {
    my $self = shift;
    if (-f "clessc/Makefile") {
        my $guard = pushd "clessc";
        run $Config{make}, "distclean";
    }
    $self->SUPER::ACTION_realclean(@_);
}

1;
