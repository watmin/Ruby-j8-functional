# frozen_string_literal: true

RSpec.describe J8::Consumer do
  before(:each) do
    @tracker = OpenStruct.new
    @consumer = J8::Consumer.new(->(object) { @tracker.tracking = object })
  end

  describe '.new' do
    context 'when given a valid callable' do
      it 'then creates a new consumer' do
        expect(@consumer).to be_a(J8::Consumer)
      end
    end

    context 'when given an invalid callable' do
      it 'then raises' do
        expect do
          J8::Consumer.new(true)
        end.to raise_exception(ArgumentError)
      end
    end

    context 'when given a nil callable' do
      it 'then raises' do
        expect do
          J8::Consumer.new(nil)
        end.to raise_exception(J8::NilException)
      end
    end
  end

  describe '#accept' do
    context 'when invoked' do
      it 'then runs the callable' do
        @consumer.accept(7)
        expect(@tracker.tracking).to eq 7
      end
    end
  end

  describe '#then' do
    context 'when given a valid callable' do
      it 'then creates a new consumer' do
        thened = @consumer.then(->(object) { @tracker.another = object })
        thened.accept(7)

        expect(@tracker.tracking).to eq 7
        expect(@tracker.another).to eq 7
      end
    end

    context 'when given an invalid callable' do
      it 'then raises' do
        expect do
          @consumer.then(true)
        end.to raise_exception(ArgumentError)
      end
    end

    context 'when given a nil callable' do
      it 'then raises' do
        expect do
          @consumer.then(nil)
        end.to raise_exception(J8::NilException)
      end
    end
  end
end
