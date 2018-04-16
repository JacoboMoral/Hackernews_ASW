class CreateContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :contributions do |t|
      t.string :title
      t.string :url
      t.text :text

      t.timestamps
    end
  end
end
