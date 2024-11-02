// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "jquery";
import Rails from "@rails/ujs";

Rails.start();
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"


function addRemainderFields(activityType) {
  const remainderFields = document.getElementById(`new_${activityType}_remainder_fields`);
  const template = document.getElementById(`${activityType}_remainder_template`).innerHTML;
  
  const newField = document.createElement('div');
  newField.innerHTML = template;

  // フォーム内のネームスペースを一意に設定
  remainderFields.appendChild(newField);
}

function removeRemainderField(button) {
  const field = button.closest('div');  // ボタンの親要素を削除
  field.remove();
}

// `addRemainderFields`をグローバルに設定
window.addRemainderFields = addRemainderFields;
window.removeRemainderField = removeRemainderField;
