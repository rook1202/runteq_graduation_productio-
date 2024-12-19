# frozen_string_literal: true

# リマインダーのオンオフを制御するコントローラー（時間の保存は別）
class RemaindersController < ApplicationController
  def update
    @remainder = Remainder.find(params[:id])

    # ユーザー権限を確認
    unless @remainder.partner.owner_id == current_user.id
      render_turbo_stream_error('編集権限がありません', @remainder)
      return
    end

    # `notification_status` の変更処理
    if @remainder.update(notification_status: params.dig(:remainder, :notification_status))
      if @remainder.notification_status
        schedule_notification(@remainder)
      else
        cancel_notification(@remainder)
      end
      respond_to do |format|
        format.turbo_stream do
          Rails.logger.info('Rendering Turbo Stream response')
          render turbo_stream: [
            turbo_stream.replace(
              "remainder_#{@remainder.id}",
              partial: 'remainders/remainder',
              locals: { remainder: @remainder }
            )
          ]
        end
      end
    else
      render_turbo_stream_error('更新に失敗しました', @remainder)
    end
  end

  private

  def render_turbo_stream_error(message, remainder)
    id = "remainder_#{remainder.id}"
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          id,
          partial: 'remainders/remainder',
          locals: { remainder: remainder, error_message: message }
        )
      end
    end
  end

  def schedule_notification(remainder)
    remainder.schedule_notification
  end

  def cancel_notification(remainder)
    remainder.cancel_notification
  end
end
