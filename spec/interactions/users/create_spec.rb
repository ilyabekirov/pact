# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Create do
  let(:valid_params) do
    {
      name: 'Иван',
      surname: 'Иванов',
      patronymic: 'Иванович',
      email: 'ivan@example.com',
      age: 30,
      nationality: 'Russian',
      country: 'Russia',
      gender: 'male',
      interests: ['programming'],
      skills: 'Ruby, Rails'
    }
  end

  describe '.run' do
    context 'with valid params' do
      it 'creates a user with interests and skills' do
        outcome = described_class.run(valid_params)
        expect(outcome).to be_valid
        user = outcome.result
        expect(user.user_full_name).to eq('Иванов Иван Иванович')
        expect(user.interests.pluck(:name)).to include('programming')
        expect(user.skills.pluck(:name)).to include('Ruby', 'Rails')
      end
    end

    context 'with invalid params' do
      it 'fails with invalid email' do
        invalid_params = valid_params.merge(email: 'invalid')
        outcome = described_class.run(invalid_params)
        expect(outcome).not_to be_valid
        expect(outcome.errors[:email]).to include('is invalid')
      end

      it 'fails with age out of range' do
        invalid_params = valid_params.merge(age: 100)
        outcome = described_class.run(invalid_params)
        expect(outcome).not_to be_valid
        expect(outcome.errors[:age]).to include('must be less than or equal to 90')
      end
    end
  end
end
