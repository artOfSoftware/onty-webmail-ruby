class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer     :from_id, :null=>false
      t.integer     :to_id,   :null=>false
      t.string      :subject, :null=>false
      t.string      :text,    :null=>false
      t.integer     :status
      t.timestamps  :timestamps, :null=>false
    end
  end
end
