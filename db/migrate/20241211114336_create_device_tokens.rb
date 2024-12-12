class CreateDeviceTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :device_tokens do |t|
      t.string :token, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
