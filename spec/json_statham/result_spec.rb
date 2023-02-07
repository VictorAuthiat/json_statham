# frozen_string_literal: true

require "spec_helper"

RSpec.describe JsonStatham::Result do
  let(:result) { described_class.new(parser) }

  describe ".call" do
    subject { described_class.call(parser) }

    let(:parser) { JsonStatham::Parser.new("foo") }

    it "instanciates the result and execute call" do
      expect(described_class).to receive(:new).with(parser).and_call_original
      expect_any_instance_of(described_class).to receive(:call).and_call_original

      subject
    end
  end

  describe "#initialize" do
    subject { result }

    let(:parser) { nil }

    it "validates parser class" do
      expect(JsonStatham::Validation).to(
        receive(:check_object_class)
        .with(parser, [JsonStatham::Parser])
        .exactly(1)
        .times
      )

      subject
    end

    context "given a invalid parser" do
      let(:parser) { "foo" }

      it "raise ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "given a valid parser" do
      let(:parser) { JsonStatham::Parser.new("foo") }

      it { is_expected.to be_a(described_class) }
    end
  end

  describe "#call" do
    subject { result.call }

    let(:parser) { JsonStatham::Parser.new("foo") }

    context "given config does raise on failure" do
      before { allow(JsonStatham.config).to receive(:raise_on_failure?) { false } }

      it { is_expected.to be_a(described_class) }
    end

    context "given config raise on failure" do
      before { allow(JsonStatham.config).to receive(:raise_on_failure?) { true } }

      context "without previous_duration" do
        it { is_expected.to be_a(described_class) }

        it "does not raise InvalidRatioError" do
          expect { subject }.not_to raise_error(JsonStatham::InvalidRatioError)
        end
      end

      context "with previous_duration" do
        before do
          allow(result).to receive(:previous_duration) { 0.111 }
        end

        context "when ratio is lower than limit ratio" do
          before do
            allow(result).to receive(:ratio)       { 2 }
            allow(result).to receive(:raise_ratio) { 3 }
          end

          it "does not raise InvalidRatioError" do
            expect { subject }.not_to raise_error(JsonStatham::InvalidRatioError)
          end

          it { is_expected.to be_a(described_class) }
        end

        context "when ratio is greater than limit ratio" do
          before do
            allow(result).to receive(:ratio)       { 7 }
            allow(result).to receive(:raise_ratio) { 3 }
          end

          it "raise InvalidRatioError" do
            expect { subject }.to raise_error(JsonStatham::InvalidRatioError)
          end
        end
      end
    end
  end

  describe "#ratio" do
    subject { result.ratio }

    let(:parser) { JsonStatham::Parser.new("foo") }

    context "when not observed" do
      before { allow(result).to receive(:observed?) { false } }

      it { is_expected.to eq(0) }
    end

    context "when observed" do
      before do
        allow(result).to receive(:observed?) { true }
        allow(result).to receive(:previous_duration) { previous_duration }
        allow(result).to receive(:current_duration)  { current_duration }
      end

      let(:previous_duration) { 10 }
      let(:current_duration)  { 100 }

      it { is_expected.to eq(current_duration.fdiv(previous_duration)) }
    end
  end

  describe "#raise_ratio" do
    subject { result.raise_ratio }
    before  { JsonStatham.configure { |c| c.raise_ratio = raise_ratio } }

    let(:raise_ratio) { 5 }
    let(:parser)      { JsonStatham::Parser.new("foo") }

    it { is_expected.to eq(raise_ratio) }
  end

  describe "#current_duration" do
    subject { result.current_duration }

    let(:parser) { JsonStatham::Parser.new("foo") }

    context "given the parser dont have observer" do
      before { allow(parser).to receive(:observer) { nil } }

      it { is_expected.to eq(nil) }
    end

    context "given the parser have an observer" do
      let(:fake_klass) { Class.new }
      let(:observer)   { fake_klass.new }
      let(:duration)   { 0.11111 }

      before do
        allow(parser).to receive(:observer) { observer }
        allow(observer).to receive(:duration) { duration }
      end

      it "returns observer duration" do
        expect(subject).to eq(duration)
      end
    end
  end

  describe "#observed?" do
    subject { result.observed? }

    let(:parser) { JsonStatham::Parser.new("foo") }

    context "given the parser dont have observer" do
      before { allow(parser).to receive(:observer) { nil } }

      it { is_expected.to eq(false) }
    end

    context "given the parser have an observer" do
      let(:fake_klass) { Class.new }
      let(:observer)   { fake_klass.new }

      before { allow(parser).to receive(:observer) { observer } }

      it { is_expected.to eq(true) }
    end
  end

  describe "#previous_duration" do
    subject { result.previous_duration }
    before  { allow(parser).to receive(:previous_duration) { previous_duration } }

    let(:parser) { JsonStatham::Parser.new("foo") }
    let(:previous_duration) { 0.1111 }

    it { is_expected.to eq(previous_duration) }
  end

  describe "#success?" do
    subject { result.success? }

    let(:parser) { JsonStatham::Parser.new("foo") }

    context "given the parser is valid" do
      before { allow(parser).to receive(:valid?) { true } }

      it { is_expected.to eq(true) }
    end

    context "given the parser is invalid" do
      before { allow(parser).to receive(:valid?) { false } }

      it { is_expected.to eq(false) }
    end
  end

  describe "#failure?" do
    subject { result.failure? }

    let(:parser) { JsonStatham::Parser.new("foo") }

    context "given the parser is valid" do
      before { allow(parser).to receive(:valid?) { true } }

      it { is_expected.to eq(false) }
    end

    context "given the parser is invalid" do
      before { allow(parser).to receive(:valid?) { false } }

      it { is_expected.to eq(true) }
    end
  end
end
