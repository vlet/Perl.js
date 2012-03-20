use inc::Module::Install;

name 'PerlJS';
all_from 'lib/PerlJS.pm';
install_script 'bin/perljs';

requires 'JavaScript::V8';
requires 'Data::Dumper';
requires 'File::Spec';
requires 'File::Basename';
requires 'Cwd';

WriteAll;
