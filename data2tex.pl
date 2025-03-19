#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use FindBin;
use lib qq($FindBin::Bin/lib);
use Text::TinyTemplate;

use Encode qw(decode);
@ARGV = map { decode 'UTF-8', $_ } @ARGV;

binmode STDIN,  ":utf8";
binmode STDOUT, ":utf8";

my @data;
while (my $line = <STDIN>) {
  next if $. == 1;
  my @fields;
  push @fields, $1 || $2 while ($line =~ /"([^"]*)"|([^",]+)/g);
  push @data, {
    id          => $fields[0], word => $fields[1], ipa     => $fields[2],
    category    => $fields[3], mean => $fields[4], example => $fields[5],
    translation => $fields[6],
  };
}

my $instance = Text::TinyTemplate->new;
my $template = do { open my $fh, "<:utf8", $ARGV[0]; local $/; <$fh> };

print $instance->render($template, { data => \@data });

__END__
perl data2tex.pl template.tt < data.csv > VocabularyCard.tex
