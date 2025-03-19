package Text::TinyTemplate;

use strict;
use warnings;

use Carp qw( croak );
use Text::TinyTemplate::Util qw( escape_html wrap_text_in_chars wrap_text_in_words );

our $VERSION = '0.02';

sub new {

  my $class = shift;

  my $self =  {
    tag_start       => '<%',
    tag_end         => '%>',
    expression_mark => '=',
  };

  bless $self, ref $class || $class;

}

sub render {

  my ($self, $template, $data) = @_;

  my $begin = $self->{tag_start};
  my $end   = $self->{tag_end};
  my $expr  = $self->{expression_mark};

  return do {

    my @vals = grep { /^\w+$/ } keys %$data;
    my $args = 'my (' . join(',', map { "\$$_" } @vals) . ')'
             . ' = @{ $data }{qw(' . join(' ', @vals) . ')};';
    
    $template =~ s/(\s*)\Q$begin\E(\Q$expr\E)?\s*(.+?)\s*\Q$end\E(\s*)/
      $2 ? $1 . q('; $_0 .= ) . $3 . q(; $_0 .= ') . $4
         : q('; ) . $3 . q( $_0 .= ') . $4 /ge;
    
    croak "Check the template and the data."
      unless eval "$args\n" . q(my $_0 = ') . $template . q('; $_0;);

  };

}

1;

=encoding utf8

=head1 NAME

Text::TinyTemplate - 小さくてシンプルなテンプレートエンジン

=head1 VERSION

Version 0.02

=head1 SYNOPSIS

  use Text::TinyTemplate;

  my $template = do { local $/; <DATA> };
  my $data = {
    title => 'Name list',
    people => [
      { name => 'Smith', age => '42', },
      { name => 'John',  age => '37', },
      { name => 'Lewis', age => '28', },
    ],
  };

  my $tt = Text::TinyTemplate->new;
  my $output = $tt->render($template, $data);

  print $output;

  __DATA__
  <html>
    <head>
      <title><%= $title %></title>
    </head>
    <body>
      <h1><%= $title %></h1>
      <ul>
      <% foreach my $person (@$people) { %>
        <li><%= $person->{name} %> : <%= $person->{age} %> years old</li>
      <% } %>
      </ul>
    </body>
  </html>

テンプレート内には以下の2つのタグが使えます。

  <% Perlのコード %>
  <%= Perl変数展開 %>

C<E<lt>% %E<gt>>タグで囲まれた部分ではPerlのコードが解釈されます。
C<for>、C<if>、C<while>文などを使った記述ができます。
C<E<lt>%= %E<gt>>タグ内ではPerl変数などの中身が返されます。
C<E<lt>%= %E<gt>>タグ内でE<amp>、E<lt>、E<gt>、E<quot>などをエスケープしたい場合はC<escape_html>関数を使用します。

  <%= escape_html(エスケープしたい文字を含む文字列) %>

=head1 DESCRIPTION

C<Text::TinyTemplate>はスクリプトファイルからアウトプットに使用されるテキスト部分を分離させることができます。
このモジュールはC<Mojo::Template>を参考にして、最小限の機能とソースコードの簡素化を目指して作成しました。

=head1 METHODS

=head2 new()

C<new()> C<Text::TinyTemplate>クラスのインスタンスを生成するコンストラクタ関数。

=head2 render($template, \%data);

C<render()> 

  # Hello, world!
  print $tt->render('<%= $greeting %>', { greeting => 'Hello, world!' });

第1引数はテンプレートを表すB<スカラ>でなければなりません。
第2引数は第1引数に通すデータで、このデータはB<ハッシュリファレンス>でなければなりません。
このハッシュリファレンスのキーは、第1引数のテンプレート内では変数名になります。

=head1 AUTHOR

Yasuyoshi Sako (yasuyoshi.sako@gmail.com)

=cut
