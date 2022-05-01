const std = @import("std");
const WavAudioClip = @import("darkrain").WavAudioClip;
const Edit = @import("darkrain").Edit;
const Engine = @import("darkrain").Engine;
const AudioTrack = @import("darkrain").AudioTrack; 
const dr = @import("darkrain");

pub fn getOrInsertAt(edit: *Edit.Edit, index: usize) *AudioTrack {

   edit.ensureNumberOfAudioTracks(index + 1);
   return Edit.getAudioTracks(edit)[index];        
}

pub fn loadAudioFileAsClip(edit: *Edit.Edit, file: *std.fs.File, fileName: []const u8) WavAudioClip {
        
   const track = getOrInsertAt(edit,0);
     
   dr.removeAllClips(track);        
      
   var audioFile = dr.AudioFile(edit.engine, file);

   if(audioFile.isValid()){
      return track.insertWaveClip(
         file, 
         fileName,
         .{
            .time = .{
               .start = 0.0,
               .end = @bitCast(f32,audioFile.len()),
            },
            .offset = 0.0
         },
         false);

   }
   
   return WavAudioClip{};
}

pub fn loopAroundClip(comptime clip_type: type, clip: *clip_type) *clip_type {
   return clip;
}

pub fn togglePlay(edit: *Edit.Edit) void {

   if(edit.transport.isPlaying()){
      edit.transport.stop(false,false);      
   }else {
      edit.transport.play(false);
   }
}

//TODO create another window dialoge for audio devices
pub fn showAudioDeviceSettings(engine: *Engine) void {
   _ = engine;
}