require_relative '../spec_helper'
require 'pavlov'

describe ActiveModel::Validations::StringValidator do
  describe '#valid?' do
    let('test_class') do
      Class.new Pavlov::Entity do
        attributes :id
        validate_string :id
      end
    end

    it 'returns false when the attribute is not set' do
      entity = test_class.new

      expect(entity.invalid?).to eq true
    end

    it 'returns false when attribute id is nil' do
      entity = test_class.new id: nil

      expect(entity.invalid?).to eq true
    end

    it 'returns false when attribute id is a number' do
      entity = test_class.new id: 1234567890

      expect(entity.invalid?).to eq true
    end

    it 'returns true when attribute id is a empty string' do
      entity = test_class.new id: ''

      expect(entity.valid?).to eq true
    end

    it 'returns true when attribute id is a string' do
      entity = test_class.new id: 'abcdefgh'

      expect(entity.valid?).to eq true
    end
  end

  describe '#errors' do
    let('test_class') do
      Class.new Pavlov::Entity do
        attributes :id
        validate_string :id
      end
    end

    it 'errors contains correct error message' do
      entity = test_class.new id: 1234567890

      expect(entity.invalid?).to eq true
      expect(entity.errors.size).to eq 1
      expect(entity.errors[:id]).to eq ['should be a string.']
    end
  end

  describe '.validate_string' do
    let('test_class_with_multiple_arguments') do
      Class.new Pavlov::Entity do
        attributes :id, :parentid
        validate_string :id, :parentid
      end
    end

    it 'works with multiple arguments' do
      entity = test_class_with_multiple_arguments.new

      expect(entity.invalid?).to eq true
      expect(entity.errors.size).to eq 2

      entity.update id: 'abcdef', parentid: 'abcdef'

      expect(entity.valid?).to eq true
    end

    let('test_class_with_array_arguments') do
      Class.new Pavlov::Entity do
        attributes :id, :parentid
        validate_string [:id, :parentid]
      end
    end

    it 'accepts array as argument' do
      entity = test_class_with_array_arguments.new

      expect(entity.invalid?).to eq true
      expect(entity.errors.size).to eq 2

      entity.update id: 'abcdef', parentid: 'abcdef'

      expect(entity.valid?).to eq true
    end

    let('test_class_with_allow_blank') do
      Class.new Pavlov::Entity do
        attributes :id
        validate_string :id, allow_blank: true
      end
    end

    it 'accepts allow blank when value is not set' do
      entity = test_class_with_allow_blank.new

      expect(entity.valid?).to eq true

      entity.update id: 1234567890

      expect(entity.invalid?).to eq true
    end

    it 'accepts allow blank when value is a empty string' do
      entity = test_class_with_allow_blank.new id: ''

      expect(entity.valid?).to eq true

      entity.update id: 1234567890

      expect(entity.invalid?).to eq true
    end

    let('test_class_with_non_empty') do
      Class.new Pavlov::Entity do
        attributes :id
        validate_string :id, non_empty: true
      end
    end

    it 'does not accept empty string when non_empty is set' do
      entity = test_class_with_non_empty.new id: ''

      expect(entity.invalid?).to eq true

      entity.update id: 'test'

      expect(entity.valid?).to eq true
    end
  end
end
