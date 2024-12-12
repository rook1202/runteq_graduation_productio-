require "firebase-admin-sdk"

# Firebase Admin SDKの認証情報を設定
credentials_path = Rails.root.join('config', 'petnote-14a7e-firebase-adminsdk-wcojg-c82e3dced1.json')

# JSONファイルが存在しない場合のエラー処理
raise "Firebase credentials file not found at #{credentials_path}" unless File.exist?(credentials_path)

CREDENTIALS = JSON.parse(File.read(credentials_path)) # 定数として保持