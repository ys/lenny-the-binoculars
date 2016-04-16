require "pathname"
require "webmock/rspec"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  def fixtures_path(path)
    File.join(Rails.root, "spec", "fixtures", path)
  end

  def fixture_data(path)
    path = File.extname(path).present? ? path : "#{path}.json"
    File.read(fixtures_path(path))
  end

  def fixture_json(path)
    JSON.parse(fixture_data(path))
  end

  def default_json_headers
    { "Content-Type" => "application/json" }
  end

  def stub_json_request(method, url, response_body, status = 200)
    stub_request(method, url)
      .to_return(status: status, body: response_body, headers: default_json_headers)
  end

  def stub_github(method, path, response_body, status = 200)
    stub_request(method, "https://api.github.com#{path}")
    .with(:headers => {
      'Accept'=>'application/vnd.github.v3+json',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 4.3.0'
    }).to_return(:status => status, :body => response_body, :headers => { "Content-Type" => "application/json" })
  end
end
