# frozen_string_literal: true

RSpec.describe J8::Predicate do
  before(:each) do
    @predicate = J8::Predicate.new(->(object) { object == true })
  end

  describe '.new' do
    context 'when given a valid callable' do
      it 'then creates a new predicate' do
        expect(@predicate).to be_a(J8::Predicate)
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

  describe '.equal?' do
    context 'when invoked' do
      it 'then creates a new predicate' do
        predicate = J8::Predicate.equal?(7)
        expect(predicate.test(7)).to eq true
      end
    end
  end

  describe '#test' do
    context 'when invoked' do
      it 'then returns true' do
        expect(@predicate.test(true)).to eq true
      end
    end
  end

  describe '#negate' do
    context 'when given a valid callable' do
      it 'then creates a new predicate' do
        predicate = @predicate.negate
        expect(predicate.test(false)).to eq true
      end
    end
  end

  describe '#and' do
    context 'when given a valid callable' do
      before(:each) do
        @predicate = J8::Predicate.new(->(object) { object.odd? })
      end

      it 'then creates a new predicate' do
        predicate = @predicate.and(->(object) { object == 5 })
        expect(predicate.test(5)).to eq true
      end
    end

    context 'when given an invalid callable' do
      it 'then raises' do
        expect do
          @predicate.and(true)
        end.to raise_exception(ArgumentError)
      end
    end

    context 'when given a nil callable' do
      it 'then raises' do
        expect do
          @predicate.and(nil)
        end.to raise_exception(J8::NilException)
      end
    end
  end

  describe '#or' do
    context 'when given a valid callable' do
      before(:each) do
        @predicate = J8::Predicate.new(->(object) { object.odd? })
      end

      it 'then creates a new predicate' do
        predicate = @predicate.or(->(object) { object == 5 })
        expect(predicate.test(7)).to eq true
      end
    end

    context 'when given an invalid callable' do
      it 'then raises' do
        expect do
          @predicate.or(true)
        end.to raise_exception(ArgumentError)
      end
    end

    context 'when given a nil callable' do
      it 'then raises' do
        expect do
          @predicate.or(nil)
        end.to raise_exception(J8::NilException)
      end
    end
  end
end
