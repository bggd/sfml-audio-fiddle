require 'minitest/autorun'
require 'sfml/audio'


class TestSoundBuffer < Minitest::Test
  def setup
    @buffer = SFML::SoundBuffer.new 'test/resource/swish_3.wav'
    refute @buffer.failed?
  end

  def test_get_duration
    assert @buffer.get_duration > 0
  end
end


class TestSound < TestSoundBuffer
  def setup
    super
    @sound = SFML::Sound.new @buffer
    refute @sound.failed?
  end

  def test_play
    assert_equal :stopped, @sound.get_status
    @sound.play
    assert_equal :playing, @sound.get_status
    @sound.pause
    assert_equal :paused, @sound.get_status
    @sound.stop
    assert_equal :stopped, @sound.get_status
  end

  def test_volume
    assert_equal 100, @sound.get_volume.to_i
    @sound.set_volume 50
    assert_equal 50, @sound.get_volume.to_i
  end

  def test_pitch
    assert @sound.get_pitch >= 1.0
    @sound.set_pitch 0.5
    assert @sound.get_pitch < 0.6
  end

  def test_loop
    refute @sound.get_loop
    @sound.set_loop true
    assert @sound.get_loop
    @sound.set_loop false
    refute @sound.get_loop
  end
end
