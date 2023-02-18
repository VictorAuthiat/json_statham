require "rails/railtie"
require "json_statham/railtie"

RSpec.describe JsonStatham::Railtie, type: :railtie do
  describe "rake_tasks" do
    before do
      allow(File).to receive(:expand_path) { "foo" }
      described_class.initializers.each(&:run)
    end

    it "has access to the Rails railtie methods" do
      expect(described_class).to respond_to(:rake_tasks)
    end

    it "loads tasks", aggregate_failures: true do
      expect(File).to receive(:expand_path).exactly(1).times
      expect(described_class).to receive(:load).with("foo")

      described_class.rake_tasks[0].call
    end
  end
end
