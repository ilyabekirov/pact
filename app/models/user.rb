# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_interests
  has_many :interests, through: :user_interests
  has_many :user_skills
  has_many :skills, through: :user_skills, class_name: 'Skill'

  validates :email, uniqueness: true
end
