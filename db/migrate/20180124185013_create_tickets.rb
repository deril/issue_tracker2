class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.string :subject
      t.text :body
      t.string :status, default: 'PENDING', null: false

      t.timestamps
    end
  end
end
