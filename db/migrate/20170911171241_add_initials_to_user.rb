# frozen_string_literal: true

class AddInitialsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :initials, :string, length: 2
  end
end
