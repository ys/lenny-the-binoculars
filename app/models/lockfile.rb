require "bundler/audit/scanner"

# Gemfile.lock model
class Lockfile
  attr_accessor :unpatched_gems, :insecure_sources

  def initialize(root = Dir.pwd)
    @root = root
    @insecure_sources = []
    @unpatched_gems = []
  end

  def state
    vulnerable? ? "failure" : "success"
  end

  def description
    if vulnerable?
      "#{insecure_sources_count} insecure sources, #{unpatched_gems_count} unpatched Gems"
    else
      "No vulnerabilities found"
    end
  end

  def scan
    Bundler::Audit::Scanner.new(@root).scan do |result|
      case result
      when Bundler::Audit::Scanner::InsecureSource
        @insecure_sources << result
      when Bundler::Audit::Scanner::UnpatchedGem
        @unpatched_gems << result
      end
    end
  end

  def insecure_sources_count
    @insecure_sources.size
  end

  def unpatched_gems_count
    @unpatched_gems.size
  end

  def vulnerable?
    @insecure_sources.any? || @unpatched_gems.any?
  end

  def to_h
    {
      unpatched_gems: gems_to_h,
      insecure_sources: sources_to_h
    }
  end

  def sources_to_h
    insecure_sources.map(&:source)
  end

  def gems_to_h
    unpatched_gems.map do |gem|
      gem_to_h(gem)
    end
  end

  def gem_to_h(gem)
    advisory = gem.advisory
    gem = gem.gem
    {
      name: gem.name,
      version: gem.version.to_s,
      cve: advisory.cve,
      osvdb: advisory.osvdb,
      criticality: advisory.criticality,
      advisory_url: advisory.url,
      patched_version: versions_to_json(advisory.patched_versions) || []
    }
  end

  def versions_to_json(versions)
    versions.map do |v|
      "#{v.requirements.first.first} #{v.requirements.first.last.version}"
    end
  end
end
