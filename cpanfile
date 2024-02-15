requires 'perl', '5.008001';

on 'test' => sub {
    requires 'Test::More', '0.98';

    requires 'Carp';
    requires 'File::Basename';
    requires 'File::Path';
    requires 'File::Slurper';
    requires 'File::Spec';
    requires 'Scalar::Util';
};

requires 'constant';
