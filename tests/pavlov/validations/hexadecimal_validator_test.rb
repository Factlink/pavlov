require 'minitest/autorun'
require_relative '../../../lib/pavlov/validations/hexadecimal_validator'

describe ActiveModel::Validations::HexadecimalValidator do
  describe '#valid?' do
    let('test_class') do
      Class.new Pavlov::Entity do
        attributes :id
        validate_hexadecimal_string :id
      end
    end

    it 'returns false when the attribute is not set' do
      entity = test_class.new
      entity.valid?.must_equal false
    end

    it 'returns false when attribute id is nil' do
      entity = test_class.new id: nil 
      entity.valid?.must_equal false
    end

    it 'returns false when attribute id is a non-hexidecimal string' do
      entity = test_class.new id: 'ghjkl'
      entity.valid?.must_equal false
    end

    it 'returns true when attribute id is a valid hexadecimal string' do
      entity = test_class.new id: '9876543210abcdef'
      entity.valid?.must_equal true
    end
  end

  describe '#errors' do
    let('test_class') do
      Class.new Pavlov::Entity do
        attributes :id
        validate_hexadecimal_string :id
      end
    end

    it 'errors contains correct error message' do
      entity = test_class.new id: 'ghjk'
      assert entity.invalid?
      entity.errors[:id].must_equal ['should be an hexadecimal string.']
    end    
  end

  describe '.validate_hexadecimal_string' do
    let('test_class_with_multiple_arguments') do
      Class.new Pavlov::Entity do
        attributes :id, :parentid
        validate_hexadecimal_string :id, :parentid
      end
    end

    it 'works with multiple arguments' do
      entity = test_class_with_multiple_arguments.new
      assert entity.invalid?

      entity.update id: '9876543210abcdef', parentid: '9876543210abcdef'
      assert entity.valid?
    end

    let('test_class_with_array_arguments') do
      Class.new Pavlov::Entity do
        attributes :id, :parentid
        validate_hexadecimal_string [:id, :parentid]
      end
    end

    it 'accepts array as argument' do
      entity = test_class_with_array_arguments.new 
      assert entity.invalid?

      entity.update id: '9876543210abcdef', parentid: '9876543210abcdef'
      assert entity.valid?
    end

    let('test_class_with_allow_blank') do
      Class.new Pavlov::Entity do
        attributes :id
        validate_hexadecimal_string :id, allow_blank: true
      end
    end

    it 'accepts allow blank' do
      entity = test_class_with_allow_blank.new 
      assert entity.valid?

      entity.update id: 'ghijklmnopq'
      assert entity.invalid?
    end
  end
end