# frozen_string_literal: true

FactoryBot.define do
  factory :robot_position, class: 'Position' do
    current_position { '10,10' }
    association :positionable, factory: :robot
  end

  factory :first_crate_position, class: 'Position' do
    current_position { '5,5' }
    association :positionable, factory: :crate
  end

  factory :second_crate_position, class: 'Position' do
    current_position { '1,1' }
    association :positionable, factory: :crate
  end
end
