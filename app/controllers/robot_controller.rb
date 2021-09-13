class RobotController < ApplicationController
  before_action :load_robot

  def update
    control = @robot.control(robot_params[:commands])
    json_response messages: control[:messages], data: control[:data], status: control[:success]
  end

  private

  def robot_params
    params.require(:robot).permit(:commands)
  end

  def load_robot
    @robot = Robot.first
  end
end
