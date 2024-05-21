#!/usr/bin/perl
use strict;
use warnings;

my $file = $ARGV[0];
my $output = $ARGV[1];

open my $fh, '<', $file or die "Can't open $file: $!";
open my $outfile, '>', $output or die "Can't open $output: $!" if $output;

my $dollarSignsEncountered = 0;
my $documentBegun = 0;

while (<$fh>) {
  if (/\\begin\{document\}/) {
    $documentBegun = 1;
  }
  if ($documentBegun == 0) {
    print unless $output;
    print $outfile $_ if $output;
    next;
  }
  while (/\$\$/) {
    if ($dollarSignsEncountered == 0) {
      s/\$\$/\\\[/;
      $dollarSignsEncountered = 1;
    } else {
      s/\$\$/\\]/;
      $dollarSignsEncountered = 0;
    }
  }
  s/\.\\]/\\]/g;
  s/(\[.+?])_/\{$1\}_/g;
  s/\.\$/\$\./g;
  s/\\:/:/g;
  s/\\mathbb R/\\R/g;
  s/\\mathbb N/\\N/g;
  s/\\mathbb Z/\\Z/g;
  s/\\mathbb Q/\\Q/g;
  s/\\mathbb C/\\C/g;

  print unless $output;
  print $outfile $_ if $output;
}
