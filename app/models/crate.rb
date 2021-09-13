# frozen_string_literal: true

class Crate < ApplicationRecord
  has_one :position, as: :positionable

  validates_presence_of :position
  validates_associated :position

  def self.crate_coordinates
    Crate.all.filter_map { |crate| crate.position.to_coordinates unless crate.grabbed? }
  end

  def self.at_coordinates(x_pos, y_pos)
    crate_positions = Position.select(:positionable_id).where('current_position[0] = ?', x_pos)
                              .where('current_position[1] = ?', y_pos)
                              .where(positionable_type: 'Crate')

    Crate.find(crate_positions[0].positionable_id) if crate_positions.count == 1
  end

  def grabbed?
    Robot.first.crate_id == id
  end
end
