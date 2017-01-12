require 'fiddle/import'


module SFMLImporter
  extend Fiddle::Importer
  dlload 'csfml-audio-2'
  
  SFSTOPPED = 0
  SFPAUSED  = 1
  SFPLAYING = 2

  extern 'void* sfSoundBuffer_createFromFile(const char*)'
  extern 'void* sfSoundBuffer_destroy(void*)'
  extern 'int sfSoundBuffer_getDuration(void*)'

  extern 'void* sfSound_create()'
  extern 'void* sfSound_copy(void*)'
  extern 'void sfSound_destroy(void*)'
  extern 'void sfSound_setBuffer(void*, const void*)'
  #extern 'cosnt void* sfSound_getBuffer(const void*)'
  extern 'void sfSound_stop(void*)'
  extern 'void sfSound_play(void*)'
  extern 'void sfSound_pause(void*)'
  extern 'long long sfSound_getStatus(void*)'
  extern 'void sfSound_setLoop(void*, int)'
  extern 'int sfSound_getLoop(void*)'
  extern 'void sfSound_setPitch(void*, float)'
  extern 'float sfSound_getPitch(void*)'
  extern 'void sfSound_setVolume(void*, float)'
  extern 'float sfSound_getVolume(void*)'
  extern 'void sfSound_setPlayingOffset(void*, long long)'
  extern 'long long sfSound_getPlayingOffset(void*)'

  extern 'void* sfMusic_createFromFile(const char*)'
  extern 'void sfMusic_destroy(void*)'
  extern 'void sfMusic_setLoop(void*, int)'
  extern 'int sfMusic_getLoop(void*)'
  extern 'void sfMusic_play(void*)'
  extern 'void sfMusic_pause(void*)'
  extern 'void sfMusic_stop(void*)'
  extern 'long long sfMusic_getDuration(void*)'
  extern 'int sfMusic_getStatus(void*)'
  extern 'void sfMusic_setPlayingOffset(void*, long long)'
  extern 'long long sfMusic_getPlayingOffset(void*)'
  extern 'void sfMusic_setPitch(void*, float)'
  extern 'float sfMusic_getPitch(void*)'
  extern 'void sfMusic_setVolume(void*, float)'
  extern 'float sfMusic_getVolume(void*)'
end


module SFML
end


class SFML::SoundBuffer
  def self.dtor
    proc { |id|
      SFMLImporter.sfSoundBuffer_destroy(id)
    }
  end

  attr_reader :buffer
  def failed? ; @failed end

  def initialize(filename)
    @buffer = SFMLImporter.sfSoundBuffer_createFromFile(filename)
    @failed = if @buffer.null?
                true
              else
                ObjectSpace.define_finalizer @buffer, SFML::SoundBuffer.dtor
                false
              end
  end
  def get_duration
    SFMLImporter.sfSoundBuffer_getDuration(@buffer) / 1000000.0
  end
end


class SFML::Sound
  def self.dtor
    proc { |id|
      SFMLImporter.sfSound_stop(id)
      SFMLImporter.sfSound_destroy(id)
    }
  end

  attr_reader :sound
  def failed? ; @failed end

  def initialize(buffer=nil)
    @sound = SFMLImporter.sfSound_create()
    @failed = @sound.null?
    if @failed
      return
    else
      @buffer = buffer
      if buffer
        SFMLImporter.sfSound_setBuffer(@sound, buffer.buffer)
      end
      ObjectSpace.define_finalizer @sound, SFML::Sound.dtor
    end
  end
  def initialize_copy(obj)
    @sound = SFMLImporter.sfSound_copy(obj.sound)
    @buffer = obj.buffer
  end
  def set_buffer(buffer)
    @buffer = buffer
    SFMLImporter.sfSound_setBuffer(@sound, buffer.buffer)
  end
  def get_buffer
    @buffer
  end
  def play
    SFMLImporter.sfSound_play(@sound)
  end
  def pause
    SFMLImporter.sfSound_pause(@sound)
  end
  def stop
    SFMLImporter.sfSound_stop(@sound)
  end
  def get_status
    case SFMLImporter.sfSound_getStatus(@sound)
    when SFMLImporter::SFSTOPPED
      :stopped
    when SFMLImporter::SFPAUSED
      :paused
    when SFMLImporter::SFPLAYING
      :playing
    end
  end
  def set_loop(b)
    SFMLImporter.sfSound_setLoop(@sound, (b ? 1 : 0))
  end
  def get_loop
    SFMLImporter.sfSound_getLoop(@sound) > 0
  end
  def set_pitch(f)
    SFMLImporter.sfSound_setPitch(@sound, f)
  end
  def get_pitch
    SFMLImporter.sfSound_getPitch(@sound)
  end
  def set_volume(f)
    SFMLImporter.sfSound_setVolume(@sound, f)
  end
  def get_volume
    SFMLImporter.sfSound_getVolume(@sound)
  end
  def set_playing_offset(time)
    SFMLImporter.sfSound_setPlayingOffset(@sound, time * 1000000.0)
  end
  def get_playing_offset
    SFMLImporter.sfSound_getPlayingOffset(@sound) / 1000000.0
  end
end

class SFML::Music
  def self.dtor
    proc { |id|
      SFMLImporter.sfMusic_stop(id)
      SFMLImporter.sfMusic_destroy(id)
    }
  end

  def failed? ; @failed end

  def initialize(filename)
    @music = SFMLImporter.sfMusic_createFromFile(filename)
    @failed = if @music.null?
                true
              else
                ObjectSpace.define_finalizer @music, SFML::Music.dtor
                false
              end
  end

  def set_loop(b)
    SFMLImporter.sfMusic_setLoop(@music, (b ? 1 : 0))
  end
  def get_loop
    SFMLImporter.sfMusic_getLoop > 0
  end
  def play
    SFMLImporter.sfMusic_play(@music)
  end
  def pause
    SFMLImporter.sfMusic_pause(@music)
  end
  def stop
    SFMLImporter.sfMusic_stop(@music)
  end
  def get_duration
    SFMLImporter.sfMusic_getDuration(@music) / 1000000.0
  end
  def get_status
    r = SFMLImporter.sfMusic_getStatus(@music)
    case r
    when SFMLImporter::SFSTOPPED
      :stopped
    when SFMLImporter::SFPAUSED
      :paused
    when SFMLImporter::SFPLAYING
      :playing
    end
  end
  def set_playing_offset(time)
    SFMLImporter.sfMusic_setPlayingOffset(@music, time * 1000000.0)
  end
  def get_playing_offset
    SFMLImporter.sfMusic_getPlayingOffset(@music) / 1000000.0
  end
  def set_pitch(f)
    SFMLImporter.sfMusic_setPitch(@music, f)
  end
  def get_pitch
    SFMLImporter.sfMusic_getPitch(@music)
  end
  def set_volume(f)
    SFMLImporter.sfMusic_setVolume(@music, f)
  end
  def get_volume
    SFMLImporter.sfMusic_getVolume(@music)
  end
end
