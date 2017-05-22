module SpotifyCli
  class App
    class << self
      # Return the state Spotify is in.
      # Either "playing" or "paused"
      #
      # @return state [String]
      #
      def state
        oascript('tell application "Spotify" to player state as string')
      end

      # Return a hash representing the current status of Spotify
      # Contains state, current artist, current album, current track,
      # duration of the current track, position in the current track,
      # percent of the track complete
      #
      # @return status [Hash]
      #
      def status
        artist = oascript('tell application "Spotify" to artist of current track as string')
        album = oascript('tell application "Spotify" to album of current track as string')
        track = oascript('tell application "Spotify" to name of current track as string')
        duration = oascript(<<-EOF)
          tell application "Spotify"
          set durSec to (duration of current track / 1000) as text
          set tM to (round (durSec / 60) rounding down) as text
          if length of ((durSec mod 60 div 1) as text) is greater than 1 then
              set tS to (durSec mod 60 div 1) as text
          else
              set tS to ("0" & (durSec mod 60 div 1)) as text
          end if
          set myTime to tM as text & ":" & tS as text
          end tell
          return myTime
        EOF
        position = oascript(<<-EOF)
          tell application "Spotify"
          set pos to player position
          set nM to (round (pos / 60) rounding down) as text
          if length of ((round (pos mod 60) rounding down) as text) is greater than 1 then
              set nS to (round (pos mod 60) rounding down) as text
          else
              set nS to ("0" & (round (pos mod 60) rounding down)) as text
          end if
          set nowAt to nM as text & ":" & nS as text
          end tell
          return nowAt
        EOF

        {
          state: state,
          artist: artist,
          album: album,
          track: track,
          duration: duration,
          position: position,
          percent_done: percent_done(position, duration)
        }
      end

      # Play or Pause Spotify
      #
      def play_pause!
        oascript('tell application "Spotify" to playpause')
      end

      # Pause Spotify
      #
      def pause!
        oascript('tell application "Spotify" to pause')
      end

      # Pause a given URI
      #
      # @param uri [String] Spotify URI returned from the API
      #
      def play_uri!(uri)
        oascript("tell application \"Spotify\" to play track \"#{uri}\"")
      end

      # Change to the next song
      #
      def next!
        oascript('tell application "Spotify" to next track')
      end

      # Change to the previous song
      #
      def previous!
        oascript(<<-EOF)
        tell application "Spotify"
            set player position to 0
            previous track
        end tell
        EOF
      end

      # Set position in song to the given point
      #
      # @param pos [Int] Position in seconds
      #
      def set_pos!(pos)
        oascript("tell application \"Spotify\" to set player position to #{pos}")
      end

      # Replay the current song from the beginning
      #
      def replay!
        oascript('tell application "Spotify" to set player position to 0')
      end

      private

      def percent_done(position, duration)
        seconds = ->(parts) do
          acc = 0
          multiplier = 1
          while part = parts.shift
            acc += part.to_f * multiplier
            multiplier *= 60
          end
          acc
        end
        pos_parts = position.split(':').reverse
        dur_parts = duration.split(':').reverse
        seconds.call(pos_parts) / seconds.call(dur_parts)
      end

      def oascript(command)
        `osascript -e '#{command}'`.strip
      end
    end
  end
end
