require File.join(File.dirname(File.expand_path(__FILE__)), *%w[helper])

class IntegrationTestCase < RunnerTestCase
  def setup
    start_runner
    Melomel.connect()
  end

  def teardown
    stop_runner
  end

  def test_should_find_list_of_labels_named_foo
    labels = Melomel.find_all('spark.components.Label', :name => 'foo')
    assert_equal 3, labels.length
  end

  def should_find_text_input
    text_input = Melomel.find('spark.components.TextInput', :id => 'nameTextInput')
    assert_equal 'nameTextField', text_input.name
  end
  

  def test_should_click_button
    button = Melomel.find('spark.components.Button', :id => 'clickButton')
    label = Melomel.find('spark.components.Label', :id => 'clickLabel')
    Melomel.click(button)
    assert_equal 'Hello!', label.text
  end

  def test_should_double_click_the_button
    button = Melomel.find('spark.components.Button', :id => 'doubleClickButton')
    label = Melomel.find('spark.components.Label', :id => 'doubleClickLabel')
    Melomel.double_click(button)
    assert_equal 'Hello Hello!', label.text
  end


  def test_should_press_key_down
    text_input = Melomel.find('spark.components.TextInput', :id => 'keyDownTextInput')
    label = Melomel.find('spark.components.Label', :id => 'keyDownLabel')
    Melomel.key_down(text_input, 'a')
    assert_equal 'a', label.text
  end

  def test_should_release_key_up
    text_input = Melomel.find('spark.components.TextInput', :id => 'keyUpTextInput')
    label = Melomel.find('spark.components.Label', :id => 'keyUpLabel')
    Melomel.key_up(text_input, 'b')
    assert_equal 'b', label.text
  end

  def test_should_press_key
    text_input = Melomel.find('spark.components.TextInput', :id => 'keyPressTextInput')
    label = Melomel.find('spark.components.Label', :id => 'keyPressLabel')
    Melomel.key_press(text_input, 'a')
    assert_equal 'du', label.text
  end
end
