class Cryptosphere::Resource::Home < Webmachine::Resource
  def to_html
    "<html><body>Hello, world!</body></html>"
  end
end