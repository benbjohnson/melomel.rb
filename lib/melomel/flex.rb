module Melomel
  # This class contains helper methods for working with Flex components.
  class Flex
    # Retrieves a list of classes associated with a commonly named component.
    #
    # name - The common name of the component.
    #
    # Example:
    #
    #   Melomel.get_component_classes('button')
    #   # => ['mx.controls.Button', 'spark.components.Button']
    #
    # Returns a list of classes associated with a component's common name.
    def self.get_component_classes(name)
      case name.downcase
        when 'alert' then ['mx.controls.Alert']
        when 'button' then ['mx.controls.Button', 'spark.components.supportClasses.ButtonBase']
        when 'check box' then ['mx.controls.CheckBox', 'spark.components.CheckBox']
        when 'color picker' then ['mx.controls.ColorPicker']
        when 'combo box' then ['mx.controls.ComboBox', 'spark.components.ComboBox']
        when 'data grid' then ['mx.controls.DataGrid']
        when 'date chooser' then ['mx.controls.DateChooser']
        when 'date field' then ['mx.controls.DateField']
        when 'scroll bar' then ['mx.controls.HScrollBar', 'mx.controls.VScrollBar', 'spark.components.HScrollBar', 'spark.components.VScrollBar']
        when 'slider' then ['mx.controls.HSlider', 'mx.controls.VSlider', 'spark.components.HSlider', 'spark.components.VSlider']
        when 'image' then ['mx.controls.Image']
        when 'label' then ['mx.controls.Label', 'spark.components.Label', 'spark.components.RichText']
        when 'list' then ['mx.controls.List', 'spark.components.List']
        when 'menu' then ['mx.controls.Menu']
        when 'menu bar' then ['mx.controls.MenuBar']
        when 'panel' then ['mx.containers.Panel', 'spark.components.Panel']
        when 'stepper' then ['mx.controls.NumericStepper', 'spark.components.Spinner']
        when 'pop up button' then ['mx.controls.PopUpButton']
        when 'pop up menu button' then ['mx.controls.PopUpMenuButton']
        when 'progress bar' then ['mx.controls.ProgressBar']
        when 'radio button' then ['mx.controls.RadioButton', 'spark.components.RadioButton']
        when 'rich text area' then ['mx.controls.RichTextEditor', 'spark.components.RichEditableText']
        when 'tab' then ['mx.controls.tabBarClasses.Tab']
        when 'text field' then ['mx.controls.TextInput', 'spark.components.TextInput']
        when 'text area' then ['mx.controls.TextArea', 'spark.components.TextArea']
        when 'tool tip' then ['mx.controls.ToolTip']
        when 'tree' then ['mx.controls.Tree']
      end
    end
  end
end