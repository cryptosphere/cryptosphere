class Cryptosphere::Resource::Home < Webmachine::Resource
  def to_html
    # Hax serve a static file!
    File.read File.expand_path("../../assets/index.html", __FILE__)
  end
end