# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Position, type: :model do
  let(:robot) { build(:robot, position: build(:robot_position)) }
  let(:first_crate) { create(:crate, position: build(:first_crate_position)) }
  let(:second_crate) { create(:crate, position: build(:second_crate_position)) }

  before(:each) do
    robot.save!
    @first_crate = first_crate
    @second_crate = second_crate
    @test_robot = Robot.first
  end

  it { should validate_presence_of(:current_position) }
  it { should belong_to(:positionable) }

  it 'should be invalid without positionable' do
    test_position = Position.new
    expect(test_position).to be_invalid
    expect(test_position.errors.messages).to include :positionable
    expect(test_position.errors.messages).to include :current_position
  end

  describe '.positions_taken' do
    it 'should show the correct positions of the crates' do
      Position.select(:current_position).where(positionable_type: 'Crate').each do |crate_position|
        expect(described_class.positions_taken).to include crate_position.to_coordinates
      end
    end
  end

  describe '.taken?' do
    it 'should show position is taken' do
      Position.select(:current_position).where(positionable_type: 'Crate').each do |crate_position|
        expect(described_class.taken?(crate_position.to_coordinates)).to be true
      end
    end
  end

  describe '#to_coordinates' do
    it 'should return string representation of current_position x and y coordinates' do
      expect(described_class.first.to_coordinates).to include described_class.first.current_position.x.to_i.to_s
      expect(described_class.first.to_coordinates).to include described_class.first.current_position.y.to_i.to_s
    end
  end

  describe '.in_boundary?' do
    it 'should return true - in boundary ' do
      position = described_class.new current_position: "#{Position::UPPER_BOUND_X},  #{Position::UPPER_BOUND_Y}"
      expect(position.in_boundary?).to be true
      position = described_class.new current_position: "#{Position::LOWER_BOUND_X},  #{Position::LOWER_BOUND_Y}"
      expect(position.in_boundary?).to be true
    end

    it 'should return false - in not boundary ' do
      position = described_class.new current_position: "#{Position::UPPER_BOUND_X + 1},  #{Position::UPPER_BOUND_Y}"
      expect(position.in_boundary?).to be false
      position = described_class.new current_position: "#{Position::UPPER_BOUND_X},  #{Position::UPPER_BOUND_Y + 1}"
      expect(position.in_boundary?).to be false
      position = described_class.new current_position: "#{Position::LOWER_BOUND_X - 1},  #{Position::LOWER_BOUND_Y}"
      expect(position.in_boundary?).to be false
      position = described_class.new current_position: "#{Position::LOWER_BOUND_X},  #{Position::LOWER_BOUND_Y - 1}"
      expect(position.in_boundary?).to be false
    end
  end
end
