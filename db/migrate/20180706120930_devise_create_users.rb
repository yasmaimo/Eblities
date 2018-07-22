# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: "", unique: true, index: true
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## 追加カラム
      t.string :user_name, null: false, index: true, default: "user"
      t.string :introduction
      t.string :web_site_url
      t.string :image_id
      # t.string :image_url
      t.integer :point, index: true, default: 0
      t.integer :status, null: false, index: true, default: 0

      ## SNS階認証用カラム
      t.string :provider
      t.string :uid

      ## 二段階認証用カラム
      t.string :encrypted_otp_secret
      t.string :encrypted_otp_secret_iv
      t.string :encrypted_otp_secret_salt
      t.integer :consumed_timestep
      t.boolean :otp_required_for_login
      t.text    :otp_backup_codes

      t.timestamps null: false
    end

    # add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
