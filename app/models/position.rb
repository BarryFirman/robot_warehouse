# frozen_string_literal: true

class Position < ApplicationRecord
  belongs_to :positionable, polymorphic: true

  UPPER_BOUND_X = 10
  UPPER_BOUND_Y = 10
  LOWER_BOUND_X = 1
  LOWER_BOUND_Y = 1

  validates_presence_of :current_position

  validate :ensure_in_boundary
  validate :ensure_not_taken



  def self.positions_taken
    Position.all.filter_map do |position|
      position.to_coordinates unless position.positionable_type == 'Robot' || position.positionable_type.constantize.find(position.positionable_id).grabbed?
    end
  end

  def self.taken?(position)
    positions_taken.include?(position)
  end

  def to_coordinates
    "#{current_position.x.to_i},#{current_position.y.to_i}"
  end

  def in_boundary?
    in_upper_boundary? && in_lower_boundary?
  end

  private

  def ensure_in_boundary
    return if current_position.nil?

    errors.add(:current_position, 'out of bounds') unless in_boundary?
  end

  def ensure_not_taken
    return if current_position.nil?

    errors.add(:current_position, 'taken') if Position.taken? [current_position.x, current_position.y]
  end

  def in_upper_boundary?
    (LOWER_BOUND_Y..UPPER_BOUND_Y).include?(current_position.y)
  end

  def in_lower_boundary?
    (LOWER_BOUND_X..UPPER_BOUND_X).include?(current_position.x)
  end
end
