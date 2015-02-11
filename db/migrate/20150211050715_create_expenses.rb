class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.date :date
      t.decimal :price, precision: 4, scale: 2
      t.string :desciption
      t.integer :catagory

      t.timestamps
    end
  end
end