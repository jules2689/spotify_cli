# Spotify Cli

Spotify Application wrapper for control via command line

![CLI Image](https://cloud.githubusercontent.com/assets/3074765/26330022/05ee8a14-3f18-11e7-9ea6-555940bf3182.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spotify_cli'
```

## Usage

#### next
Changes to the next song

Usage:
- `spotify next`

Aliases:
 - n

#### previous
Changes to the previous song

Usage:
- `spotify previous`

Aliases:
 - pr

#### set_pos
Sets the position in the song

Usage:
- `spotify set_pos 60`

Aliases:
 - pos

#### replay
Replays the current song

Usage:
- `spotify replay`

Aliases:
 - rep
 - restart

#### pause
Pause/stop the current song

Usage:
- `spotify pause`
- `spotify stop`

Aliases:
 - stop

#### play_pause
Play/Pause the current song, or play a specified artist,
track, album, or uri

Usage:
- `spotify play artist [name]`
- `spotify play track [name]`
- `spotify play album [name]`
- `spotify play uri [spotify uri]`

Aliases:
 - play
 - p

#### status
Show the current song

Usage:
- `spotify`
- `spotify status`

Aliases:
 - s

#### help
Display Help

Usage:
- `spotify help`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/spotify_cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

