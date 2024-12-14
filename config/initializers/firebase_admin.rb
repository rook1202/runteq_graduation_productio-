require "firebase-admin-sdk"

# Firebase Admin SDK の認証情報を設定
credentials_path = Rails.root.join('config', 'petnote-14a7e-firebase-adminsdk-wcojg-c82e3dced1.json')

# JSON ファイルが存在しない場合のエラー処理
raise "Firebase credentials file not found at #{credentials_path}" unless File.exist?(credentials_path)

# サービスアカウントを使って Firebase アプリを初期化
creds = Firebase::Admin::Credentials.from_file(credentials_path)
FIREBASE_APP = Firebase::Admin::App.new(credentials: creds)

# Messaging クライアントを直接利用可能にするためのヘルパーメソッドを提供
module FirebaseAdmin
  def self.messaging
    FIREBASE_APP.messaging
  end
end