ActiveRecord::Schema.define(version: 20131226214224) do

  create_table "users", force: true do |t|
    t.string   "name"
    t.integer  "age"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text    "comment"
    t.integer  "user_id"
    t.integer "option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end