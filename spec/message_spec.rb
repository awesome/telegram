require 'spec_helper'


## The tests are reading from the spec/fixtures folder
## Take a look there for example data files
## This was changed in the spec helper

describe Message do
  describe 'Message#all' do
    it 'should return an array' do
      expect(Message.all).to be_an_instance_of(Array)
    end
    it 'contain instances of Message' do
      expect(Message.all.sample).to be_an_instance_of(Message)
    end
  end

  describe '#save' do
    context "When a message with the body of test" do
      let(:message) { Message.new }

      it 'should write a file and merge in additional keys' do
        file = double(File)
        expect(File).to receive(:open).and_yield(file)
        file.should_receive(:write).with do |args|
          options = YAML::load(args)
          [:body, :user, :created_at].each do |item|
            expect(options.keys).to include(item)
          end
        end
        message.save
      end

    end
  end


  describe '#acknowledge!' do
    let(:message) do
      Message.all.find{ |f| f['file_name'] == "1391304560.yml" }
    end

    context "given that a user has not acknowledged a message" do
      it 'should create a new acknowlegment' do
        Message.any_instance.stub(:acknowledged?).and_return(false)
        expect(Acknowledge).to receive(:new).and_return(
          double(Acknowledge, save: true)
        )
        message.acknowledge!
      end
    end

    context "given a user has acknowledged a message" do
      it 'should NOT create a new acknowledgement' do
        Message.any_instance.stub(:acknowledged?).and_return(true)
        expect(Acknowledge).not_to receive(:new)
        message.acknowledge!
      end
    end
  end

  describe "#acknowledged?" do
    let(:message) do
      Message.all.find{ |f| f['file_name'] == file }
    end

    context "given a user has acknowledged a message" do
      let(:file) {"1391304560.yml"}
      it 'returns true' do
        expect(message.acknowledged?).to be_true
      end
    end

    context "given a user has not acknowledged a message" do
      let(:file) {"2391304560.yml"}
      it 'returns false' do
        expect(message.acknowledged?).to be_false
      end
    end

  end

end

