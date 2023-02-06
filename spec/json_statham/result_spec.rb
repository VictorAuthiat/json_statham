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

    context "without logger" do
      before { JsonStatham.configure { |c| c.logger = false } }

      it "does not puts the result" do
        expect(described_class).not_to receive(:puts)
        subject
      end

      it { is_expected.to eq(result) }
    end

    context "with logger" do
      before { JsonStatham.configure { |c| c.logger = true } }

      it "puts the result" do
        expect(described_class).not_to receive(:puts)
        subject
      end

      it { is_expected.to eq(result) }
    end
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
