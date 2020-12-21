# frozen_string_literal: true

RSpec.describe J8::Optional do
  describe '.new' do
    context 'when invoked' do
      it 'then creates a new optional' do
        optional = J8::Optional.new(nil)
        expect(optional).to be_a(J8::Optional)
      end
    end
  end

  describe '.empty' do
    context 'when invoked' do
      it 'then creates an optional with nil value' do
        optional = J8::Optional.empty
        expect(optional.present?).to eq false
      end
    end
  end

  describe '.of' do
    context 'when invoked with a value' do
      it 'then creates an optional with the value' do
        optional = J8::Optional.of(8)
        expect(optional.present?).to eq true
        expect(optional.get).to eq 8
      end
    end

    context 'when invoked with a nil' do
      it 'then raises' do
        expect do
          J8::Optional.of(nil)
        end.to raise_error(J8::NilException)
      end
    end
  end

  describe '.of_nilable' do
    context 'when invoked with a value' do
      it 'then creates an optional with the value' do
        optional = J8::Optional.of(8)
        expect(optional.present?).to eq true
        expect(optional.get).to eq 8
      end
    end

    context 'when invoked with a nil' do
      it 'then raises' do
        optional = J8::Optional.of_nilable(nil)
        expect(optional.present?).to eq false
      end
    end
  end

  describe '#empty?' do
    context 'when value is not nil' do
      it 'then returns false' do
        expect(J8::Optional.new(8).empty?).to eq false
      end
    end

    context 'when value is nil' do
      it 'then returns true' do
        expect(J8::Optional.new.empty?).to eq true
      end
    end
  end

  describe '#equals?' do
    context 'when invoked with an argument' do
      it 'then measures if the argument equals the optional value' do
        optional = J8::Optional.new(8)
        expect(optional.equals?(8)).to equal true
      end
    end
  end

  describe '#filter' do
    before(:each) do
      @optional = J8::Optional.new(8)
    end

    context 'when given a matching predicate' do
      it 'then returns an optional with the existing optional value' do
        result = @optional.filter(->(o) { o == 8 })
        expect(result.present?).to eq true
        expect(result.value).to eq 8
      end
    end

    context 'when given a non matching predicate' do
      it 'then returns an empty optional' do
        result = @optional.filter(->(o) { o == 9 })
        expect(result.present?).to eq false
      end
    end
  end

  describe '#flat_map' do
    before(:each) do
      @optional = J8::Optional.new(8)
    end

    context 'when given a valid function' do
      it 'then returns an optional with mapped value' do
        result = @optional.flat_map(->(o) { J8::Optional.new(o**2) })
        expect(result.present?).to eq true
        expect(result.value).to eq 64
      end
    end

    context 'when given an invalid function' do
      it 'then raises' do
        expect do
          @optional.flat_map(nil)
        end.to raise_error(J8::NilException)
      end
    end
  end

  describe '#get' do
    context 'when value is not nil' do
      it 'then returns the value' do
        optional = J8::Optional.new(8)
        expect(optional.value).to eq 8
      end
    end

    context 'when value is nil' do
      it 'then raises' do
        optional = J8::Optional.new

        expect do
          optional.value
        end.to raise_error(J8::NoSuchElementException)
      end
    end
  end

  describe '#if_present' do
    before(:each) do
      @tracker = OpenStruct.new
    end

    context 'when value is not nil' do
      it 'then invokes the consumer with the value' do
        optional = J8::Optional.new(8)
        optional.if_present(->(_) { @tracker.tracked = true })

        expect(@tracker.tracked).to eq true
      end
    end

    context 'when value is nil' do
      it 'then does nothing' do
        optional = J8::Optional.new
        optional.if_present(->(_) { @tracker.tracked = true })

        expect(@tracker.tracked).to eq nil
      end
    end
  end

  describe '#present?' do
    context 'when value is not nil' do
      it 'then returns true' do
        optional = J8::Optional.new(8)
        expect(optional.present?).to eq true
      end
    end

    context 'when value is nil' do
      it 'then returns false' do
        optional = J8::Optional.new
        expect(optional.present?).to eq false
      end
    end
  end

  describe '#map' do
    context 'when the value is not nil' do
      it 'then returns an optional with mapped value' do
        optional = J8::Optional.new(8)
        result = optional.map(->(o) { o**2 })

        expect(result.present?).to eq true
        expect(result.value).to eq 64
      end
    end

    context 'when the value is nil' do
      it 'then returns an empty optional' do
        optional = J8::Optional.new
        result = optional.map(->(o) { o**2 })

        expect(result.empty?).to eq true
      end
    end
  end

  describe '#or_else' do
    context 'when value is not nil' do
      it 'then returns the optional value' do
        optional = J8::Optional.new(8)
        result = optional.or_else(:else)
        expect(result).to eq 8
      end
    end

    context 'when value is nil' do
      it 'then returns the else value' do
        optional = J8::Optional.new
        result = optional.or_else(:else)
        expect(result).to eq :else
      end
    end
  end

  describe '#or_else_get' do
    context 'when supplier is nil' do
      it 'then raises' do
        expect do
          J8::Optional.new.or_else_get(nil)
        end.to raise_error(J8::NilException)
      end
    end

    context 'when supplier is not nil' do
      context 'and when value is not nil' do
        it 'then returns the optional value' do
          optional = J8::Optional.new(8)
          result = optional.or_else_get(-> { :else })
          expect(result).to eq 8
        end
      end

      context 'and when value is nil' do
        context 'and when supplier returns nil' do
          it 'then raises' do
            optional = J8::Optional.new

            expect do
              optional.or_else_get(-> {})
            end.to raise_error(J8::NilException)
          end
        end

        context 'and when supplier returns a value' do
          it 'then returns the supplier value' do
            # to do
          end
        end
      end
    end
  end

  describe '#or_else_raise' do
    context 'when supplier is nil' do
      it 'then raises' do
        expect do
          J8::Optional.new.or_else_raise(nil)
        end.to raise_error(J8::NilException)
      end
    end

    context 'when supplier is not nil' do
      context 'and when value is not nil' do
        it 'then returns the optional value' do
          optional = J8::Optional.new(8)
          result = optional.or_else_raise(-> { StandardError })
          expect(result).to eq 8
        end
      end

      context 'and when value is nil' do
        it 'then raises the supplied exception' do
          optional = J8::Optional.new

          expect do
            optional.or_else_raise(-> { StandardError })
          end.to raise_error(StandardError)
        end
      end
    end
  end
end
