class Array
  def extract_options!
    if last.is_a?(Hash) && last.instance_of?(Hash)
      pop
    else
      {}
    end
  end unless [].respond_to?(:extract_options!)
end
