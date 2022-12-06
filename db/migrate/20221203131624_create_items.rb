class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "file"
    t.timestamps
    end
  end
end
