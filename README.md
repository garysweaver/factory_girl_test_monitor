## FactoryGirl Test Monitor

Monitors FactoryGirl strategy invocations (e.g. build, create, etc.) per test with ActiveSupport Instrumentation as described in FactoryGirl's getting started doc in order to output the strategy invocations.

Tries to automatically integrate with MiniTest and/or RSpec.

Has a configurable threshold for strategy invocations before printing a warning message.

This may be very helpful if you are getting "SystemStackError:   stack level too deep" errors caused by factory_girl factories. Those are not always trivial to track down without having more info about strategy invocations.

Depending on your reporter, etc. might look something like this in your test output:

    FactoryGirlTestMonitor.strategy_invocation_max of 199 was exceeded: {:customer=>{:create=>1}, :contact=>{:create=>1}, :project=>{:create=>216}}
    ...
      SystemStackError:   stack level too deep
      /path/to/activesupport.../lib/active_support/notifications/instrumenter.rb:23

There you can see that the project factory is involved in 216 creates, which was more in this case than the intended number.

### Setup

In your ActiveRecord/Rails 3.1+ project, add this to your Gemfile in your test group:

    gem 'factory_girl_test_monitor'

Then run:

    bundle install

### Configuration

By default the max strategy invocations is 199. To reconfigure can do this in an initializer:

    FactoryGirlTestMonitor.strategy_invocation_max = 199

### Debug

To track down why support is not being added for minitest or rspec:

    FactoryGirlTestMonitor.debug = true

### License

Copyright (c) 2013 Gary S. Weaver, released under the [MIT license][lic].

[lic]: http://github.com/garysweaver/factory_girl_test_monitor/blob/master/LICENSE
