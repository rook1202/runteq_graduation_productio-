document.addEventListener('turbo:load', function () {
    const modal = document.getElementById("tutorialModal");
    const steps = JSON.parse(modal.dataset.steps); // HTMLのdata-steps属性からデータを取得
    let currentStep = 0;
  
    const title = modal.querySelector(".modal-title");
    const text = modal.querySelector(".modal-body p");
    const image = modal.querySelector("#tutorialImage");
    const prevButton = modal.querySelector("#prevStep");
    const nextButton = modal.querySelector("#nextStep");
  
    function updateStep(step) {
      const stepData = steps[step];
      title.textContent = stepData.title;
      text.textContent = stepData.text;
      if (stepData.image) {
        image.src = stepData.image;
        image.style.display = "block"; // 画像を表示
      } else {
        image.style.display = "none"; // 画像を非表示
      }
  
      // ボタンの有効・無効を切り替え
      prevButton.disabled = step === 0;
      nextButton.textContent = step === steps.length - 1 ? "閉じる" : "次へ";
    }
  
    nextButton.addEventListener("click", function () {
      if (currentStep < steps.length - 1) {
        currentStep++;
        updateStep(currentStep);
      } else {
        modal.querySelector(".btn-close").click(); // モーダルを閉じる
      }
    });
  
    prevButton.addEventListener("click", function () {
      if (currentStep > 0) {
        currentStep--;
        updateStep(currentStep);
      }
    });
  
    // 初期ステップを表示
    updateStep(currentStep);
});