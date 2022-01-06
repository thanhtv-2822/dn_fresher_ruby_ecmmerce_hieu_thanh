module ApplicationHelper
  include Pagy::Frontend

  def convert_array_to_string? attribute
    attribute.split(/[._]/).join(" ")
  end
end
