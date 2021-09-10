require 'rails_helper'

RSpec.describe Crate, type: :model do
  let(:robot) { build(:robot, position: build(:robot_position)) }
  let(:first_crate) { create(:crate, position: build(:first_crate_position)) }

  before(:each) do
    robot.save!
    @first_crate = first_crate
    @test_robot = Robot.first
  end

  it { should validate_presence_of(:position) }
  it { should have_one(:position) }


  describe '.crate_coordinates' do
    it 'should return the position as coordinates' do
      described_class.all.each do |crate|
        expect(described_class.crate_coordinates).to include crate.position.to_coordinates
      end
    end

    it 'should not return coordinates of other models' do
      Position.select(:current_position).where.not(positionable_type: 'Crate').each do |not_crate|
        expect(described_class.crate_coordinates).to_not include not_crate.to_coordinates
      end
    end
  end

  describe '.at_coordinates' do
    it 'should return the Crate at the specified coordinates' do
      coordinates = @first_crate.position.to_coordinates.split(',')
      expect(described_class.at_coordinates(coordinates[0].to_i, coordinates[1].to_i)).to eql @first_crate
    end

    it 'should return nil for no Crate at the specified coordinates.' do
      coordinates = @first_crate.position.to_coordinates.split(',')
      expect(described_class.at_coordinates(coordinates[0].to_i + 1, coordinates[1].to_i)).to eql nil
    end
  end

  describe '#grabbed?' do
    it "should show that the Crate is in the Robot's grabber." do
      @test_robot.position.update current_position: @first_crate.position.to_coordinates
      @test_robot.control('G')
      expect(@first_crate.grabbed?).to eql true
    end

    it "should show that the Crate is not in the Robot's grabber." do
      expect(@first_crate.grabbed?).to eql false
    end
  end
end
