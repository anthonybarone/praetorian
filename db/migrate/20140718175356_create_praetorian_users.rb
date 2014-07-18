class CreatePraetorianUsers < ActiveRecord::Migration
  def change
    create_table :praetorian_users do |t|
      t.string :email
      t.string :password_digest
      t.string :auth_token
      t.string :password_reset_token
      t.datetime :password_reset_sent_at

      t.timestamps
    end
  end
end
