# frozen_string_literal: true

require "spec_helper"

RSpec.describe JsonStatham::Config do
  let(:config) { described_class.new }

  describe "#store_schema?" do
    subject { config.store_schema? }

    context "given store_schema attribute is nil" do
      before { config.store_schema = nil }

      it { is_expected.to eq(false) }
    end

    context "given store_schema attribute is true" do
      before { config.store_schema = true }

      it { is_expected.to eq(true) }
    end

    context "given store_schema attribute is false" do
      before { config.store_schema = false }

      it { is_expected.to eq(false) }
    end
  end

  describe "#logger?" do
    subject { config.logger? }

    context "given logger attribute is nil" do
      before { config.logger = nil }

      it { is_expected.to eq(false) }
    end

    context "given logger attribute is true" do
      before { config.logger = true }

      it { is_expected.to eq(true) }
    end

    context "given logger attribute is false" do
      before { config.logger = false }

      it { is_expected.to eq(false) }
    end
  end

  describe "#schemas_path_present?" do
    subject { config.schemas_path_present? }

    context "given schemas_path attribute is nil" do
      before { allow(config).to receive(:schemas_path) { nil } }

      it { is_expected.to eq(false) }
    end

    context "given schemas_path attribute is present" do
      before { config.schemas_path = "foo" }

      it { is_expected.to eq(true) }
    end
  end

  describe "#schemas_path=" do
    subject { config.schemas_path = schemas_path }

    let(:schemas_path) { "foo" }

    it "validates object class" do
      expect(JsonStatham::Validation).to(
        receive(:check_object_class)
        .with(schemas_path, [String])
        .exactly(1)
        .times
        .and_call_original
      )

      subject
    end

    context "given an invalid object" do
      let(:schemas_path) { :foo }

      it "raise ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "given valid object" do
      let(:schemas_path) { "foo" }

      it "does not raise error" do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe "#store_schema=" do
    subject { config.store_schema = store_schema }

    let(:store_schema) { true }

    it "validates object class" do
      expect(JsonStatham::Validation).to(
        receive(:check_object_class)
        .with(store_schema, [TrueClass, FalseClass, NilClass])
        .exactly(1)
        .times
        .and_call_original
      )

      subject
    end

    context "given an invalid object" do
      let(:store_schema) { :foo }

      it "raise ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "given valid object" do
      let(:store_schema) { false }

      it "does not raise error" do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe "#logger=" do
    subject { config.logger = logger }

    let(:logger) { true }

    it "validates object class" do
      expect(JsonStatham::Validation).to(
        receive(:check_object_class)
        .with(logger, [TrueClass, FalseClass, NilClass])
        .exactly(1)
        .times
        .and_call_original
      )

      subject
    end

    context "given an invalid object" do
      let(:logger) { :foo }

      it "raise ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "given valid object" do
      let(:logger) { false }

      it "does not raise error" do
        expect { subject }.not_to raise_error
      end
    end
  end
end
