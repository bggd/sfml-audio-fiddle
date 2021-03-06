# sfml-audio-fiddle
[![Gem Version](https://badge.fury.io/rb/sfml-audio-fiddle.svg)](http://badge.fury.io/rb/sfml-audio-fiddle)

fiddle(ruby's FFI) binding for SFML2 Audio functions.

#require csfml-audio and openal
download http://www.sfml-dev.org/download/csfml/

#example

```ruby
# play_sound.rb

require 'sfml/audio'


buffer = SFML::SoundBuffer.new 'sfx.wav'

sound = SFML::Sound.new buffer
sound.play

```

```ruby
# play_music.rb

require 'sfml/audio'

music = SFML::Music.new 'bgm.ogg'

puts "bgm.ogg length: #{music.get_duration}"

music.play

while music.get_status == :playing
  sleep 1
end

```

#API

```ruby

buffer = SFML::SoundBuffer.new filename
buffer.get_duration #=> length of sound buffer as seconds


sound = SFML::Sound.new buffer
sound.set_volume 0..100
sound.get_volume
sound.set_loop true_or_false
sound.get_loop
sound.set_buffer buffer
sound.get_buffer
sound.set_pitch 0.0..1.0
sound.get_pitch
sound.set_playing_offset sec
sound.get_playing_offset
sound.play
sound.pause
sound.stop
sound.get_status #=> :stopped or :playing or :paused

music = SFML::Music.new filename
music.get_duration
music.set_volume 0..100
music.get_volume
music.set_loop true_or_false
music.get_loop
music.set_pitch 0.0..1.0
music.get_pitch
music.set_playing_offset sec
music.get_playing_offset
music.play
music.pause
music.stop
music.get_status #=> :stopped or :playing or :paused


```
