module Buildpack
  module Shell; end

  class BuildpackRunner
    include Shell

    BUILDKITS_BASE = "https://buildpack-registry.s3.amazonaws.com/buildpacks"

    def initialize(output_io, error_io, name)
      @output_io = output_io
      @error_io  = error_io
      @name      = name
      @fetcher   = Fetcher.new(BUILDKITS_BASE)
    end

    def run(build_dir, cache_dir, env_dir, exports = [])
      release = {}
      export  = nil

      fetch_buildpack do
        output, status = system("bin/detect #{build_dir}")
        @output_io.topic "#{output.chomp} detected"
        on_error(status, "Could not detect a #{@name} compatible app")
        status = pipe("#{source_exports(exports)} bin/compile #{build_dir} #{cache_dir} #{env_dir}")
        on_error(status, "Failed trying to compile #{@name}")
        output, status = system("#{source_exports(exports)} bin/release #{build_dir}")
        on_error(status, "bin/release failed")
        release = YAML.load(output)
        export  = File.read("export") if File.exist?("export")
      end

      [release, export]
    end

    def test_compile(build_dir, cache_dir, env_dir, exports = [])
      export = nil

      fetch_buildpack do
        status = pipe("#{source_exports(exports)} bin/test-compile #{build_dir} #{cache_dir} #{env_dir}")
        on_error(status, "Failed trying test-compile #{@name}")

        export = File.read("export") if File.exist?("export")
      end

      export
    end

    def test(build_dir, env_dir)
      fetch_buildpack do
        pipe_exit_on_error("bin/test #{build_dir} #{env_dir}", @output_io, nil)
      end
    end

    private
    def on_error(status, message)
      if !status.success?
        @error_io.topic message
        exit status.exitstatus
      end
    end

    def source_exports(exports)
      if exports.any?
        exports.map {|export| ". #{export}" }.join(" && ") + " &&"
      else
        ""
      end
    end

    def fetch_buildpack
      @output_io.topic "Fetching buildpack #{BUILDKITS_BASE}#{@name}"
      filename = "#{@name.split("/").last}.tgz"

      if block_given?
        mktmpdir("buildpack") do |dir|
          Dir.chdir(dir) do
            @fetcher.fetch("#{@name}.tgz", filename)
            @fetcher.unpack(filename)

            yield
          end
        end
      else
        @fetcher.fetch("#{@name}.tgz", filename)
        @fetcher.unpack(filename)
      end
    end
  end
end
