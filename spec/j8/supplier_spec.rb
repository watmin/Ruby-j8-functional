# frozen_string_literal: true

RSpec.describe J8::Supplier do
  before(:each) do
    @supplier = J8::Supplier.new(-> { true })
  end

  describe '.new' do
    context 'when given a valid callable' do
      it 'then creates a new supplier' do
        expect(@supplier).to be_a(J8::Supplier)
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

  describe '#get' do
    context 'when invoked' do
      it 'then returns supplier value' do
        expect(@supplier.get).to eq true
      end
    end
  end
end
