const path = require('path');

module.exports = {
  entry: './src/firebase-sw.js', // サービスワーカー用のエントリポイント
  output: {
    path: path.resolve(__dirname, 'public'), // 出力先ディレクトリ
    filename: 'service-worker.js', // 出力ファイル名
    libraryTarget: 'umd', // UMD形式で出力
  },
  mode: 'production',
};