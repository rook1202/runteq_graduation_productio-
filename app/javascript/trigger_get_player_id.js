document.addEventListener('turbo:load', () => {
  const toggle = document.getElementById('notification-toggle');
  if (toggle) {
    toggle.addEventListener('change', async (event) => {
      event.preventDefault(); // デフォルト動作をキャンセル

      const isChecked = event.target.checked; // チェック状態を取得

      try {
        let playerId = OneSignal.User.onesignalId;

        // Player IDがない場合、通知許可をリクエスト
        if (!playerId) {
          console.log("No Player ID found. Prompting user for notification permissions...");
          await OneSignal.push(async function () {
            await OneSignal.registerForPushNotifications();
          });
          playerId = OneSignal.User.onesignalId; // 再取得
        }

        // リクエストURLを明示的に指定
        const url = isChecked ? '/api/device_tokens' : `/api/device_tokens/${playerId}`;
        const method = isChecked ? 'POST' : 'DELETE';

        // サーバーにリクエストを送信
        const response = await fetch(url, {
          method,
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('input[name="authenticity_token"]').value,
          },
          body: isChecked ? JSON.stringify({ player_id: playerId }) : null,
        });

        if (!response.ok) {
          console.error("Server error:", response.status, response.statusText);
          alert("通知設定の変更に失敗しました。");
        } else {

          // リロード後にタブをクリックするためのフラグを設定
          sessionStorage.setItem('clickNotificationTab', 'true');
          console.log("Session Storage:", sessionStorage.getItem('clickNotificationTab'));

          // リロードして最新状態を反映
          window.location.reload();
        }
      } catch (error) {
        console.error("Unexpected error during notification toggle:", error);
        alert("通知設定の変更中にエラーが発生しました。");
      }
    });
  }

  // リロード後に特定のタブをクリックする処理
  if (sessionStorage.getItem('clickNotificationTab') === 'true') {
    sessionStorage.removeItem('clickNotificationTab'); // フラグを削除

    const notificationTabButton = document.querySelector('a[href="#notification-tab"]'); // 通知タブボタン
    if (notificationTabButton) {
      notificationTabButton.click(); // プログラム的にクリックしてタブを切り替える
    }
  }
});