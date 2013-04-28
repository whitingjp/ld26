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
      synth.cacheSound();
      sounds[name] = synth;
    }

    public function init():void
    {
      addSynth("test", "1,,0.073,,0.339,0.253,,0.38,-0.043,,,0.001,,,,0.561,-0.048,-0.039,1,-0.032,0.045,,-0.005,0.5");

      addSynth("footstep", "3,,0.0573,,0.1226,0.25,,-0.9,-0.7,,,,,,,,0.02,,1,,,,-0.3399,0.5");
      addSynth("jump", "0,,0.1048,0.14,0.24,0.13,,0.1599,,,,,,0.0238,,,,,0.7823,,,0.1993,,0.5");
      addSynth("land", "0,,0.0998,,0.23,0.46,,-0.54,,,,0.02,,0.4775,,,-0.02,-0.14,1,,,,,0.5");
      addSynth("drawbow", "0,,0.12,0.19,0.25,0.23,,0.2199,0.02,,,,,0.08,-0.02,,-0.12,,0.77,,0.12,0.65,-0.24,0.5");
      addSynth("fire", "3,,0.0635,0.17,0.25,0.7,,0.28,,,,,,,,0.7856,0.585,-0.0764,1,,,,,0.7");
      addSynth("arrowhit", "3,,0.09,0.4,0.19,0.11,,-0.14,,,,0.5033,0.8836,,,,,,1,,,,,0.4");
      addSynth("arrowkill", "3,,0.0376,,0.3,0.25,,0.3999,-0.9,,,,,,,,,,0.78,-0.4399,,,0.02,0.4");
      addSynth("collect", "0,,0.135,,0.0549,0.2816,,,,,,,,0.04,,,,,1,,,0.1,,0.5");
      addSynth("cannotcollect", "0,,0.135,,0.13,0.2816,,-0.3199,,0.27,0.42,,,0.04,,,,,1,,,0.1,,0.5");
      addSynth("grapple", "3,,0.07,0.03,0.3,0.84,,-0.16,,,,,,,,,-0.2577,-0.0378,1,,,,,0.5");
      addSynth("grab", "0,,0.1663,,0.1406,0.19,,,,,,,,0.5816,,,,,1,,,0.1,,0.5");
      addSynth("pitfall", "3,0.14,0.17,,0.69,0.3222,,-0.26,,0.4,0.42,,,,,,,,1,,,,,0.5");
      addSynth("tileshake", "3,,0.1361,0.32,0.2553,0.11,,0.1959,,,,-0.3069,0.7976,,,0.5435,,,1,,,,,0.5");
      addSynth("tilefall", "3,,0.1361,0.32,0.44,0.05,,0.3,,,,-0.3069,0.7976,,,0.5435,,,1,,,,,0.5");
      addSynth("rabbitturn", "0,,0.1062,0.3193,0.1,0.7986,,,,,,0.5363,0.5406,,,,,,1,,,,,0.1");
      addSynth("climb", "3,,0.07,0.11,0.21,0.11,,-0.0799,,,,-0.3069,0.7976,,,0.5435,,,1,,,,,0.5");

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

      sounds[sound].playCached();
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