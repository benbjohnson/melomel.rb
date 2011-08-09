require File.join(File.dirname(File.expand_path(__FILE__)), *%w[helper])

class MessagingTestCase < MiniTest::Unit::TestCase
  def setup
    @bridge = Melomel::Bridge.new('127.0.0.1', 10101)
  end


  #############################################################################
  #
  # Message Parsing
  #
  #############################################################################

  def test_should_parse_null
    message = '<return dataType="null"/>'
    assert_nil @bridge.parse_message_value(Nokogiri::XML(message).root)
  end

  def test_should_parse_integer
    message = '<return value="12" dataType="int"/>'
    assert_equal 12, @bridge.parse_message_value(Nokogiri::XML(message).root)
  end

  def test_should_parse_float
    message = '<return value="100.12" dataType="float"/>'
    assert_equal 100.12, @bridge.parse_message_value(Nokogiri::XML(message).root)
  end

  def test_should_parse_boolean_true
    message = '<return value="true" dataType="boolean"/>'
    assert_equal true, @bridge.parse_message_value(Nokogiri::XML(message).root)
  end

  def test_should_parse_boolean_false
    message = '<return value="false" dataType="boolean"/>'
    assert_equal false, @bridge.parse_message_value(Nokogiri::XML(message).root)
  end

  def test_should_parse_string
    message = '<return value="foo" dataType="string"/>'
    assert_equal 'foo', @bridge.parse_message_value(Nokogiri::XML(message).root)
  end

  def test_should_parse_object_proxy
    message = '<return value="123" dataType="object"/>'
    proxy = @bridge.parse_message_value(Nokogiri::XML(message).root)
    assert_instance_of Melomel::ObjectProxy, proxy
    assert_equal 123, proxy.proxy_id
    assert_equal @bridge, proxy.bridge
  end

  def test_should_throw_error_parsing_unknown_type
    message = '<return value="foo" dataType="unknown_type"/>'
    assert_raises Melomel::UnrecognizedTypeError do
      @bridge.parse_message_value(Nokogiri::XML(message).root)
    end
  end


  #############################################################################
  #
  # Message Formatting
  #
  #############################################################################

  def test_should_format_nil
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, nil)
    assert_equal '<root dataType="null"/>', xml.to_s
  end
  
  def test_should_format_integer
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, 12)
    assert_equal '<root value="12" dataType="int"/>', xml.to_s
  end
  
  def should_format_float
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, 100.12)
    assert_equal '<root value="100.12" dataType="float"/>', xml.to_s
  end

  def test_should_format_boolean_true
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, true)
    assert_equal '<root value="true" dataType="boolean"/>', xml.to_s
  end

  def test_should_format_boolean_false
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, false)
    assert_equal '<root value="false" dataType="boolean"/>', xml.to_s
  end

  def test_should_format_string
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, 'foo')
    assert_equal '<root value="foo" dataType="string"/>', xml.to_s
  end

  def test_should_format_object
    proxy = Melomel::ObjectProxy.new(@bridge, 123)
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, proxy)
    assert_equal '<root value="123" dataType="object"/>', xml.to_s
  end
end
