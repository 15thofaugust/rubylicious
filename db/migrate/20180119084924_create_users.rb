class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :fullname
      t.string :avatar
      t.string :bio
      t.binary :gender

      t.timestamps
    end
  end
end
