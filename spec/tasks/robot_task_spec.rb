# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "robot", type: :task do

  before(:each) do
    Rake::Task['robot:init'].reenable
  end

  it 'should have one robot' do
    Rake.application.invoke_task("robot:init")
    expect(Robot.count).to eql 1
  end

  it 'should have two crates' do
    Rake.application.invoke_task("robot:init")
    expect(Crate.count).to eql 2
  end

  it 'should have the robot in the correct starting position' do
    Rake.application.invoke_task("robot:init")
    expect(Robot.first.position.to_coordinates).to eql '10,10'
  end

  it 'should have the crates in the correct starting position' do
    Rake.application.invoke_task("robot:init")
    expect(Crate.first.position.to_coordinates).to eql '5,5'
    expect(Crate.second.position.to_coordinates).to eql '1,1'
  end
end
