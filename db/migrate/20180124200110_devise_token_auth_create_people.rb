class DeviseTokenAuthCreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table(:people) do |t|
      ## Required
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""

      ## User Info
      t.string :name
      t.string :nickname
      t.string :image
      t.string :email

      ## Tokens
      t.text :tokens

      t.timestamps
    end

    add_index :people, :email,                unique: true
    add_index :people, [:uid, :provider],     unique: true
  end
end
