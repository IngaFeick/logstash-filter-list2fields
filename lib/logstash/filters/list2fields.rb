# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# TODO docu
class LogStash::Filters::List2fields < LogStash::Filters::Base
  
  config_name "list2fields"

  # The name of the field which contains the list of key value pairs
  config :source, :validate => :string

  # The name of the field which contains the key inside a list element
  config :key, :validate => :string, :default => "key"

  # The name of the field which contains the value inside a list element
  config :value, :validate => :string, :default => "value"
 
  # Prefix for the elements that will be added.
  config :prefix, :validate => :string, :default => ""

  public
  def register
    
  end # def register

  public
  def filter(event)
    input = event[@source]
    if !input.nil?  && (input.is_a? Enumerable)
      input.each do |entry|
        begin
          if entry.is_a?(::Hash)
            new_key = @prefix.to_s + entry[@key].to_s
            event[new_key] = entry[@value]
          else
            new_key = @prefix.to_s + entry.instance_variable_get("@" + @key)
            event[new_key] = entry.instance_variable_get("@" + @value)
          end # if is hash
        rescue 
          @logger.debug("Could not find key " + @key + " in incoming data, please check your config. ")
        end
      end # do     
    end # if input.nil? 
  end # def filter  
end # class LogStash::Filters::List2fields


