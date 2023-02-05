# frozen_string_literal: true

require "spec_helper"

RSpec.describe JsonStatham do
  it "has a version number" do
    expect(JsonStatham::VERSION).not_to be nil
  end

  describe ".extend" do
    subject { example_class.extend(described_class) }

    let(:example_class) { Class.new }

    it "includes JsonStatham::Helper::HelperMethod" do
      expect(example_class).to(
        receive(:include)
          .with(JsonStatham::Helper)
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

    it "includes JsonStatham::Helper::HelperMethod" do
      expect(example_class).to(
        receive(:extend)
          .with(JsonStatham::Helper)
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

      subject
    end
  end

  describe ".configure" do
    it { expect { |b| described_class.configure(&b) }.to yield_with_args }
  end

  describe ".config" do
    subject { described_class.config }

    it "returns JsonStatham::Config" do
      expect(subject).to be_a(JsonStatham::Config)
    end
  end
end
