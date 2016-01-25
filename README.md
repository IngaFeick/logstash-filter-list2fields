# Logstash Plugin


This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Documentation

This filter rearranges key-value-pairs from the following structure
  
	"awesome_list" => [ { "key" => "animal", "value" => "horse"} , {"key" => "food", "value" => "bacon"} ]

into separate logstash event fields:

	"animal" => "horse"
	"food" => "bacon"

## Configuration

* source 	: name of the field which contains the list of key value pairs (required). In the example above, this would be "awesome_list".
* key 		: name of the key for the key field in the list of key value pairs. Headache? Example: If this is your incoming data:
	"awesome_list" => [ { "name" => "animal", "content" => "horse"} , {"name" => "food", "content" => "bacon"} ]
then the key would be "name". Optional, defaults to "key".
* value 	: name of the key for the value field in the list of key value pairs. In the above example, this would be "content". Optional, defaults to "value".
* prefix	: string to prepend to the new fields that will be added to the logstash event. Optional, defaults to empty.


## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elastic/logstash/blob/master/CONTRIBUTING.md) file.