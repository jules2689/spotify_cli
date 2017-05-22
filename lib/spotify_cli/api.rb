require 'spotify_cli/app'

module SpotifyCli
  class Api
    PLAY = "▶"
    STOP = "◼"
    SPOTIFY_SEARCH_API = "https://api.spotify.com/v1/search"

    class << self
      # Changes to the next song
      #
      # Usage:
      #   - spotify next
      def next
        puts "Playing next song"
        SpotifyCli::App.next!
      end

      # Changes to the previous song
      #
      # Usage:
      #   - spotify previous
      def previous
        puts "Playing previous song"
        SpotifyCli::App.prev!
      end

      # Sets the position in the song
      #
      # Usage:
      #   - spotify set_pos 60
      def set_pos
        puts "Setting position to #{ARGV[1]}"
        SpotifyCli::App.set_pos!(ARGV[1])
      end

      # Replays the current song
      #
      # Usage:
      #   - spotify replay
      def replay
        puts "Restarting song"
        SpotifyCli::App.replay!
      end
      
      # Play/Pause the current song, or play a specified artist,
      # track, album, or uri
      #
      # Usage:
      #   - spotify play artist [name]
      #   - spotify play track [name]
      #   - spotify play album [name]
      #   - spotify play uri [spotify uri]
      def play_pause
        args = ARGV[1..-1]

        if args.empty?
          # no specifying paremeter, this is a standard play/pause
          SpotifyCli::App.play_pause!
          status
          return
        end

        arg = args.shift
        type = arg == 'song' ? 'track' : arg

        Dex::UI.frame("Searching for #{type}", timing: false) do
          play_uri = case type
          when 'album', 'artist', 'track'
            results = search_and_play(type: type, query: args.join(' '))
            results.first
          when 'uri'
            args.first
          end
          puts "Results found, playing"
          SpotifyCli::App.play_uri!(play_uri)
          sleep 0.05 # Give time for the app to switch otherwise status may be stale
        end

        status
      end

      # Pause/stop the current song
      #
      # Usage:
      #   - spotify pause
      #   - spotify stop
      def pause
        SpotifyCli::App.pause!
        status
      end

      # Show the current song
      #
      # Usage:
      #   - spotify
      #   - spotify status
      def status
        stat = SpotifyCli::App.status

        time = "#{stat[:position]} / #{stat[:duration]}"
        state_sym = case stat[:state]
        when 'playing'
          PLAY
        else
          STOP
        end
        # 3 for padding around time, and symbol, and space for the symbol, 2 for frame
        width = Dex::UI::Terminal.width - time.size - 5

        Dex::UI.frame(stat[:track], timing: false) do
          puts Dex::UI.resolve_text([
            "{{bold:Artist:}} #{stat[:artist]}",
            "{{bold:Album:}} #{stat[:album]}",
          ].join("\n"))
          puts [
            Dex::UI::Progress.progress(stat[:percent_done], width),
            state_sym,
            time
          ].join(' ')
        end
      end

      # Display Help
      #
      # Usage:
      #  - spotify help
      def help(mappings)
        require 'method_source'

        Dex::UI.frame('Spotify CLI', timing: false) do
          puts "CLI interface for Spotify"
        end

        mappings.group_by { |_,v| v }.each do |k, v|
          v.reject! { |mapping| mapping.first == k.to_s }
          doc = self.method(k).comment.gsub(/^#\s*/, '')
          doc = strip_heredoc(doc)

          Dex::UI.frame(k, timing: false) do
            puts strip_heredoc(doc)
            next if v.empty?
            puts "\nAliases:"
            v.each { |mapping| puts " - info:#{mapping.first}" }
          end
        end
      end

      private

      def search_and_play(args)
        type = args[:type]
        type2 = args[:type2] || type
        query = args[:query]
        limit = args[:limit] || 1
        puts "Searching #{type}s for: #{query}";

        curl_cmd = <<-EOF
        curl -s -G #{SPOTIFY_SEARCH_API} --data-urlencode "q=#{query}" -d "type=#{type}&limit=#{limit}&offset=0" -H "Accept: application/json" \
        | grep -E -o "spotify:#{type2}:[a-zA-Z0-9]+" -m #{limit}
        EOF

        `#{curl_cmd}`.strip.split("\n")
      end

      # The following methods is taken from activesupport
      #
      # https://github.com/rails/rails/blob/d66e7835bea9505f7003e5038aa19b6ea95ceea1/activesupport/lib/active_support/core_ext/string/strip.rb
      #
      # All credit for this method goes to the original authors.
      # The code is used under the MIT license.
      #
      # Strips indentation by removing the amount of leading whitespace in the least indented
      # non-empty line in the whole string
      #
      def strip_heredoc(str)
        str.gsub(/^#{str.scan(/^[ \t]*(?=\S)/).min}/, "".freeze)
      end
    end
  end
end
