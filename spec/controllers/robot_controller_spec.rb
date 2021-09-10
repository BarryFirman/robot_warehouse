require 'rails_helper'

RSpec.describe RobotController, type: :controller do
  let(:robot) { build(:robot, position: build(:robot_position)) }
  let(:first_crate) { create(:crate, position: build(:first_crate_position)) }
  let(:second_crate) { create(:crate, position: build(:second_crate_position)) }

  before(:each) do
    robot.save!
    @test_robot = Robot.first
  end

  describe 'POST #update' do
    it 'returns http success' do
      post :update, params: { robot: { commands: 'W N W N' } }
      expect(response).to have_http_status(:success)
    end

    it 'return the correct coordinates' do
      post :update, params: { robot: { commands: 'W N W N' } }
      expect(JSON.parse(response.body).dig('data', 'position')).to eq @test_robot.reload.position.to_coordinates
      expect(response).to have_http_status(:success)
    end

    it 'should not go out of bounds' do
      post :update, params: { robot: { commands: 'S' } }
      expect(JSON.parse(response.body)['messages']).to eq ['out of bounds']
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should pick up a crate' do
      first_crate
      post :update, params: { robot: { commands: 'N N N N N W W W W W G' } }
      expect(JSON.parse(response.body).dig('data', 'grabber')).to eq 'full'
      expect(response).to have_http_status(:success)
    end

    it 'should return the correct error if it tries to pick a crate up at an empty position' do
      post :update, params: { robot: { commands: 'G' } }
      expect(JSON.parse(response.body)['messages']).to eq ['nothing to grab']
      expect(@test_robot.grabber_full?).to eq false
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should not try to drop a crate on another crate' do
      first_crate
      second_crate
      post :update, params: { robot: { commands: 'N N N N N N N N N W W W W W W W W W G S S S S E E E E D' } }
      expect(JSON.parse(response.body)['messages']).to eq ['position taken']
      expect(JSON.parse(response.body).dig('data', 'grabber')).to eq 'full'
      expect(@test_robot.reload.grabber_full?).to eq true
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
