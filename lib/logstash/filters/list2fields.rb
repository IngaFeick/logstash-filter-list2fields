# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# TODO docu
class LogStash::Filters::List2fields < LogStash::Filters::Base
  
  config_name "list2fields"

  # The name of the field which contains the list of key value pairs
  config :source, :validate => :string

  # The name of the field which contains the key inside a list element. If this is set then "value" needs to be set also.
  config :key, :validate => :string, :default => ""

  # The name of the field which contains the value inside a list element. If this is set then "key" needs to be set also.
  config :value, :validate => :string, :default => ""
 
  # Prefix for the elements that will be added.
  config :prefix, :validate => :string, :default => ""

  public
  def register
    @access_by_name = !@key.empty? && !@value.empty?
  end # def register

  public
  def filter(event)
    input = event[@source]
    if !input.nil?  && (input.is_a? Enumerable)
      input.each do |entry|
        begin
          if @access_by_name
            if entry.is_a?(::Hash) # see spec file: test case 1  
              new_key = @prefix.to_s + entry[@key].to_s
              event[new_key] = entry[@value]
            else # it's an object of some unknown class.
              #new_key = @prefix.to_s + entry.instance_variable_get("@" + @key)
              #event[new_key] = entry.instance_variable_get("@" + @value)
              @logger.warn("Data structure not supported. Should be hash: " + entry.inspect.to_s)
            end # if is hash
          else # access by position, no key / value names provided
             if entry.is_a?(::Hash)  # see spec file: test case 2
              new_key = @prefix.to_s + entry[entry.keys[0]].to_s
              event[new_key] = entry[entry.keys[1]]
            else # it's an object of some unknown class. Does this even work? Find examples for this and document in rspec. TODO
              # TODO implement new_key = @prefix.to_s + entry.instance_variable_get("@" + @key)
               #TODO implement event[new_key] = entry.instance_variable_get("@" + @value)
               @logger.warn("Data structure not supported. Should be hash: " + entry.inspect.to_s)
            end # if is hash
          end # acess type
        rescue 
          @logger.debug("Could not find key " + @key + " in incoming data, please check your config. ")
        end
      end # do     
    end # if input.nil? 
  end # def filter  
end # class LogStash::Filters::List2fields


