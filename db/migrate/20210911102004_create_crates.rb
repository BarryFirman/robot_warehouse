# frozen_string_literal: true

class CreateCrates < ActiveRecord::Migration[6.1]
  def change
    create_table :crates, &:timestamps
  end
end
