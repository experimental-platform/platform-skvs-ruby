# Experimental Platform SKVS - Ruby Client

This is a ruby client for the [Simple Key Value Service](https://github.com/experimental-platform/platform-skvs) used
for storing and querying configuration on [Experimental Platform](https://experimental-platform.github.io/)

## Installation

Install with `gem install platform-skvs` or add it to your `Gemfile`.

## Usage

You get a simple get/set/del interface for keys and values:

    SKVS.get 'foo' #=> nil
    SKVS.set 'foo', 'bar'
    SKVS.get 'foo' #=> 'bar'
    SKVS.del 'foo'
    SKVS.get 'foo' #=> nil

There is also the `SKVS.try` method, which includes polling for a success/error feedback from any service dependent on the key you are setting. Imagine
for example a system service that, when a the `hostname` key changes does some adjustments to your host machine. If you want feedback on the success of
this operation, you would call `SKVS.try 'hostname', 'albatross', success: 'hostname/success', error: 'hostname/success', which will do the following:

* Remove any existing error/success values under the given keys
* Fetch the current `hostname` value
* Set the new `hostname` value
* Query the error/success keys until a value shows up under one of them
* Return a Ruby object that responds either to `success` with 'Value of the success key' or to `error` with 'Value of the error key a.k.a. error message'
* On error, it will set the `hostname` back to the original value

This is a simple way to get synchronous feedback on asynchronous operations. Obviously, you will need to make sure the service handling your `hostname` will
correctly populate it's success and error keys for this to work.

## Adapters

The default adapter is the regular `HTTPAdapter` that will interact with the [SKVS](https://github.com/experimental-platform/platform-skvs) API, which is assumed
to be linked into a docker container under the hostname `skvs`.

For development and testing, it will make much more sense to use the MemoryAdapter, which simply uses a Ruby hash for local storage. 

You can swap adapters with `SKVS.adapter = SKVS::MemoryAdapter.new`, so for example to configure your RSpec test suite to always use the memory adapter, your
`spec_helper` would need this:

```
RSpec.configure do |config|
  config.before(:each) do
    SKVS.adapter = SKVS::MemoryAdapter.new
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/experimental-platform/platform-skvs-ruby.