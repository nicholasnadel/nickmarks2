class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :user, index: true
      t.references :bookmark, index: true

      t.timestamps null: false
    end
  end
end
