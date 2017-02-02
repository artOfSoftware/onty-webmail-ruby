class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string        :name,       :null=>false, :unique=>true
      t.string        :fullname
      t.string        :password,   :null=>false
      t.integer       :nr_logins
      t.timestamps                 :null=>false
    end
  end
end
