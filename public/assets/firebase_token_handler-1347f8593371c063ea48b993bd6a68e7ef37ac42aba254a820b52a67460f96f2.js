console.log("Firebase Token Handler Initialized");
const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
console.log("CSRF Token:", csrfToken);

  document.getElementById('enable-notifications-button').addEventListener('click', (event) => {
    event.preventDefault(); // デフォルト動作をキャンセル

    // トークン取得と保存処理
    messaging.getToken({ vapidKey: "BAQUOd8wYURmxoQoob-H7Tep2f55q0qJBPS9e0Mc93JTDlrPAtAsBS14XJMRbU2pypn-cGYfGyzm3KlzAeOgGwk" })
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
