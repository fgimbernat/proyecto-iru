class ModalComponent < ViewComponent::Base
  def initialize(show_condition:, title:, size: "lg", **html_options)
    @show_condition = show_condition
    @title = title
    @size = size
    @html_options = html_options
  end

  def size_classes
    case @size
    when "sm"
      "max-w-sm"
    when "md"
      "max-w-md"
    when "lg"
      "max-w-lg"
    when "xl"
      "max-w-xl"
    when "2xl"
      "max-w-2xl"
    else
      "max-w-lg"
    end
  end
end
