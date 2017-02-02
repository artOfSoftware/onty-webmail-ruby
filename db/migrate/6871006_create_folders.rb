class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|

      t.integer     :account_id,  :null=>false
      t.string      :name,        :null=>false
      t.integer     :folder_type, :null=>false, :default=>0
      t.timestamps                :null=>false
    end
  end
end
