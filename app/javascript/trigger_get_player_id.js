document.addEventListener('DOMContentLoaded', () => {
  console.log("Window OneSignal after push:", window.OneSignal);

  const button = document.getElementById('enable-notifications-button2');
  if (button) {
    button.addEventListener('click', async (event) => {
      event.preventDefault(); // ボタンのデフォルト動作をキャンセル

      try {
        let playerId = OneSignal.User.onesignalId;

        if (!playerId) {
          console.log("No Player ID found. Prompting user for notification permissions...");
          await OneSignal.push(async function() {
            await OneSignal.registerForPushNotifications();
            playerId = OneSignal.User.onesignalId;
          });
        }

        if (playerId) {
          console.log("OneSignal Player ID:", playerId);

          // サーバーにplayer_idを送信（レスポンス処理を無視）
          await fetch('/api/device_tokens', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'text/vnd.turbo-stream.html', // Turbo Streamを指定
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
            },
            body: JSON.stringify({ player_id: playerId }),
          });
        } else {
          alert("通知の有効化中にエラーが発生しました。");
        }
      } catch (error) {
        console.error("Unexpected error during notification registration:", error);
        alert("通知の有効化中にエラーが発生しました。");
      }
    });
  }
});