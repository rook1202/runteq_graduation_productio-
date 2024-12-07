# frozen_string_literal: true

# 別ユーザーと共有しているPartnerを管理するためのテーブルを作成する
class CreatePartnerShare < ActiveRecord::Migration[7.0]
  def change
    create_table :partner_shares do |t|
      t.references :partner, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.bigint :shared_by, null: false
      t.timestamps
    end

    # shared_byに対する外部キー制約を追加
    add_foreign_key :partner_shares, :users, column: :shared_by
    add_index :partner_shares, %i[partner_id user_id shared_by], unique: true,
                                                                 name: 'index_partner_shares_on_all_ids'
  end
end
