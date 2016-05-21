class Repo
  include ActiveModel::Model

  attr_accessor :name_with_owner, :sha

  def check_lockfile!
    raise(StandardError, "No Gemfile.lock found") unless gemfile?
    write_gemfile_in_local_folder
    lockfile = Lockfile.new(local_folder)
    lockfile.scan
    lockfile
  end

  def gemfile?
    gemfile_lock
    true
  rescue Octokit::NotFound
    false
  end

  def gemfile_lock
    @content ||= begin
      encoded_content = github_file("Gemfile.lock")
      Base64.decode64(encoded_content)
    end
  end

  private

  def write_gemfile_in_local_folder
    File.open(File.join(local_folder, "Gemfile.lock"), "w") do |f|
      f.write gemfile_lock
    end
  end

  def local_folder
    @local_folder ||= Dir.tmpdir
  end

  def github_file(file)
    github.contents(name_with_owner, ref: sha, path: file)["content"]
  end

  def github
    Octokit::Client.new(access_token: ENV["GITHUB_API_TOKEN"])
  end
end