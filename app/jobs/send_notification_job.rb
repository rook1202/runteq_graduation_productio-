class SendNotificationJob < ApplicationJob
    queue_as :default
  
    def perform(remainder_id)
      remainder = Remainder.find(remainder_id)
      device_tokens = remainder.partner.device_tokens.pluck(:token)
  
      message = {
        notification: {
          title: "リマインダー通知",
          body: "予定があります。",
        },
        tokens: device_tokens, # 配列で複数デバイスに送信可能
      }
  
      response = FirebaseAdmin.messaging.send_multicast(message)
      Rails.logger.info("Firebase response: #{response}")
    end
end