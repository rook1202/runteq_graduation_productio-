# frozen_string_literal: true

# ApplicationControllerは、すべてのコントローラーの基本クラスです。
# 共通のロジックやフィルターを定義します。
class ApplicationController < ActionController::Base
  before_action :require_login
end
