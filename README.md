# Logstash list2fields Filter Plugin


This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Installation

You can download the plugin from [rubygems](https://rubygems.org/gems/logstash-filter-list2fields) and install it from your logstash home directory like so:

	bin/plugin install logstash-filter-list2fields-$VERSION.gem

## Versions and compatibility

Versions <= 0.1.2 are compatible with logstash 2.x, version 0.1.3 and later are compatible with logstash 5.

## Documentation

This filter rearranges key-value-pairs from the following structures

	example 1: 			"awesome_list" => [ { "animal" => "horse"} , {"food" => "bacon"} ]

or
  
	example 2: 			"awesome_list" => [ { "key" => "animal", "value" => "horse"} , {"key" => "food", "value" => "bacon"} ]

into separate logstash event fields:

	"animal" => "horse"
	"food" => "bacon"

## Configuration

* source 	: name of the field which contains the list of key value pairs (required). In the example above, this would be "awesome_list".
* prefix	: string to prepend to the new fields that will be added to the logstash event. Optional.
* key 		: optional for example 1, required for example #2: name of the key for the key field in the list of key value pairs. Headache? Example: If this is your incoming data:
	example 3: 			"awesome_list" => [ { "name" => "animal", "content" => "horse"} , {"name" => "food", "content" => "bacon"} ]
then the key would be "name".
* value 	: optional for example 1, required for example #2: name of the key for the value field in the list of key value pairs. In example 3, this would be "content".


## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elastic/logstash/blob/master/CONTRIBUTING.md) file.
