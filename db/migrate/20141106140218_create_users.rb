class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :nickname
      t.string :email_address
      t.string :password_digest
      t.boolean :admin

      t.timestamps
    end
  end
end
