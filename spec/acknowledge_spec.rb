require 'spec_helper'

describe Acknowledge do
  describe '#save' do

    let(:acknowledge) { Acknowledge.new(file_name: "123.yml") }

    context "when setting the file name" do

      it "should create a file with the name ok.yml" do
        expect(File).to receive(:open).with(
          Telegram.acknowledgments_root + "/123.yml", "w"
        ).and_return(
          double(File, write: nil)
        )
        acknowledge.save
      end
    end


    it 'should write a file and merge in additional keys' do
      file = double('file')
      File.should_receive(:open).and_yield(file)

      file.should_receive(:write).with do |args|
        options = YAML::load(args)
        [:user, :created_at, :file_name].each do |item|
          expect(options.keys).to include(item)
        end
      end
      acknowledge.save
    end
  end

end
