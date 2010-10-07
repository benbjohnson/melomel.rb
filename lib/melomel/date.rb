module Melomel
  # This class contains helper methods for working with Flash dates.
  class Date
    # Parses a date.
    #
    # text - The date string to parse.
    #
    # Example:
    #
    #   Melomel::Date.parse('02/04/2010') # => <Melomel::ObjectProxy>
    #
    # Returns a proxy to a date object in Flash.
    def self.parse(text)
      date = Melomel.create_object!('Date')
      date.time = Melomel.get_class!('Date').parse(text)
      date
    end
  end
end