class UpdateDeviceTokensForOneSignal < ActiveRecord::Migration[7.0]
  def change
    change_table :device_tokens do |t|
      t.remove :token
      t.string :player_id, null: false, index: true
      t.string :device_type
      t.string :device_os
    end
  end
end
