# frozen_string_literal: true

require "spec_helper"
require "date"

RSpec.describe JsonStatham::Schema do
  let(:schema) { described_class.new(object) }

  describe ".call" do
    subject { described_class.call(object) }

    let(:object) do
      {
        data: {
          id: "foo",
          created_at: Date.today,
          objects: [
            { id: "bar" },
            { id: "baz" }
          ]
        }
      }
    end

    it "returns schema hash" do
      expect(subject).to eq({
        "data" => {
          "created_at" => "date",
          "id" => "string",
          "objects" => [
            { "id" => "string" },
            { "id" => "string" }
          ]
        }
      })
    end
  end

  describe "call" do
    subject { schema.call }

    let(:object) { nil }

    context "with an Array" do
      let(:object) { ["foo", "bar"] }

      it { is_expected.to eq(["string", "string"]) }
    end

    context "with a Hash" do
      let(:object) { { foo: :bar } }

      it { is_expected.to eq({ "foo" => "symbol" }) }
    end

    context "without an Array or a Hash" do
      let(:object) { "foo" }

      it "returns object class name" do
        expect(subject).to eq(object.class.name.downcase)
      end
    end
  end
end
