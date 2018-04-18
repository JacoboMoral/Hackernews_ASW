class CreateContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :contributions do |t|
      t.string :title
      t.string :url
      t.text :text
      t.integer :user_id

      t.timestamps
    end
  end
end


# <div class="field">
# <%= form.label :user_id %>
#     <%= form.number_field :user_id, id: :contribution_user_id %>
# </div>