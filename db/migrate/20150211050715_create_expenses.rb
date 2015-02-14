class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.date :date
      t.decimal :amount, precision: 6, scale: 2
      t.string :description
      t.integer :category

      t.timestamps
    end
  end
end