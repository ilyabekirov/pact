# frozen_string_literal: true

module Users
  class Create < ActiveInteraction::Base
    GENDERS = %w[male female].freeze

    string :name
    string :surname
    string :patronymic
    string :email
    integer :age
    string :nationality
    string :country
    string :gender
    array :interests, default: -> { [] }
    string :skills, default: -> { '' }

    validates :name, :surname, :patronymic, :email, :age, :nationality, :country, :gender, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :age, numericality: { greater_than: 0, less_than_or_equal_to: 90 }
    validates :gender, inclusion: { in: GENDERS }

    def execute
      user = User.new(user_params)
      user.user_full_name = generate_full_name

      ActiveRecord::Base.transaction do
        assign_interests(user)
        assign_skills(user)
        errors.merge!(user.errors) unless user.save
      end

      user
    end

    private

    def user_params
      inputs.slice(:name, :surname, :patronymic, :email, :age, :nationality, :country, :gender)
    end

    def generate_full_name
      [surname, name, patronymic].join(' ')
    end

    def assign_interests(user)
      interests.each do |interest_name|
        interest = Interest.find_or_create_by(name: interest_name)
        user.interests << interest unless user.interests.include?(interest)
      end
    end

    def assign_skills(user)
      skills.split(',').each do |skill_name|
        stripped_name = skill_name.strip
        next if stripped_name.blank?

        skill = Skill.find_or_create_by(name: stripped_name)
        user.skills << skill unless user.skills.include?(skill)
      end
    end
  end
end
