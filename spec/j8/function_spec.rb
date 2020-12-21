# frozen_string_literal: true

RSpec.describe J8::Function do
  before(:each) do
    @function = J8::Function.new { |o| o + 3 }
  end

  describe '.new' do
    context 'when given a valid callable' do
      it 'then creates a new function' do
        expect(@function).to be_a(J8::Function)
      end
    end

    context 'when given an invalid callable' do
      it 'then raises' do
        expect do
          J8::Function.new(true)
        end.to raise_exception(ArgumentError)
      end
    end

    context 'when given a nil callable' do
      it 'then raises' do
        expect do
          J8::Function.new(nil)
        end.to raise_exception(J8::NilException)
      end
    end
  end

  describe '#apply' do
    context 'when invoked' do
      it 'then runs the function' do
        expect(@function.apply(1)).to eq 4
      end
    end
  end

  describe '#compose' do
    before(:each) do
      @object = OpenStruct.new
      @function = J8::Function.new { |o| o.base = o.composed ; o }
    end

    context 'when given a valid callable' do
      it 'then creates a new function' do
        composed = @function.compose { |o| o.composed = true ; o }
        composed.apply(@object)

        expect(@object.base).to eq true
        expect(@object.composed).to eq true
      end
    end

    context 'when given an invalid callable' do
      it 'then raises' do
        expect do
          @function.compose(true)
        end.to raise_exception(ArgumentError)
      end
    end

    context 'when given a nil callable' do
      it 'then raises' do
        expect do
          @function.compose(nil)
        end.to raise_exception(J8::NilException)
      end
    end
  end

  describe '#then' do
    before(:each) do
      @object = OpenStruct.new
      @function = J8::Function.new { |o| o.base = true ; o }
    end

    context 'when given a valid callable' do
      it 'then creates a new function' do
        thened = @function.then { |o| o.thened = o.base ; o }
        thened.apply(@object)

        expect(@object.base).to eq true
        expect(@object.thened).to eq true
      end
    end

    context 'when given an invalid callable' do
      it 'then raises' do
        expect do
          @function.then(true)
        end.to raise_exception(ArgumentError)
      end
    end

    context 'when given a nil callable' do
      it 'then raises' do
        expect do
          @function.then(nil)
        end.to raise_exception(J8::NilException)
      end
    end
  end
end
