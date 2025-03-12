# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  path '/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user,
        in: :body,
        schema: {
          type: :object,
          properties: {
            name: { type: :string, example: 'Иван' },
            surname: { type: :string, example: 'Иванов' },
            patronymic: { type: :string, example: 'Иванович' },
            email: { type: :string, example: 'ivan@example.com' },
            age: { type: :integer, example: 30 },
            nationality: { type: :string, example: 'Russian' },
            country: { type: :string, example: 'Russia' },
            gender: { type: :string, example: 'male', enum: %w[male female] },
            skills: { type: :string, example: 'Ruby, Rails' },
            interests: { type: :array, items: { type: :string }, example: %w[programming gaming] }
          },
          required: %w[name surname patronymic email age nationality country gender]
        }

      let(:user) do
        {
          name: 'Иван',
          surname: 'Иванов',
          patronymic: 'Иванович',
          email: 'ivan@example.com',
          age: 30,
          nationality: 'Russian',
          country: 'Russia',
          gender: 'male',
          skills: 'Ruby, Rails',
          interests: %w[programming gaming]
        }
      end

      response 201, :success do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            surname: { type: :string },
            patronymic: { type: :string },
            email: { type: :string },
            age: { type: :integer },
            nationality: { type: :string },
            country: { type: :string },
            gender: { type: :string },
            user_full_name: { type: :string }
          },
          required: %w[id name surname patronymic email age nationality country gender user_full_name]

        run_test! do
          json_response = response.parsed_body
          expect(json_response).to include('id')
          expect(User.count).to eq(1)
        end
      end

      response 422, :unprocessable_entity do
        let(:user) do
          {
            name: '',
            surname: 'Иванов',
            patronymic: 'Иванович',
            email: 'ivan@example.com',
            age: 30,
            nationality: 'Russian',
            country: 'Russia',
            gender: 'male',
            skills: 'Ruby',
            interests: ['programming']
          }
        end

        schema type: :object,
          properties: {
            errors: {
              type: :object,
              additionalProperties: {
                type: :array,
                items: { type: :string }
              }
            }
          },
          required: ['errors']

        run_test! do
          json_response = response.parsed_body
          expect(json_response).to include('errors')
          expect(json_response['errors']).to be_a(Hash)
          expect(User.count).to eq(0)
        end
      end

      response 400, :bad_request do
        let(:user) { { unexpected_key: 'value' } }

        schema type: :object,
          properties: {
            error: { type: :string }
          },
          required: ['error']

        run_test! do
          json_response = response.parsed_body
          expect(json_response['error']).to be_present
        end
      end
    end
  end
end
