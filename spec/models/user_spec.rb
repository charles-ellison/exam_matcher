require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context 'when the user has valid attributes' do
      it 'returns true' do
        user = User.new(first_name: 'bob', last_name: 'jones', phone_number: '0123456789')
        expect(user.valid?).to eq true
      end
    end
    
    context 'when the first_name is not present' do
      it 'returns false' do
        user = User.new(last_name: 'jones', phone_number: '0123456789')
        errors = { first_name: ['can\'t be blank'] }
        expect(user.valid?).to eq false
        expect(user.errors.messages).to eq errors
      end
    end

    context 'when the last name is not present' do
      it 'returns false' do
        user = User.new(first_name: 'bob', phone_number: '0123456789')
        errors = { last_name: ['can\'t be blank'] }
        expect(user.valid?).to eq false
        expect(user.errors.messages).to eq errors
      end
    end

    context 'when the phone number is not present' do
      it 'returns false' do
        user = User.new(first_name: 'bob', last_name: 'jones')
        errors = { phone_number: ['cannot be blank', 'must be ten characters long'] }
        expect(user.valid?).to eq false
        expect(user.errors.messages).to eq errors
      end
    end
    
    context 'when the phone number is not ten characters long' do
      it 'returns false' do
        user = User.new(first_name: 'bob', last_name: 'jones', phone_number: '123456789')
        errors = { phone_number: ['must be ten characters long'] }
        expect(user.valid?).to eq false
        expect(user.errors.messages).to eq errors
      end
    end

    context 'when it contains non numbers' do
      it 'returns false' do
        user = User.new(first_name: 'bob', last_name: 'jones', phone_number: '123-456-89')
        errors = { phone_number: ['must only contain numeric values'] }
        expect(user.valid?).to eq false
        expect(user.errors.messages).to eq errors
      end
    end
  end
end
