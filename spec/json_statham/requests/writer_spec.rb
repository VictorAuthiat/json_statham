# frozen_string_literal: true

require "spec_helper"

RSpec.describe JsonStatham::Requests::Writer do
  let(:parser) { JsonStatham::Parser.new("foo") }

  describe "#call" do
    subject { writer.call }

    let(:writer)    { described_class.new(parser) }
    let(:base_path) { "foo" }
    let(:file_path) { "bar" }
    let(:dump)      { { foo: :bar } }

    before do
      allow(writer).to receive(:base_path) { base_path }
      allow(writer).to receive(:file_path) { file_path }
      allow(writer).to receive(:dump)      { dump }

      allow(File).to receive(:write)
    end

    it "creates a folder with base path" do
      expect(FileUtils).to receive(:mkdir_p).with(base_path).exactly(1).times
      subject
    end

    it "creates a file with file_path and current dump" do
      expect(File).to receive(:write).with(file_path, JSON.dump(dump)).exactly(1).times
      subject
    end
  end

  describe "#dump" do
    subject { writer.dump }

    let(:writer)         { described_class.new(parser) }
    let(:current_schema) { "foo" }
    let(:observer)       { observer_klass.new }
    let(:observer_klass) { Class.new }
    let(:duration)       { 0.1111 }

    before do
      allow(writer).to receive(:current_schema) { current_schema }
      allow(writer).to receive(:observer)       { observer }
      allow(observer).to receive(:duration)     { duration }
    end

    it { is_expected.to eq({ schema: current_schema, duration: observer.duration }) }
  end
end
