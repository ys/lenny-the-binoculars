require "bundler/audit/scanner"

class Lockfile
  attr_accessor :unpatched_gems, :insecure_sources

  def initialize(root = Dir.pwd)
    @root = root
    @insecure_sources = []
    @unpatched_gems = []
  end

  def scan
    Bundler::Audit::Scanner.new(@root).scan do |result|
      case result
      when Bundler::Audit::Scanner::InsecureSource
        @insecure_sources << result
      when Bundler::Audit::Scanner::UnpatchedGem
        @unpatched_gems << unpatched_gems
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
end
