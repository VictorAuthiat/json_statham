# frozen_string_literal: true

require "spec_helper"

RSpec.describe JsonStatham::Requests::Reader do
  let(:parser) { JsonStatham::Parser.new("foo") }

  describe "#call" do
    subject { reader.call }

    let(:reader)    { described_class.new(parser) }
    let(:file_path) { "bar" }

    before { allow(reader).to receive(:file_path) { file_path } }

    context "when there is no file at file_path" do
      before { allow(File).to receive(:exist?).with(file_path) { false } }

      it { is_expected.to eq({}) }
    end

    context "when the file exist" do
      before do
        allow(File).to receive(:exist?).with(file_path) { true }
        allow(File).to receive(:read).with(file_path) { fake_file_content }
      end

      let(:fake_file_content) { JSON.dump({ foo: :bar }) }

      it "parse the file" do
        expect(subject).to eq(JSON.parse(fake_file_content))
      end

      context "when a JSON::ParserError occurred" do
        before do
          allow(JSON).to receive(:parse) { raise JSON::ParserError }
        end

        it { is_expected.to eq({}) }
      end
    end
  end
end
