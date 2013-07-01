require_relative '../spec_helper'
require 'pavlov'

describe ActiveModel::Validations::IntegerStringValidator do
  describe '#valid?' do
    let('test_class') do
      Class.new Pavlov::Entity do
        attributes :id
        validate_integer_string :id
      end
    end

    it 'returns false when the attribute is not set' do
      entity = test_class.new

      expect(entity.valid?).to eq false
    end

    it 'returns false when attribute id is nil' do
      entity = test_class.new id: nil

      expect(entity.valid?).to eq false
    end

    it 'returns false when attribute id is a integer' do
      entity = test_class.new id: 9876543210

      expect(entity.valid?).to eq false
    end

    it 'returns true when attribute id is a string with a valid integer' do
      entity = test_class.new id: '9876543210'

      expect(entity.valid?).to eq true
    end
  end

  describe '#errors' do
    let('test_class') do
      Class.new Pavlov::Entity do
        attributes :id
        validate_integer_string :id
      end
    end

    it 'errors contains correct error message' do
      entity = test_class.new id: 'ghjk'

      expect(entity.invalid?).to eq true
      expect(entity.errors.size).to eq 1
      expect(entity.errors[:id]).to eq ['should be a integer string.']
    end
  end

  describe '.validate_integer_string' do
    let('test_class_with_multiple_arguments') do
      Class.new Pavlov::Entity do
        attributes :id, :parentid
        validate_integer_string :id, :parentid
      end
    end

    it 'works with multiple arguments' do
      entity = test_class_with_multiple_arguments.new

      expect(entity.invalid?).to eq true
      expect(entity.errors.size).to eq 2

      entity.update id: '1234567890', parentid: '1234567890'

      expect(entity.valid?).to eq true
    end

    let('test_class_with_array_arguments') do
      Class.new Pavlov::Entity do
        attributes :id, :parentid
        validate_integer_string [:id, :parentid]
      end
    end

    it 'accepts array as argument' do
      entity = test_class_with_array_arguments.new

      expect(entity.invalid?).to eq true
      expect(entity.errors.size).to eq 2

      entity.update id: '1234567890', parentid: '1234567890'

      expect(entity.valid?).to eq true
    end

    let('test_class_with_allow_blank') do
      Class.new Pavlov::Entity do
        attributes :id
        validate_integer_string :id, allow_blank: true
      end
    end

    it 'accepts allow blank' do
      entity = test_class_with_allow_blank.new

      expect(entity.valid?).to eq true

      entity.update id: 'ghijklmnopq'

      expect(entity.invalid?).to eq true
    end
  end
end
