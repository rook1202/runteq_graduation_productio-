console.log("firebase_bundle が実行されました");
import { initializeApp } from "firebase/app";
import { getMessaging, getToken } from "firebase/messaging";

const firebaseConfig = {
  apiKey: "AIzaSyAAy3hIaWyB9jrz1Ti8wH1zk9kET6EXTpE",
  authDomain: "petnote-14a7e.firebaseapp.com",
  projectId: "petnote-14a7e",
  storageBucket: "petnote-14a7e.firebasestorage.app",
  messagingSenderId: "668203404956",
  appId: "1:668203404956:web:6eed2b6f92de01a932e759",
  measurementId: "G-GCFN8B7R9F"
};

// Firebase アプリの初期化
const app = initializeApp(firebaseConfig);

// Firebase Messaging の初期化
const messaging = getMessaging(app);
console.log("Firebase Messaging Initialized:", messaging);

// ボタンのクリックイベントをリスナーに追加
document.getElementById('enable-notifications-button').addEventListener('click', (event) => {
  event.preventDefault(); // デフォルト動作をキャンセル

  // トークン取得と保存処理
  getToken(messaging, { vapidKey: "BAQUOd8wYURmxoQoob-H7Tep2f55q0qJBPS9e0Mc93JTDlrPAtAsBS14XJMRbU2pypn-cGYfGyzm3KlzAeOgGwk" })
    .then((currentToken) => {
      if (currentToken) {
        console.log("Firebase Token:", currentToken);

        // トークンを保存するAPIエンドポイントに送信
        fetch('/api/device_tokens', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
          },
          body: JSON.stringify({ token: currentToken }),
        })
        .then(response => {
          if (response.ok) {
            return response.json();
          } else {
            return response.json().then(errorData => {
              throw new Error(`Server error: ${errorData.message}`);
            });
          }
        })
        .then(data => {
          console.log("Server Response:", data);
          alert("通知が有効になりました！");
        })
        .catch(error => {
          console.error("Error during server request:", error.message, error.stack);
        });
      } else {
        console.error("トークンが取得できませんでした");
      }
    })
    .catch(err => {
      console.error("トークン取得に失敗しました:", err.message, err.stack);
    });
});