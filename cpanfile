requires 'perl', '5.008001';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::LeakTrace';
};

on configure => sub {
    requires 'Module::Build::XSUtil';
    requires 'Devel::CheckBin';
    requires 'File::pushd';
    requires 'parent';
};
