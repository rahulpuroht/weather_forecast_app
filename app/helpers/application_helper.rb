module ApplicationHelper
  def flash_class(level)
    case level.to_sym
    when :notice then "alert-success"
    when :success then "alert-success"
    when :error then "alert-danger"
    when :alert then "alert-danger"
    when :warn, :warning then "alert-warning"
    end
  end
end
