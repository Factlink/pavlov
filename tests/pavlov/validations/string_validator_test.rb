require 'minitest/autorun'
require_relative '../../../lib/pavlov/validations/string_validator'

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

      assert entity.invalid?
    end

    it 'returns false when attribute id is nil' do
      entity = test_class.new id: nil

      assert entity.invalid?
    end

    it 'returns false when attribute id is a number' do
      entity = test_class.new id: 1234567890

      assert entity.invalid?
    end

    it 'returns true when attribute id is a empty string' do
      entity = test_class.new id: ''

      assert entity.valid?
    end

    it 'returns true when attribute id is a string' do
      entity = test_class.new id: 'abcdefgh'

      assert entity.valid?
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

      assert entity.invalid?
      entity.errors.size.must_equal 1
      entity.errors[:id].must_equal ['should be a string.']
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

      assert entity.invalid?
      entity.errors.size.must_equal 2

      entity.update id: 'abcdef', parentid: 'abcdef'

      assert entity.valid?
    end

    let('test_class_with_array_arguments') do
      Class.new Pavlov::Entity do
        attributes :id, :parentid
        validate_string [:id, :parentid]
      end
    end

    it 'accepts array as argument' do
      entity = test_class_with_array_arguments.new

      assert entity.invalid?
      entity.errors.size.must_equal 2

      entity.update id: 'abcdef', parentid: 'abcdef'

      assert entity.valid?
    end

    let('test_class_with_allow_blank') do
      Class.new Pavlov::Entity do
        attributes :id
        validate_string :id, allow_blank: true
      end
    end

    it 'accepts allow blank when value is not set' do
      entity = test_class_with_allow_blank.new

      assert entity.valid?

      entity.update id: 1234567890

      assert entity.invalid?
    end

    it 'accepts allow blank when value is a empty string' do
      entity = test_class_with_allow_blank.new id: ''

      assert entity.valid?

      entity.update id: 1234567890

      assert entity.invalid?
    end
  end
end
