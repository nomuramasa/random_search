class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.text :content
      t.integer :star
      t.integer :visit

      t.timestamps
    end
  end
end
