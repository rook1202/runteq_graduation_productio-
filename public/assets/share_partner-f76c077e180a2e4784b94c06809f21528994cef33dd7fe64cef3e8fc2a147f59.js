// 共有アイコンのイベントハンドリング
  function handleShareClick(action, tokenUrl = null) {
    if ((action === "コピー" || action === "メール" || action === "LINE" || action === "QRコード") && tokenUrl) {
      fetch(tokenUrl, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        },
      })
        .then((response) => response.json())
        .then((data) => {
          if (data.success) {
            if (action === "コピー") {
              // クリップボードにコピー
              navigator.clipboard.writeText(data.share_url).then(() => {
                alert("リンクがコピーされました！");
              });
            } else if (action === "メール") {
              // メール作成画面を開く
              window.location.href = `mailto:?subject=【PetNote】から共有リンクが届いています。&body=${encodeURIComponent(data.share_text)}`;
            } else if (action === "LINE") {
              // LINE共有処理
              const shareText = encodeURIComponent(data.share_text);
              const lineAppUrl = `line://msg/text/${shareText}`; // LINEアプリ用URL
    
              // LINEアプリが起動しない場合のメッセージ
              const iframe = document.createElement('iframe');
              iframe.style.display = 'none';
              iframe.src = lineAppUrl;
              document.body.appendChild(iframe);
    
              setTimeout(() => {
                document.body.removeChild(iframe);
                alert("LINEアプリが見つかりません。また、PCでは使用できません。");
              }, 1000); // 1秒後にメッセージ表示
            } else if (action === "QRコード") {
              // アイコンのモーダルを閉じてQRコードを表示する
              const currentModalId = document.querySelector('.modal.show')?.id; // 現在表示中のモーダルのIDを取得
              if (currentModalId) {
                const currentModal = bootstrap.Modal.getInstance(document.getElementById(currentModalId));
                if (currentModal) {
                  currentModal.hide(); // モーダルを閉じる
                }
              }
    
              // QRコードモーダルを開く
              const qrCodeModal = new bootstrap.Modal(document.getElementById('qrCodeModal'));
              const qrCodeContainer = document.getElementById('qrCodeContainer');
              qrCodeContainer.innerHTML = data.qr_code_svg; // SVGを挿入
              qrCodeModal.show();
            }
          } else {
            alert(data.message || "トークンの生成に失敗しました");
          }
        })
        .catch((error) => {
          console.error("エラーが発生しました:", error);
          alert("処理中にエラーが発生しました");
        });
    }
  }

window.handleShareClick = handleShareClick;
