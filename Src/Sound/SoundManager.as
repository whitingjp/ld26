package Src.Sound
{
  import mx.core.*;
  import mx.collections.*;
  import flash.media.*;
  import flash.events.*;

  public class SoundManager
  {
    public static var SOUND_ENABLED:Boolean = true;
    public static var MUSIC_ENABLED:Boolean = false;

    [Embed(source="../../sound/test.mp3")]
    [Bindable]
    private var mp3Music:Class;
    private var musicSounds:Object;
    private var channel:SoundChannel;
    private var currentTrack:String;

    private var sounds:Object;

    public function SoundManager()
    {
      sounds = new Object()
      musicSounds = new Object();
    }
    
    private function addSynth(name:String, settings:String):void
    {
      var synth:SfxrSynth = new SfxrSynth();
      synth.setSettingsString(settings);
      synth.cacheMutations(5);
      sounds[name] = synth;
    }

    public function init():void
    {
      addSynth("test", "1,,0.073,,0.339,0.253,,0.38,-0.043,,,0.001,,,,0.561,-0.048,-0.039,1,-0.032,0.045,,-0.005,0.5");

      // Do music
      musicSounds['test'] = new mp3Music() as SoundAsset;
      playMusic('test');
    }

    public function playSound(sound:String):void
    {
      if(!SOUND_ENABLED)
        return;
        
      if(!sounds.hasOwnProperty(sound))
      {
        trace("Sound '"+sound+"' not found!");
        return;
      }      

      sounds[sound].playCachedMutation();
    }

    public function playMusic(track:String):void
    {
      currentTrack = track;
      if(!MUSIC_ENABLED)
        return;
        
      if(!musicSounds.hasOwnProperty(track))
      {
        trace("Music '"+track+"' not found!");
        return;      
      }

      stopMusic();
      channel = musicSounds[currentTrack].play();
      setVol(0.1);
      channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
    }

    public function stopMusic():void
    {
      if(channel)
        channel.stop();
    }

    public function setVol(vol:Number):void
    {
      if(channel)
      {
        var transform:SoundTransform = channel.soundTransform;
        transform.volume = vol;
        channel.soundTransform = transform;
      }
    }

    private function soundCompleteHandler(event:Event):void
    {
      playMusic(currentTrack);
    }
  }
}