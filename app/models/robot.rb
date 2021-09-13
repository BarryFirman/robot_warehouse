# frozen_string_literal: true

class Robot < ApplicationRecord
  has_one :position, as: :positionable

  validates_presence_of :position
  validates_associated :position

  validate :ensure_one_robot, on: :create

  MOVE_COMMANDS = %w[N E S W].freeze
  ACTION_COMMANDS = %w[G D].freeze

  def self.present?
    Robot.count.positive?
  end

  def control(commands)
    return return_status(success: false, messages: ['invalid command detected']) unless valid_commands commands

    commands.split(' ').each do |command|
      return return_position(success: false) if move_command?(command) && !move(command)

      next unless action_command?(command)

      case command
      when 'G'
        grabbed = grab
        return grabbed unless grabbed[:success]

      when 'D'
        dropped = drop
        return dropped unless dropped[:success]

      end
    end

    return_position(success: true)
  end

  def move(command)
    case command
    when 'N'
      position.current_position.y -= 1
    when 'S'
      position.current_position.y += 1
    when 'E'
      position.current_position.x += 1
    when 'W'
      position.current_position.x -= 1
    end

    position.save
  end

  def grab
    return return_status(success: false, messages: ['grabber is full']) if grabber_full?

    crate = Crate.at_coordinates(position.current_position.x, position.current_position.y)
    return return_status(success: false, messages: ['nothing to grab']) if crate.nil?

    update! crate_id: crate.id
    return_status(success: true, messages: nil)
  end

  def drop
    return return_status(success: false, messages: ['nothing to drop']) if crate_id.nil?

    return return_status(success: false, messages: ['position taken']) if Position.taken?(position.to_coordinates)

    crate = Crate.find(crate_id)
    crate.position.update current_position: position.to_coordinates
    update crate_id: nil
    return_status(success: true, messages: nil)
  end

  def grabber_full?
    crate_id.present?
  end

  private

  def return_status(success:, messages:)
    grabber = crate_id.present? ? 'full' : 'empty'
    data = { position: position.reload.to_coordinates, grabber: grabber }
    { success: success, messages: messages, data: data }
  end

  def valid_commands(commands)
    commands.split(' ').each do |command|
      return false unless MOVE_COMMANDS.include?(command) || ACTION_COMMANDS.include?(command)
    end
  end

  def move_command?(command)
    MOVE_COMMANDS.include?(command)
  end

  def action_command?(command)
    ACTION_COMMANDS.include?(command)
  end

  def return_position(success:)
    if success
      return_status(success: true, messages: nil)
    else
      messages = position.errors.messages.map { |_, v| v }.flatten
      return_status(success: false, messages: messages)
    end
  end

  def ensure_one_robot
    errors.add(:robot, 'already present') if Robot.present?
  end
end
