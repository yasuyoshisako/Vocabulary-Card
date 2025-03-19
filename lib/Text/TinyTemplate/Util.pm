package Text::TinyTemplate::Util;

use strict;
use warnings;

our $VERSION = '0.02';

# https://dankogai.livedoor.blog/archives/50940023.htmlを引用
my %escape_rule = ( '&' => 'amp', '>' => 'gt', '<' => 'lt', '"' => 'quot', "'" => '#39' );
my $escape_keys = '[' . join('', keys %escape_rule) . ']';

sub escape_html {

  my $str = shift;
  return unless defined $str;

  $str =~ s/($escape_keys)(?!amp;)/'&' . $escape_rule{$1} . ';'/ge;
  $str;

}

sub wrap_text_in_chars {
  my ($text, $max_length, $separator) = @_;
  my $wrapped_text;

  while (length($text) > $max_length) {
    $wrapped_text .= substr($text, 0, $max_length) . $separator;
    $text = substr($text, $max_length);
  }
  $wrapped_text .= $text;
  $wrapped_text;
}

sub wrap_text_in_words {
  my ($text, $max_length, $separator) = @_;
  my @words = split / /, $text;
  my $line = q();
  my @lines;
  
  for my $word (@words) {
    if (length($line) + length($word) + 1 <= $max_length) {
      $line .= ($line ? ' ' : '') . $word;
    } else {
      push @lines, $line;
      $line = $word;
    }
  }
  push @lines, $line if $line;

  return join $separator, @lines;
}

sub import {

  my $self = shift;
  my $package = caller;

  {
    no strict 'refs';
    *{"${package}::$_"} = \&{"${self}::$_"} for @_;
  }

}

1;

=encoding utf8

=head1 NAME

Text::TinyTemplate::Util - Text::TinyTemplateのためのユーティリティ関数

=head1 VERSION

Version 0.02

=head1 SYNOPSIS

  <%= escape_html(string) %>
  <%= wrap_text_in_chars(string, number, separator) %>
  <%= wrap_text_in_words(string, number, separator) %>

=head1 DESCRIPTION

C<Text::TinyTemplate::Util>はC<Text::TinyTemplate>で使用できる関数を提供します

=head1 FUNCTIONS

=head2 escape_html

文字列（string）に含まれるE<amp>、E<lt>、E<gt>、E<quot>などをエスケープします。

=head2 wrap_text_in_chars

文字列(string)に一定の文字数（number）ごとに区切り文字（separator）を挿入します。

=head2 wrap_text_in_words

C<wrap_text_in_words>と同じですが、文字列（string）に英語のような言語を想定しています。

=head1 AUTHOR

Yasuyoshi Sako (yasuyoshi.sako@gmail.com)

=cut
