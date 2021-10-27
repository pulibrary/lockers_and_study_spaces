# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Omniauthable
      t.string :provider, null: false, default: 'cas'
      t.string :uid, null: false

      ## Rememberable
      t.datetime :remember_created_at

      t.boolean :admin, null: false, default: false

      t.timestamps null: false
    end

    add_index :users, :uid, unique: true
    add_index :users, :provider
    add_index :users, %i[uid provider], unique: true
  end
end
