# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_21_200544) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "blocks", force: :cascade do |t|
    t.geometry "southwest", limit: {:srid=>0, :type=>"st_point"}, null: false
    t.geometry "northeast", limit: {:srid=>0, :type=>"st_point"}, null: false
    t.string "w3w", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "plot_id"
    t.index ["plot_id"], name: "index_blocks_on_plot_id"
  end

  create_table "plots", force: :cascade do |t|
    t.string "title", null: false
    t.geometry "polygon", limit: {:srid=>0, :type=>"st_polygon"}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "blocks", "plots"
end
