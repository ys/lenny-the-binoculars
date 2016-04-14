require "rails_helper"

RSpec.describe Lockfile do
  describe "#scan" do
    it "detects vulnerabilities" do
      vulnerable_path = fixtures_path("vulnerable_project")
      vulnerable_lockfile = Lockfile.new(vulnerable_path)
      vulnerable_lockfile.scan
      expect(vulnerable_lockfile).to be_vulnerable

      insecure_path = fixtures_path("insecure_project")
      insecure_lockfile = Lockfile.new(insecure_path)
      insecure_lockfile.scan
      expect(insecure_lockfile).to be_vulnerable

      not_vulnerable_path = fixtures_path("not_vulnerable_project")
      not_vulnerable_lockfile = Lockfile.new(not_vulnerable_path)
      not_vulnerable_lockfile.scan
      expect(not_vulnerable_lockfile).to_not be_vulnerable
    end
  end
end
