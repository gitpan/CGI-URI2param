use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'CGI::URI2param',
    'VERSION_FROM' => 'URI2param.pm', # finds $VERSION
    'AUTHOR'       => 'Thomas Klausner <domm@zsi.at>',
    'ABSTRACT_FROM'  => 'URI2param.pm',

);
