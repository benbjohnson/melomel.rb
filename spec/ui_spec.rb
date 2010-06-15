require 'spec_helper'

describe "Melomel UI" do
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


  it "should find a list of labels named 'foo'" do
    labels = Melomel::UI.find_all('spark.components.Label', :name => 'foo')
    labels.length.should == 3
  end

  it "should find the text input" do
    text_input = Melomel::UI.find('spark.components.TextInput', :id => 'nameTextInput')
    text_input.name.should == 'nameTextField'
  end
  

  it "should click the button" do
    button = Melomel::UI.find('spark.components.Button', :id => 'clickButton')
    label = Melomel::UI.find('spark.components.Label', :id => 'clickLabel')
    Melomel::UI.click(button)
    label.text.should == 'Hello!'
  end

  it "should double click the button" do
    button = Melomel::UI.find('spark.components.Button', :id => 'doubleClickButton')
    label = Melomel::UI.find('spark.components.Label', :id => 'doubleClickLabel')
    Melomel::UI.double_click(button)
    label.text.should == 'Hello Hello!'
  end


  it "should press a key down" do
    text_input = Melomel::UI.find('spark.components.TextInput', :id => 'keyDownTextInput')
    label = Melomel::UI.find('spark.components.Label', :id => 'keyDownLabel')
    Melomel::UI.key_down(text_input, 'a')
    label.text.should == 'a'
  end

  it "should release a key up" do
    text_input = Melomel::UI.find('spark.components.TextInput', :id => 'keyUpTextInput')
    label = Melomel::UI.find('spark.components.Label', :id => 'keyUpLabel')
    Melomel::UI.key_up(text_input, 'b')
    label.text.should == 'b'
  end

  it "should press a key" do
    text_input = Melomel::UI.find('spark.components.TextInput', :id => 'keyPressTextInput')
    label = Melomel::UI.find('spark.components.Label', :id => 'keyPressLabel')
    Melomel::UI.key_press(text_input, 'a')
    label.text.should == 'du'
  end
end