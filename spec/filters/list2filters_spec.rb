# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/filters/list2fields"

describe LogStash::Filters::List2fields do

  # Test cases: 1     [ { "key" => "animal", "value" => "horse"} , {"key" => "food", "value" => "bacon"} ]          list of hashes with splitted fields for key and value
  # Test cases: 2     [ { "animal" => "horse"} , {"food" => "bacon"} ]                                              list of hashes with k => v structure

  context "without prefix" do

    let(:plugin) { LogStash::Filters::List2fields.new("source" => "message") }
    
    before do
      plugin.register
    end
    
    context "when the source field is empty" do

      let(:event) { LogStash::Event.new() }
      it "should not throw an exception" do
        expect {
          plugin.filter(event)
        }.not_to raise_error
      end # it
    end # context

    context "when the source field is not iterable" do

      let(:event) { LogStash::Event.new("message" => "i_am_not_iterable" ) }
      it "should not throw an exception" do
        expect {
          plugin.filter(event)
        }.not_to raise_error
      end # it
    end # context


    context "when there is a nested list" do

      let(:event) { LogStash::Event.new("message" => [{"key"=>"foo","value"=>"bar"},{"key"=>"cheese","value"=>"bacon"}]) } 
      before do
        plugin.filter(event)
      end

      it "should have new fields" do       
        expect(event["foo"]).to eq("bar")
        expect(event["cheese"]).to eq("bacon")
      end # it
    end # context  

    context "operates on a list of hashes with splitted key and value entries (default names) (testcase 1)" do
      let(:plugin) { LogStash::Filters::List2fields.new("source" => "message") } 
      let(:event) { LogStash::Event.new("cheese" => "chili", "message" => [{"key"=>"foo","value"=>"bar"},{"key"=>"cheese","value"=>"bacon"}]) } 
      before do
        plugin.register
        plugin.filter(event)
      end

      it "should have new fields" do
        expect(event["foo"]).to eq("bar")
        expect(event["cheese"]).to eq("bacon")
      end # it
    end # context

    context "operates on a list of hashes with splitted key and value entries (custom names) (testcase 1)" do
      let(:event) { LogStash::Event.new("metric" => "fan", "message" => [{"metric"=>"disc","measured"=>"20"},{"metric"=>"cpu","measured"=>"8"}]) } 
      let(:plugin) { LogStash::Filters::List2fields.new("source" => "message", "key" => "metric", "value" => "measured") } 
      before do
        plugin.register
        plugin.filter(event)
      end

      it "should have new fields" do
        expect(event["disc"]).to eq("20")
        expect(event["cpu"]).to eq("8")
      end # it
    end # context

    context "operates on a list of hashes with key and value in one tuple (testcase 2)." do
      let(:plugin) { LogStash::Filters::List2fields.new("source" => "message") } 
      let(:event) { LogStash::Event.new("cheese" => "chili", "message" => [{"foo"=>"bar"},{"cheese"=>"bacon"}]) } 
      before do
        plugin.register
        plugin.filter(event)
      end

      it "should have new fields" do
        expect(event["foo"]).to eq("bar")
        expect(event["cheese"]).to eq("bacon")
      end # it
    end # context

  end # context no prefix set

  context "with prefix " do

    context "operates on a list of hashes with splitted key and value entries (default names) (testcase 1)" do
      let(:plugin) { LogStash::Filters::List2fields.new("source" => "message", "prefix" => "l2f_") } 
      let(:event) { LogStash::Event.new("cheese" => "chili", "message" => [{"key"=>"foo","value"=>"bar"},{"key"=>"cheese","value"=>"bacon"}]) } 
      before do
        plugin.register
        plugin.filter(event)
      end

      it "should have new fields with the prefix in the key" do
        expect(event["l2f_foo"]).to eq("bar")
        expect(event["l2f_cheese"]).to eq("bacon")
      end # it

      it "should not overwrite existing fields" do
        expect(event["cheese"]).to eq("chili")
      end # it
    end # context

    context "operates on a list of hashes with splitted key and value entries (custom names) (testcase 1)" do
      let(:event) { LogStash::Event.new("metric" => "fan", "message" => [{"metric"=>"disc","measured"=>"20"},{"metric"=>"cpu","measured"=>"8"}]) } 
      let(:plugin) { LogStash::Filters::List2fields.new("source" => "message", "prefix" => "l2f_", "key" => "metric", "value" => "measured") } 
      before do
        plugin.register
        plugin.filter(event)
      end

      it "should have new fields with the prefix in the key" do
        expect(event["l2f_disc"]).to eq("20")
        expect(event["l2f_cpu"]).to eq("8")
      end # it

      it "should not overwrite existing fields" do
        expect(event["metric"]).to eq("fan")
      end # it
    end # context

    context "operates on a list of hashes with key and value in one tuple (testcase 2)." do
      let(:plugin) { LogStash::Filters::List2fields.new("source" => "message", "prefix" => "l2f_") } 
      let(:event) { LogStash::Event.new("cheese" => "chili", "message" => [{"foo"=>"bar"},{"cheese"=>"bacon"}]) } 
      before do
        plugin.register
        plugin.filter(event)
      end

      it "should have new fields with the prefix in the key" do
        expect(event["l2f_foo"]).to eq("bar")
        expect(event["l2f_cheese"]).to eq("bacon")
      end # it
    end # context

  end # context prefix set

end # describe

