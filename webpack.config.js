const path = require('path');

module.exports = {
  entry: './src/', // エントリーポイント
  output: {
    path: path.resolve(__dirname, 'public/pack'), // 出力先ディレクトリ
    filename: '', // 出力ファイル名
  },
  mode: 'production', // モード
};