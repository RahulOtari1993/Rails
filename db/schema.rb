# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_17_094406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "carriers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "case_product_items", force: :cascade do |t|
    t.integer "case_product_id"
    t.integer "product_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "processed", default: false, null: false
  end

  create_table "case_products", force: :cascade do |t|
    t.integer "case_id"
    t.integer "product_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "processed", default: false, null: false
    t.bigint "product_item_id"
  end

  create_table "cases", force: :cascade do |t|
    t.string "case_identifier"
    t.string "po_number"
    t.string "rep_name"
    t.string "procedure"
    t.date "procedure_date"
    t.string "surgeon_name"
    t.integer "location_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entries_for_product_locations", force: :cascade do |t|
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.integer "manufacturer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "location_type"
    t.index ["manufacturer_id"], name: "index_locations_on_manufacturer_id"
    t.index ["name"], name: "index_locations_on_name"
  end

  create_table "locations_users", id: false, force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "user_id", null: false
    t.index ["location_id", "user_id"], name: "index_locations_users_on_location_id_and_user_id"
    t.index ["user_id", "location_id"], name: "index_locations_users_on_user_id_and_location_id"
  end

  create_table "manufacturers", force: :cascade do |t|
    t.string "name"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["name"], name: "index_manufacturers_on_name"
  end

  create_table "order_histories", force: :cascade do |t|
    t.bigint "order_id"
    t.integer "status"
    t.datetime "action_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "action_by"
    t.index ["order_id"], name: "index_order_histories_on_order_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "user_id"
    t.integer "order_id"
    t.integer "product_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "product_id"], name: "index_order_items_on_order_id_and_product_id"
  end

  create_table "order_media", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "order_id"
    t.string "media"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_media_on_order_id"
  end

  create_table "order_product_items", force: :cascade do |t|
    t.bigint "product_item_id"
    t.bigint "order_id"
    t.bigint "location_id"
    t.bigint "product_id"
    t.bigint "order_item_id"
    t.bigint "order_shipment_list_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_received", default: false
    t.index ["location_id"], name: "index_order_product_items_on_location_id"
    t.index ["order_id"], name: "index_order_product_items_on_order_id"
    t.index ["order_item_id"], name: "index_order_product_items_on_order_item_id"
    t.index ["order_shipment_list_id"], name: "index_order_product_items_on_order_shipment_list_id"
    t.index ["product_id"], name: "index_order_product_items_on_product_id"
    t.index ["product_item_id"], name: "index_order_product_items_on_product_item_id"
  end

  create_table "order_receive_list_lot_products", force: :cascade do |t|
    t.bigint "order_receive_list_id"
    t.bigint "product_item_id"
    t.bigint "order_shipment_list_lot_product_id"
    t.boolean "is_received", default: false
    t.boolean "is_deleted", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_receive_list_id"], name: "orl_receive_list"
    t.index ["order_shipment_list_lot_product_id"], name: "orl_list_lot_product"
    t.index ["product_item_id"], name: "orl_product_item"
  end

  create_table "order_receive_lists", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "order_shipment_list_id"
    t.integer "quantity"
    t.integer "adjusted_quantity"
    t.boolean "is_deleted"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_item_id"
    t.index ["order_id"], name: "index_order_receive_lists_on_order_id"
    t.index ["order_shipment_list_id"], name: "index_order_receive_lists_on_order_shipment_list_id"
  end

  create_table "order_shipment_list_lot_products", force: :cascade do |t|
    t.bigint "order_shipment_list_id"
    t.bigint "product_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_shipment_list_id"], name: "osl_shipment_list"
    t.index ["product_item_id"], name: "osl_product_item"
  end

  create_table "order_shipment_lists", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "order_item_id"
    t.integer "from_location"
    t.integer "requested_quantity"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_item_id"
    t.index ["order_id"], name: "index_order_shipment_lists_on_order_id"
    t.index ["order_item_id"], name: "index_order_shipment_lists_on_order_item_id"
    t.index ["product_item_id"], name: "index_order_shipment_lists_on_product_item_id"
  end

  create_table "order_shipments", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "carrier_id"
    t.date "shipment_date"
    t.string "tracking_ids"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_id"], name: "index_order_shipments_on_carrier_id"
    t.index ["order_id"], name: "index_order_shipments_on_order_id"
  end

  create_table "order_team_members", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "user_id"
    t.datetime "email_sent_at"
    t.integer "email_sent_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_team_members_on_order_id"
    t.index ["user_id"], name: "index_order_team_members_on_user_id"
  end

  create_table "order_trackings", force: :cascade do |t|
    t.integer "order_id"
    t.integer "rma_order_id"
    t.integer "back_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "name"
    t.text "notes"
    t.bigint "manufacturer_id"
    t.integer "from_location_id"
    t.integer "to_location_id"
    t.integer "last_modified_by"
    t.datetime "last_modified_on"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_type"
    t.index ["manufacturer_id"], name: "index_orders_on_manufacturer_id"
    t.index ["name"], name: "index_orders_on_name"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_product_categories_on_title"
  end

  create_table "product_contents", force: :cascade do |t|
    t.bigint "product_id"
    t.integer "quantity"
    t.bigint "kit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kit_id"], name: "index_product_contents_on_kit_id"
    t.index ["product_id"], name: "index_product_contents_on_product_id"
  end

  create_table "product_item_contents", force: :cascade do |t|
    t.bigint "product_item_id"
    t.bigint "product_id"
    t.bigint "order_id"
    t.integer "quantity"
    t.integer "damaged_quantity"
    t.string "rma_number"
    t.boolean "is_damaged"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_received", default: false
    t.boolean "is_deleted", default: true
    t.integer "order_item_id"
    t.integer "adjusted_quantity"
    t.index ["order_id"], name: "index_product_item_contents_on_order_id"
    t.index ["product_id"], name: "index_product_item_contents_on_product_id"
    t.index ["product_item_id"], name: "index_product_item_contents_on_product_item_id"
  end

  create_table "product_items", force: :cascade do |t|
    t.string "serial_number"
    t.integer "location_id"
    t.integer "product_id"
    t.string "rma_number"
    t.boolean "is_deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "lot_name"
    t.date "expiration_date"
    t.integer "quantity"
    t.boolean "is_booked_for_ship", default: false
    t.boolean "is_damaged", default: false
    t.index ["location_id"], name: "index_product_items_on_location_id"
    t.index ["product_id"], name: "index_product_items_on_product_id"
  end

  create_table "product_locations", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "location_id"
    t.integer "quantity"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "threshold_quantity"
    t.index ["location_id"], name: "index_product_locations_on_location_id"
    t.index ["product_id", "location_id"], name: "index_product_locations_on_product_id_and_location_id"
    t.index ["product_id"], name: "index_product_locations_on_product_id"
    t.index ["user_id"], name: "index_product_locations_on_user_id"
  end

  create_table "product_media", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_primary"
    t.bigint "product_id"
    t.string "media"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_media_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "mfg_part"
    t.integer "manufacturer_id"
    t.integer "location_id"
    t.string "code"
    t.text "description"
    t.decimal "height"
    t.decimal "weight"
    t.decimal "width"
    t.decimal "depth"
    t.decimal "price"
    t.string "width_unit"
    t.string "height_unit"
    t.string "depth_unit"
    t.integer "category_1"
    t.integer "category_2"
    t.integer "category_3"
    t.string "warehouse_name"
    t.string "aisle"
    t.string "bin_bay"
    t.string "shelf"
    t.string "case_crate"
    t.string "tub_tube"
    t.integer "product_type"
    t.string "status"
    t.string "supplier_part_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "sub_type", default: 0
    t.index ["location_id"], name: "index_products_on_location_id"
    t.index ["manufacturer_id", "location_id"], name: "index_products_on_manufacturer_id_and_location_id"
    t.index ["manufacturer_id"], name: "index_products_on_manufacturer_id"
    t.index ["name"], name: "index_products_on_name"
  end

  create_table "rma_order_update_histories", force: :cascade do |t|
    t.integer "actual_order_id"
    t.integer "rma_order_id"
    t.integer "kit_id"
    t.boolean "kit_status"
    t.integer "kit_location_id"
    t.integer "product_id"
    t.integer "product_item_content_id"
    t.boolean "product_item_content_status"
    t.integer "product_item_content_damaged_quantity"
    t.integer "product_item_content_adjusted_quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "people"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "photo"
    t.string "user_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["first_name", "last_name"], name: "index_users_on_first_name_and_last_name"
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
  end

  add_foreign_key "order_histories", "orders"
  add_foreign_key "order_media", "orders"
  add_foreign_key "order_product_items", "locations"
  add_foreign_key "order_product_items", "order_items"
  add_foreign_key "order_product_items", "order_shipment_lists"
  add_foreign_key "order_product_items", "orders"
  add_foreign_key "order_product_items", "product_items"
  add_foreign_key "order_product_items", "products"
  add_foreign_key "order_receive_list_lot_products", "order_receive_lists"
  add_foreign_key "order_receive_list_lot_products", "order_shipment_list_lot_products"
  add_foreign_key "order_receive_list_lot_products", "product_items"
  add_foreign_key "order_receive_lists", "order_shipment_lists"
  add_foreign_key "order_receive_lists", "orders"
  add_foreign_key "order_shipment_list_lot_products", "order_shipment_lists"
  add_foreign_key "order_shipment_list_lot_products", "product_items"
  add_foreign_key "order_shipments", "carriers"
  add_foreign_key "order_shipments", "orders"
  add_foreign_key "order_team_members", "orders"
  add_foreign_key "order_team_members", "users"
  add_foreign_key "orders", "manufacturers"
  add_foreign_key "orders", "users"
  add_foreign_key "product_contents", "products"
  add_foreign_key "product_contents", "products", column: "kit_id"
  add_foreign_key "product_item_contents", "orders"
  add_foreign_key "product_item_contents", "product_items"
  add_foreign_key "product_item_contents", "products"
  add_foreign_key "product_locations", "locations"
  add_foreign_key "product_locations", "products"
  add_foreign_key "product_locations", "users"
  add_foreign_key "product_media", "products"
end
