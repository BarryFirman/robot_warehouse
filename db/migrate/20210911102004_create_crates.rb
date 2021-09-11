class CreateCrates < ActiveRecord::Migration[6.1]
  def change
    create_table :crates do |t|

      t.timestamps
    end
  end
end
