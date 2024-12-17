// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "jquery";
import Rails from "@rails/ujs";

Rails.start();
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"
import "share_partner"
import "service_worker_registration"
import "trigger_get_player_id"

document.addEventListener("turbo:load", () => {
  const flashMessages = document.getElementById("flash-messages");
  if (flashMessages) {
    setTimeout(() => {
      flashMessages.innerHTML = "";
    }, 5000); // 5秒後にメッセージを消す
  }
});

function addRemainderFields(activityType) {
  const remainderFields = document.getElementById(`new_${activityType}_remainder_fields`);
  const template = document.getElementById(`${activityType}_remainder_template`).innerHTML;
  
   // ユニークなIDを生成
   const uniqueIndex = new Date().getTime();

   const newField = document.createElement('div');
   newField.innerHTML = template.replace(/NEW_RECORD/g, uniqueIndex);

  // フォーム内のネームスペースを一意に設定
  remainderFields.appendChild(newField);
}

function removeRemainderField(button) {
  const field = button.closest('.row');  // ボタンの親要素を削除
  field.remove();
}

// `addRemainderFields`をグローバルに設定
window.addRemainderFields = addRemainderFields;
window.removeRemainderField = removeRemainderField;
