require 'spotify_cli/version'
require 'dex/ui'
require 'spotify_cli/api'

module SpotifyCli
  # CLI interface for the application
  # Converts arguments to a mapped command and executes the command
  #
  # @param args [Array] CLI arugments
  #
  def self.call(args)
    mappings = {
      'next' => :next,
      'n' => :next,
      'previous' => :previous,
      'pr' => :previous,
      'set_pos' => :set_pos,
      'pos' => :set_pos,
      'replay' => :replay,
      'rep' => :replay,
      'restart' => :replay,
      'pause' => :pause,
      'stop' => :pause,
      'play' => :play_pause,
      'p' => :play_pause,
      'play_pause' => :play_pause,
      'status' => :status,
      's' => :status,
      'watch' => :watch,
      'w' => :watch,
      'help' => :help
    }

    if args.empty?
      SpotifyCli::Api.status
    else
      mapping = mappings[args.first]
      if mapping.nil? || mapping == :help
        SpotifyCli::Api.help(mappings)
      else
        SpotifyCli::Api.send(mapping)
      end
    end
  end
end
