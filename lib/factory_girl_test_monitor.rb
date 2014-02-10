require 'factory_girl'
require 'active_support/notifications'

module FactoryGirlTestMonitor
  class << self
    attr_accessor :strategy_invocation_max, :debug
  end
end

FactoryGirlTestMonitor.strategy_invocation_max = 199

# MiniTest support
begin
  require 'minitest/unit'

  module FactoryGirlTestMonitor
    module MiniTestFactoryStrategyInvocationCollector
      def before_setup
        @factory_girl_run_factories = {}
        @factory_girl_max_invocations = 0
        ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
          factory_name = payload[:name]
          strategy_name = payload[:strategy]
          @factory_girl_run_factories[factory_name] ||= {}
          @factory_girl_run_factories[factory_name][strategy_name] ||= 0
          @factory_girl_run_factories[factory_name][strategy_name] += 1
          this_num = @factory_girl_run_factories[factory_name][strategy_name]
          @factory_girl_max_invocations = [@factory_girl_max_invocations, @factory_girl_run_factories[factory_name][strategy_name]].max
        end
        super if defined?(super)
      end
    end
  end

  class MiniTest::Unit::TestCase
    include ::FactoryGirlTestMonitor::MiniTestFactoryStrategyInvocationCollector
  end

  if defined? Minitest::Test
    class Minitest::Test
      alias_method :run_with_factory_girl_test_monitor, :run

      def run
        run_with_factory_girl_test_monitor
      ensure
        puts "\nFactoryGirlTestMonitor.strategy_invocation_max of #{FactoryGirlTestMonitor.strategy_invocation_max} was exceeded: #{@factory_girl_run_factories.inspect}" if defined?(@factory_girl_run_factories) && @factory_girl_max_invocations > FactoryGirlTestMonitor.strategy_invocation_max
      end
    end
  else
    class MiniTest::Unit::TestCase
      alias_method :run_with_factory_girl_test_monitor, :run

      def run(runner)
        run_with_factory_girl_test_monitor(runner)
      ensure
        puts "\nFactoryGirlTestMonitor.strategy_invocation_max of #{FactoryGirlTestMonitor.strategy_invocation_max} was exceeded: #{@factory_girl_run_factories.inspect}" if defined?(@factory_girl_run_factories) && @factory_girl_max_invocations > FactoryGirlTestMonitor.strategy_invocation_max
      end
    end
  end

rescue LoadError, NameError => e
  if FactoryGirlTestMonitor.debug
    puts "FactoryGirlTestMonitor debug: Attempt to add MiniTest support failed: {e.message}\n  #{e.backtrace.join("  \n")}"
  end
end

# RSpec support
begin
  require 'rspec/expectations'
  RSpec.configure do |config|
    config.around(:each) do |t|
      @factory_girl_run_factories = {}
      @factory_girl_max_invocations = 0
      ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
        factory_name = payload[:name]
        strategy_name = payload[:strategy]
        @factory_girl_run_factories[factory_name] ||= {}
        @factory_girl_run_factories[factory_name][strategy_name] ||= 0
        @factory_girl_run_factories[factory_name][strategy_name] += 1
        this_num = @factory_girl_run_factories[factory_name][strategy_name]
        @factory_girl_max_invocations = [@factory_girl_max_invocations, @factory_girl_run_factories[factory_name][strategy_name]].max
      end
      begin
        t.run
      ensure
        puts "\nFactoryGirlTestMonitor.strategy_invocation_max of #{FactoryGirlTestMonitor.strategy_invocation_max} was exceeded: #{@factory_girl_run_factories.inspect}" if defined?(@factory_girl_run_factories) && @factory_girl_max_invocations > FactoryGirlTestMonitor.strategy_invocation_max
      end
    end
  end
rescue LoadError, NameError => e
  if FactoryGirlTestMonitor.debug
    puts "FactoryGirlTestMonitor debug: Attempt to add RSpec support failed: {e.message}\n  #{e.backtrace.join("  \n")}"
  end
end
