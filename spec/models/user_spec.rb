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
        errors = { phone_number: ['Validation failed: phone number cannot be blank', 'Validation failed: phone number must be ten characters long'] }
        expect(user.valid?).to eq false
        expect(user.errors.messages).to eq errors
      end
    end
    
    context 'when the phone number is not ten characters long' do
      it 'returns false' do
        user = User.new(first_name: 'bob', last_name: 'jones', phone_number: '123456789')
        errors = { phone_number: ['Validation failed: phone number must be ten characters long'] }
        expect(user.valid?).to eq false
        expect(user.errors.messages).to eq errors
      end
    end

    context 'when it contains non numbers' do
      it 'returns false' do
        user = User.new(first_name: 'bob', last_name: 'jones', phone_number: '123-456-89')
        errors = { phone_number: ['Validation failed: phone number must only contain numeric values'] }
        expect(user.valid?).to eq false
        expect(user.errors.messages).to eq errors
      end
    end
  end

  describe 'find_or_create_user' do
    context 'when a user is found with the given params' do
      it 'returns the user' do
        user_params = { first_name: 'bob' }
        user = User.new

        allow(User).to receive(:find_by)
          .with(user_params)
          .and_return(user)
        
        expect(User.find_or_create_user(user_params)).to eq user
      end
    end

    context 'when the user is not found with the given params' do
      it 'creates a new user' do
        user_params = { first_name: 'bob' }
        user = User.new

        allow(User).to receive(:find_by)
          .with(user_params)
          .and_return(nil)
        
        allow(User).to receive(:new)
          .with(user_params)
          .and_return(user)

        expect(User).to receive(:create!)
          .and_return(user)

        actual = User.find_or_create_user(user_params)
        
        expect(actual).to eq user
      end
    end
    
    context 'when the user is invalid' do
      it 'raises an exception' do
        user_params = { first_name: 'bob' }
        
        expect {
          User.find_or_create_user(user_params)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
