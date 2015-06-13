class CreateBites < ActiveRecord::Migration
  def change
    create_table :bites do |t|
      t.references :content, polymorphic: true, index: true
    end
  end
end
