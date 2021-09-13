# frozen_string_literal: true

class CreatePositions < ActiveRecord::Migration[6.1]
  def change
    create_table 'positions', force: :cascade do |t|
      t.point 'current_position'
      t.string 'positionable_type', null: false
      t.bigint 'positionable_id', null: false
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.index %w[positionable_type positionable_id], name: 'index_positions_on_positionable'
    end
  end
end
