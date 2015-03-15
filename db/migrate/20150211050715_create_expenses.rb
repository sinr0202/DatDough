class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.date :date
      t.decimal :amount, precision: 6, scale: 2
      t.decimal :tax, precision: 6, scale: 2
      t.string :description
      t.integer :category
      t.integer :transaction_type
      t.integer :payment_method
      t.belongs_to :user, index: true

      t.timestamps
    end
    add_foreign_key :expenses, :users
  end
end