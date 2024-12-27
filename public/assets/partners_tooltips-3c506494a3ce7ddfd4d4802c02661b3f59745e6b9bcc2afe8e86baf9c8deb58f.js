document.addEventListener('turbo:load', function () {
  if (document.body.dataset.controller === 'partners' && document.body.dataset.action === 'index') {
    const tooltips = [
      { text: "ここではあなたのペットを一覧で表示します！", selector: null },
      { text: "新しいペットを登録するには「パートナー追加」ボタンをクリックします。", selector: 'a[href="/partners/new"]' },
      { text: "追加後、ここでペットの名前をクリックすると詳細ページに移動します。", selector: null },
      { text: "追加したパートナー情報を知り合いに共有することもできます。", selector: '#share-button' },
      { text: "その他わからないことがあれば 設定＞サポート＞お問い合わせ から確認できます！", selector: '#settings-button' },
    ];

    let currentTooltipIndex = 0;

    function highlightElement(selector) {
      removeHighlight();

      if (selector) {
        const element = document.querySelector(selector);
        if (element) {
          const dimmedBackground = document.createElement("div");
          dimmedBackground.classList.add("dimmed-background");
          document.body.appendChild(dimmedBackground);

          element.classList.add("highlight");
          element.scrollIntoView({ behavior: "smooth", block: "center" });
        }
      }
    }

    function removeHighlight() {
      const dimmedBackground = document.querySelector(".dimmed-background");
      if (dimmedBackground) dimmedBackground.remove();

      const highlighted = document.querySelector(".highlight");
      if (highlighted) highlighted.classList.remove("highlight");
    }

    function showTooltip(index) {
      const tooltip = document.getElementById("tooltip-1");
      tooltip.querySelector("p").textContent = tooltips[index].text;
      highlightElement(tooltips[index].selector);

      if (index === tooltips.length - 1) {
        document.getElementById("next-tooltip").textContent = "閉じる";
      } else {
        document.getElementById("next-tooltip").textContent = "次へ";
      }
    }

    function completeTutorial() {
      fetch('/complete_tutorial', { // 必要に応じてルートを設定
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        },
        body: JSON.stringify({ complete_tutorial: true }),
      }).then(() => {
        console.log('Tutorial completed and flag updated');
      });
    }

    document.getElementById("next-tooltip").addEventListener("click", function () {
      currentTooltipIndex++;
      if (currentTooltipIndex < tooltips.length) {
        showTooltip(currentTooltipIndex);
      } else {
        // チュートリアル終了時の処理
        completeTutorial();
        removeHighlight();
        document.getElementById("tooltip-container").remove();
      }
    });

    showTooltip(currentTooltipIndex);
  }
});
