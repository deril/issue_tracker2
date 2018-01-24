class AddIndexOnCreatedAtToTickets < ActiveRecord::Migration[5.1]
  def change
    add_index :tickets, :created_at
  end
end
