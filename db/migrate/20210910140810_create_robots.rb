class CreateRobots < ActiveRecord::Migration[6.1]
  def change
    create_table "robots", force: :cascade do |t|
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.bigint "crate_id"
    end
  end
end
