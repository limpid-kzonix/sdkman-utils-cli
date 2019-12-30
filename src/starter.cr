require "admiral"
require "logger"

module Starter
  VERSION = "0.1.0"

  log_file = File.new("sdku-cli.log", "a")
  log_writer = IO::MultiWriter.new(log_file, STDOUT)

  log = Logger.new(log_writer)
  log.level = Logger::DEBUG
  log.debug("Application started")
  class OrinalCLIChecker

    def self.init()

    end
  end

  class Complex < Admiral::Command
    define_flag planet

    def run
      puts "Hello #{flags.planet || "World"}"
    end
  end

  env : Process::Env = Hash(String, String?).new

  ENV.each do |key, value|
    puts "#{key} => #{value}"
    env[key] = value
  end

  sdk_dir = ENV["SDKMAN_DIR"]

  content : String | Nil = nil
  # Reads current sdk main shell-script
  File.open("#{sdk_dir}/src/sdkman-main.sh") do |file|
    content = file.gets_to_end
    if content.nil?
      puts "Hello open"
    else
      puts content
    end
  end

  process = Process.new("bash", ["-c", "source #{sdk_dir}/bin/sdkman-init.sh;sdk list"], output: Process::Redirect::Pipe)
  output = process.output?
  puts typeof(output)
  if !output.nil? && output.is_a?(IO::FileDescriptor)
    raw_text_output = output.gets_to_end
    process.wait.success?
    puts raw_text_output
  end

end
