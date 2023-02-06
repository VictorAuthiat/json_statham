RSpec.describe JsonStatham::Requests::Base do
  let(:base) { described_class.new(parser) }

  describe "#call" do
    subject { base.call }

    let(:parser) { JsonStatham::Parser.new("foo") }

    it "raise NotImplementedError" do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end

  describe "#folder_path" do
    subject { base.folder_path }
    before  { allow(base).to receive(:splitted_name) { ["folder_name", "file_name"] } }

    let(:parser) { JsonStatham::Parser.new("foo") }

    it { is_expected.to eq("folder_name") }
  end
end
