# frozen_string_literal: true

RSpec.describe HBuilder do
  describe "::call" do
    context "given a non-existing value" do
      it "raises error" do
        expect do
          described_class.call do
            does_not_exist
          end
        end.to raise_error(described_class::Error)
      end
    end

    context "given no value" do
      it "raises error" do
        expect do
          described_class.call do
            key
          end
        end.to raise_error(described_class::Error)
      end
    end

    context "given value & block" do
      it "raises error" do
        expect do
          described_class.call do
            key :value do
              # NOP
            end
          end
        end.to raise_error(described_class::Error)
      end
    end

    context "given hash & array" do
      it "raises error" do
        expect do
          described_class.call do
            key :value
            array do
              key :value
            end
          end
        end.to raise_error(described_class::Error)
      end
    end

    context "given array then hash" do
      it "raises error" do
        expect do
          described_class.call do
            array do
              key :value
            end

            key :value
          end
        end.to raise_error(described_class::Error)
      end
    end

    context "when given two arguments" do
      it "raises error" do
        expect do
          described_class.call do
            key 1, 2
          end
        end.to raise_error(described_class::Error)
      end
    end

    context "with empty block" do
      subject do
        described_class.call do
          # NOP
        end
      end

      it { is_expected.to be_empty }
    end

    context "when given a hash" do
      context "with one key" do
        subject do
          described_class.call do
            outer do
              inner :value
            end
          end
        end

        it { is_expected.to eq({ outer: { inner: :value } }) }
      end

      context "with no key" do
        subject do
          described_class.call do
            outer do
            end
          end
        end

        it { is_expected.to eq({ outer: {} }) }
      end

      context "with two keys" do
        subject do
          described_class.call do
            key1 :value1
            key2 :value2
          end
        end

        it { is_expected.to eq({ key1: :value1, key2: :value2 }) }
      end

      context "with nested keys" do
        context "with binding" do
          subject do
            described_class.call(binding) do
              key outside
            end
          end

          let(:outside) { :value }

          it { is_expected.to eq({ key: outside }) }
        end
      end
    end

    context "given array" do
      context "with hash" do
        subject do
          described_class.call do
            array do
              key :value
            end
          end
        end

        it { is_expected.to eq([{ key: :value }]) }
      end

      context "with array" do
        context "without binding" do
          subject do
            described_class.call do
              array do
                array do
                  key :value
                end
              end
            end
          end

          it { is_expected.to eq([{ key: :value }]) }
        end

        context "with binding" do
          subject do
            described_class.call(binding) do
              array do
                array do
                  key value
                end
              end
            end
          end

          let(:value) { :value }

          it { is_expected.to eq([{ key: value }]) }
        end
      end
    end
  end
end
