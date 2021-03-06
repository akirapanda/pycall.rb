module PyCall
  class Tuple
    include PyObjectWrapper

    def self.new(init)
      case init
      when Integer
        super(LibPython.PyTuple_New(init))
      when Array
        tuple = new(init.length)
        init.each_with_index do |obj, index|
          tuple[index] = obj
        end
        tuple
      when LibPython::PyObjectStruct
        super(init)
      end
    end

    # Make tuple from array
    def self.[](*ary)
      new(ary)
    end

    def size
      LibPython.PyTuple_Size(__pyobj__)
    end

    alias length size

    def [](index)
      LibPython.PyTuple_GetItem(__pyobj__, index).to_ruby
    end

    def []=(index, value)
      value = Conversions.from_ruby(value)
      LibPython.PyTuple_SetItem(__pyobj__, index, value)
    end

    def to_a
      Array.new(length) {|i| self[i] }
    end

    alias to_ary to_a
  end
end
