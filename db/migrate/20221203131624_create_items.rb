class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    end
  end
end
