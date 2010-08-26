require 'spec_helper'

describe "Melomel Integration" do
  before(:all) do
    # Make sure FLEX_HOME is defined
    raise 'FLEX_HOME environment variable must be set' if ENV['FLEX_HOME'].nil?

    # Open up the sandbox
    @pid = fork do
      exec("#{ENV['FLEX_HOME']}/bin/adl target/MelomelRunner-app.xml")
    end
    Process.detach(@pid)
    
    # Connect to the sandbox Flash file
    Melomel.connect()
  end

  after(:all) do
    sleep 2
    Process.kill('KILL', @pid)
  end


  it "should get the application's name" do
    app = Melomel.get_class('mx.core.FlexGlobals')
    app.topLevelApplication.name.should == 'Melomel Runner'
  end

  it "should get a property" do
    runner = Melomel.get_class('MelomelRunner')
    runner.foo.should == 'bar'
  end

  it "should set a property" do
    runner = Melomel.get_class('MelomelRunner')
    runner.name = 'Susy'
    runner.name.should == 'Susy'
    runner.name = 'John'
  end

  it "should invoke a method" do
    runner = Melomel.get_class('MelomelRunner')
    runner.hello('John').should == 'Hello, John'
  end

  it "should create an object" do
    point = Melomel.create_object('flash.geom.Point')
    point.x = 30
    point.y = 40
    point.length.should == 50
  end
end