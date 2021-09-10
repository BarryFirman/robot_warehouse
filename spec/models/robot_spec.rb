require 'rails_helper'

RSpec.describe Robot, type: :model do

  let(:robot) { build(:robot, position: build(:robot_position)) }
  let(:first_crate) { create(:crate, position: build(:first_crate_position)) }
  let(:second_crate) { create(:crate, position: build(:second_crate_position)) }

  before(:each) do
    robot.save!
    @test_robot = Robot.first
  end

  it { should validate_presence_of(:position) }

  it 'should create a robot' do
    expect(Robot.count).to eql 1
    expect(Position.count).to eql 1
  end

  it 'should only be one robot' do
    test_robot = Robot.new
    expect(test_robot.valid?).to be false
    expect(test_robot.errors.messages[:robot]).to eq ['already present']
  end

  describe '#control' do
    it 'should move in the right direction - North' do
      @test_robot = Robot.first
      @test_robot.position.update current_position: '5,5'
      expect { @test_robot.control('N') }.to change {@test_robot.reload.position.current_position.y }.by -1
    end

    it 'should move in the right direction - East' do
      @test_robot = Robot.first
      @test_robot.position.update current_position: '5,5'
      expect { @test_robot.control('E') }.to change {@test_robot.reload.position.current_position.x }.by 1
    end

    it 'should move in the right direction - South' do
      @test_robot = Robot.first
      @test_robot.position.update current_position: '5,5'
      expect { @test_robot.control('S') }.to change {@test_robot.reload.position.current_position.y }.by 1
    end

    it 'should move in the right direction - West' do
      @test_robot = Robot.first
      @test_robot.position.update current_position: '5,5'
      expect { @test_robot.control('W') }.to change {@test_robot.reload.position.current_position.x }.by -1
    end

    it 'will not accept invalid commands' do
      robot.save
      @test_robot = Robot.first
      current_position = @test_robot.position.to_coordinates
      expected = { messages: ['invalid command detected'], success: false, data: { grabber: 'empty',
                                                                                  position: current_position } }
      expect(@test_robot.control('S S R')).to eq(expected)
      expect(@test_robot.position.to_coordinates).to eq current_position
    end

    context 'interacting with crates' do
      it 'pick up the first crate and put it to the right of the second one' do
        first_crate
        second_crate

        @test_robot = Robot.first
        expected = { messages: nil, success: true, data: { grabber: 'empty', position: '6,5' } }
        expect(@test_robot.control('N N N N N N N N N W W W W W W W W W G S S S S E E E E E D')).to eq(expected)
        expect(Position.positions_taken).to include('5,5')
        expect(Position.positions_taken).to include('6,5')
      end

      it 'should not put the first crate on the second one' do
        robot.save
        first_crate
        second_crate

        @test_robot = Robot.first
        expected = { messages: ['position taken'], success: false, data: { grabber: 'full', position: '5,5' } }
        expect(@test_robot.control('N N N N N N N N N W W W W W W W W W G S S S S E E E E D')).to eq(expected)
        expect(Position.positions_taken).to eq(%w[5,5])
        expect(@test_robot.grabber_full?).to be true
      end

      it 'should not pick something up if nothing is there.' do
        @test_robot = Robot.first
        current_position = @test_robot.position.to_coordinates
        expected = { messages: ['nothing to grab'], success: false, data: { grabber: 'empty', position: current_position } }
        expect(@test_robot.control('G')).to eq(expected)
      end
    end
  end
end
