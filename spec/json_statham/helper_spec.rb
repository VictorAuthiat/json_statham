# frozen_string_literal: true

require "spec_helper"

RSpec.describe JsonStatham::Helper do
  describe ".extend" do
    subject { example_class.extend(described_class) }

    let(:example_class) { Class.new }

    it "apply expands JsonStatham::Helper::HelperMethod" do
      expect(example_class).to(
        receive(:extend)
          .with(described_class)
          .exactly(1)
          .times
          .and_call_original
      )

      expect(example_class).to(
        receive(:extend)
          .with(JsonStatham::Helper::HelperMethod)
          .exactly(1)
          .times
          .and_call_original
      )

      expect(example_class).to(
        receive(:include)
          .with(JsonStatham::Helper::HelperMethod)
          .exactly(1)
          .times
          .and_call_original
      )

      subject
    end
  end

  describe ".include" do
    subject { example_class.include(described_class) }

    let(:example_class) { Class.new }

    it "apply expands JsonStatham::Helper::HelperMethod" do
      expect(example_class).to(
        receive(:include)
          .with(described_class)
          .exactly(1)
          .times
          .and_call_original
      )

      expect(example_class).to(
        receive(:extend)
          .with(JsonStatham::Helper::HelperMethod)
          .exactly(1)
          .times
          .and_call_original
      )

      expect(example_class).to(
        receive(:include)
          .with(JsonStatham::Helper::HelperMethod)
          .exactly(1)
          .times
          .and_call_original
      )

      subject
    end

    it "responds to stathamnize" do
      subject
      expect(example_class.respond_to?(:stathamnize)).to eq(true)
    end
  end

  describe "stathamnize" do
    subject { example_class.stathamnize(name, &block) }

    before do
      example_class.extend(JsonStatham)
      allow(JsonStatham.config).to receive(:schemas_path_present?) { schemas_path_present }
    end

    let(:example_class) { Class.new }
    let(:name)          { "foo" }
    let(:block)         { proc { { foo: :bar } } }

    context "without schemas_path" do
      let(:schemas_path_present) { false }

      it "raise ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "with schemas_path" do
      let(:schemas_path_present) { true }

      it "calls parser" do
        expect(JsonStatham::Parser).to receive(:call).with(name, &block).exactly(1).times
        subject
      end
    end
  end
end
