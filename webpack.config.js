const path = require('path');

module.exports = {
  entry: './src/service_worker_registration.js', // エントリーポイント
  output: {
    path: path.resolve(__dirname, 'public'), // 出力先ディレクトリ
    filename: 'service_worker.js', // 出力ファイル名
  },
  mode: 'production', // モード
};