# frozen_string_literal: true

require "spec_helper"

RSpec.describe JsonStatham::Parser do
  let(:parser) { described_class.new(name) { block } }
  let(:name)   { "foo" }
  let(:block)  { proc {} }

  describe ".call" do
    subject { described_class.call(name) { block } }

    it "instanciates the parser and execute call" do
      expect(described_class).to receive(:new).with(name, &block).and_call_original
      expect_any_instance_of(described_class).to receive(:call).and_call_original

      subject
    end
  end

  describe "#initialize" do
    subject { parser }

    it "validates name" do
      expect(JsonStatham::Validation).to(
        receive(:check_object_class)
        .with(name, [String])
        .exactly(1)
        .times
      )

      subject
    end

    context "given a invalid name" do
      let(:name) { 1 }

      it "raise ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "given a valid name" do
      let(:name) { "foo" }

      it { is_expected.to be_a(described_class) }
    end
  end

  describe "#call" do
    subject { parser.call }

    it "calls reader" do
      expect(JsonStatham::Requests::Reader).to receive(:call).with(parser).and_call_original
      subject
    end

    it "calls observer" do
      expect(JsonStatham::Requests::Observer).to receive(:call).with(parser).and_call_original
      subject
    end

    it "stores schema" do
      expect(parser).to receive(:store_current_schema).and_call_original
      subject
    end

    it "calls result" do
      expect(JsonStatham::Result).to receive(:call).with(parser).and_call_original
      subject
    end

    it { is_expected.to be_a(JsonStatham::Result) }
  end

  describe "#store_current_schema" do
    subject { parser.store_current_schema }

    context "when config store schema" do
      before { JsonStatham.configure { |c| c.store_schema = true } }

      it "calls writer" do
        expect(JsonStatham::Requests::Writer).to(
          receive(:call)
            .with(parser)
            .exactly(1)
            .times
        )

        subject
      end
    end

    context "when config dont store schema" do
      before { JsonStatham.configure { |c| c.store_schema = false } }

      it "does not call writer" do
        expect(JsonStatham::Requests::Writer).not_to receive(:call)
        subject
      end
    end
  end

  describe "#schema" do
    subject { parser.schema }
    before  { allow(parser).to receive(:observer) { observer } }

    context "without observer" do
      let(:observer) { nil }

      it { is_expected.to eq(nil) }
    end

    context "with observer" do
      before { allow(observer).to receive(:data) { data } }

      let(:fake_class) { Class.new }
      let(:observer)   { fake_class.new }
      let(:data)       { { foo: :bar } }

      it { is_expected.to eq(data) }
    end
  end

  describe "#stored_schema" do
    subject { parser.stored_schema }
    before  { allow(parser).to receive(:reader) { reader } }

    context "without reader" do
      let(:reader) { nil }

      it { is_expected.to eq(nil) }
    end

    context "with reader" do
      let(:reader) { { "schema" => schema } }
      let(:schema) { { foo: :bar } }

      it { is_expected.to eq(schema) }
    end
  end

  describe "#previous_duration" do
    subject { parser.previous_duration }
    before  { allow(parser).to receive(:reader) { reader } }

    context "without reader" do
      let(:reader) { nil }

      it { is_expected.to eq(nil) }
    end

    context "with reader" do
      let(:reader) { { "schema" => schema, "duration" => previous_duration } }
      let(:schema) { { foo: :bar } }
      let(:previous_duration) { 0.111 }

      it { is_expected.to eq(previous_duration)}
    end
  end

  describe "#reader?" do
    subject { parser.reader? }
    before  { allow(parser).to receive(:reader) { reader } }

    context "without reader" do
      let(:reader) { nil }

      it { is_expected.to eq(false) }
    end

    context "with reader" do
      let(:reader) { { foo: "bar" } }

      it { is_expected.to eq(true)}
    end
  end

  describe "#current_schema" do
    subject { parser.current_schema }
    before  { allow(parser).to receive(:schema) { schema } }

    let(:schema) { { foo: :bar } }

    it "calls JsonStatham::Schema with schema" do
      expect(JsonStatham::Schema).to receive(:call).with(schema).exactly(1).times
      subject
    end
  end

  describe "#stored_schema?" do
    subject { parser.stored_schema? }
    before  { allow(parser).to receive(:stored_schema) { stored_schema } }

    context "without stored_schema" do
      let(:stored_schema) { nil }

      it { is_expected.to eq(false) }
    end

    context "with stored_schema" do
      let(:stored_schema) { { foo: :bar } }

      it { is_expected.to eq(true)}
    end
  end

  describe "#valid?" do
    subject { parser.valid? }

    context "without stored schema" do
      before  { allow(parser).to receive(:stored_schema) { nil } }

      it { is_expected.to eq(true) }
    end

    context "with stored schema" do
      before do
        allow(parser).to receive(:stored_schema) { stored_schema }
        allow(parser).to receive(:current_schema) { current_schema }
      end

      context "without differences" do
        let(:stored_schema) { { foo: :bar } }
        let(:current_schema) { stored_schema }

        it { is_expected.to eq(true) }
      end

      context "with differences" do
        let(:stored_schema) { { foo: :bar } }
        let(:current_schema) { { bar: :foo } }

        it { is_expected.to eq(false) }
      end
    end
  end
end
