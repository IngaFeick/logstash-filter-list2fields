# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/filters/list2fields"

describe LogStash::Filters::List2fields do

  let(:plugin) { LogStash::Filters::List2fields.new("source" => "message") }
  
  before do
    plugin.register
  end
  
  context "when a prefix is set" do

    let(:plugin_prefix) { LogStash::Filters::List2fields.new("source" => "message", "prefix" => "l2f_") } # TODO there's got to be a more beautiful way to do this 
    let(:event) { LogStash::Event.new("cheese" => "chili", "message" => [{"key"=>"foo","value"=>"bar"},{"key"=>"cheese","value"=>"bacon"}]) } 
    before do
      plugin_prefix.filter(event)
    end

    it "should have new fields with the prefix in the key" do
      expect(event["l2f_foo"]).to eq("bar")
      expect(event["l2f_cheese"]).to eq("bacon")
    end # it

    it "should not overwrite existing fields" do
      expect(event["cheese"]).to eq("chili")
    end # it
  end # context


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
end # describe

