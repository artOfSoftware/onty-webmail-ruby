class CreateAccountSecrets < ActiveRecord::Migration
  def change
    create_table :account_secrets do |t|
      t.integer       :account_id,      :null=>false
      t.string        :account_name,    :null=>false
      t.string        :password_hash,   :null=>false
      t.string        :password_salt,   :null=>false

      t.timestamps    :null=>false
    end
  end
end
