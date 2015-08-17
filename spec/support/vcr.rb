require 'vcr'

def underscorize(key)
  key.to_s.sub(/^(v[0-9]+|ns):/, "")
     .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
     .gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
end

VCR.configure do |c|
  c.cassette_library_dir = File.join(Dir.pwd, 'spec/vcr')
  c.hook_into :webmock
end

RSpec.configure do |c|
  c.around(:each, :vcr) do |example|
    name = example.metadata[:full_description]
    name = name.split(/\s+/, 2).join("/")
    name = underscorize(name)
    name = name.gsub(/[^\w\/]+/, "_")
    VCR.use_cassette(name) { example.call }
  end
end