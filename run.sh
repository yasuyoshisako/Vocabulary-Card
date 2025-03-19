#!/bin/bash

# スクリプトのディレクトリを取得
script_dir=$(dirname "$0")

# 絶対パスに変換
script_dir=$(cd "$script_dir" && pwd)

# そのディレクトリに移動
cd "$script_dir" || exit

set -e
perl data2tex.pl template.tt < data.csv > VocabularyCard.tex && lualatex VocabularyCard

echo "単語カードPDF（VocabularyCard.pdf）が生成されました"
