#! /usr/bin/perl
use strict;

my %out;

for (@ARGV) {
  open F, "<$_" or die;
  my $f = join('', <F>);
  close F;
  s/[.]svg$//i;
  my $id = $_;
  $f =~ /id="([^"]+)"/ and $id = $1;
  my $out = "";
  $out .= "$1:$3;"
    while $f =~ /(font-(style|variant|family|weight|stretch))="([^"]+)"/g;
  $out =~ s/font-(style|variant|weight|stretch):normal;//g;
  $out =~ s/font-weight:400;//;
  $out =~ s/font-weight:700;/font-weight:bold;/;
  next if ($id eq $_ && "font-family:$_;" eq $out);
  $out{$id} = "$id\t$_\t$out\n";
}

print $out{$_} for sort keys %out;
