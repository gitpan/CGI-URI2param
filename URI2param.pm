#-----------------------------------------------------------------
# CGI::URI2param
#-----------------------------------------------------------------
# Copyright Thomas Klausner / ZSI 2001
# You may use and distribute this module according to the same terms
# that Perl is distributed under.
#
# Thomas Klausner domm@zsi.at http://domm.zsi.at
#
# $Author: domm $
# $Date: 2001/07/04 09:40:15 $
# $Revision: 1.3 $
#-----------------------------------------------------------------
# CGI::URI2param - convert parts of an URL to param values
#-----------------------------------------------------------------
package CGI::URI2param;

use strict;
use Carp;
use Exporter;
use vars qw(@ISA @EXPORT_OK); 

@ISA = qw(Exporter);

@EXPORT_OK   = qw(uri2param);   

$CGI::URI2param::VERSION = '0.02';

sub uri2param {
   my ($req,$regexs,$options)=@_;

# options not implemented, possible options are:
# -> don't safe in $q->param but return parsed stuff as hash/array
# -> use URI instead of PATH_INFO

   # check if $req seems to be a valid request object
   croak "CGI::URI2param: not a valid request object" unless $req->can('param');

  # check environment and set stuff
   my $uri;
   if ($ENV{MOD_PERL}) {
      $uri=$req->uri;
   } else {
      $uri=$req->url . $req->path_info;
   }

   # apply regexes
   eval{
      while(my($key,$regex)=each(%$regexs)) {
	 if ($uri=~m/$regex/) {
	    $req->param($key,$+);
	 }
      }
   };

   if ($@) {
      $@=~s/ at .*$//;
      croak "CGI::URI2param: $@" if $@;
   }
   return;
}


1;

__END__

=head1 NAME

CGI::URI2param - convert parts of an URL to param values

=head1 SYNOPSIS

  use CGI::URI2param qw(uri2param);

  uri2param($req,\%regexes);

=head1 DESCRIPTION

CGI::URI2param takes a request object (as supplied by CGI.pm or
Apache::Request) and a hashref of keywords mapped to
regular expressions. It applies all of the regexes to the current URI
and adds everything that matched to the 'param' list of the request
object.

Why?

With CGI::URI2param you can instead of:

C<http://somehost.org/db?id=1234&style=fancy>

present a nicerlooking URL like this:

C<http://somehost.org/db/style_fancy/id1234.html>

To achieve this, simply do:

 CGI::URI2param::uri2param($r,{
                                style => 'style_(\w+)',
                                id    => 'id(\d+)\.html'
                               });

Now you can access the values like this:

 my $id=$r->param('id');
 my $style=$r->param('style');

=head2 uri2param($req,\%regexs)

C<$req> has to be some sort of request object that supports the method
C<param>, e.g. the object returned by CGI->new() or by
Apache::Request->new().

C<\%regexs> is hash containing the names of the parameters as the
keys, and corresponding regular expressions, that will be applied to
the URL, as the values.

   %regexs=( 
            id    => 'id(\d+)\.html',
            style => 'st_(fancy|plain)',
            order => 'by_(\w+)' 
           );

You should add some capturing parentheses to the regular
expression. If you don't do, all the buzz would be rather useless.

uri2param won't get exported into your namespace by default, so have
to either import it explicitly

 use CGI::URI2param qw(uri2param);

or call it with it's full name, like so

 CGI::URI2param::uri2param($r,$regex);

=head2 What's the difference to mod_rewrite ?

Basically noting, but you can use CGI::URI2param if you cannot use
mod_rewrite (e.g. your not running Apache or are on some ISP that
doesn't allow it). If you B<can> use mod_rewrite you maybe should
consider using it instead, because it is much more powerfull and
possibly faster. See mod_rewrite in the Apache Docs
(http://www.apache.org)

=head1 INSTALLATION

the standard way:

 perl Makefile.pl
 make
 make install

Currently there are no tests available.
 
=head1 BUGS

I assume, but I did't find any ...

=head1 TODO

Implement options (e.g. do specify what part of the URL should be
matched)

=head1 REQUIRES

A module that supplies some sort of request object is needed, e.g.:
Apache::Request, CGI

=head1 AUTHOR

Thomas Klausner, domm@zsi.at, http://domm.zsi.at

=head1 COPYRIGHT

Apache::FakeEnv is Copyright (c) 2001 Thomas Klausner, ZSI.
All rights reserved.

You may use and distribute this module according to the same terms
that Perl is distributed under

=cut

