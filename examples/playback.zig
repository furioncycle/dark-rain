const std = @import("std");
const zgt = @import("zgt");

//Library 
const dr = @import("darkrain");
const Engine = @import("darkrain").Engine;
const Edit = @import("darkrain").Edit;

//Utilities and testers
const ogg = @import("ogg.zig");
const Helper = @import("Helper.zig");

/// Playback demo taken from tracktion engine's examples
/// Tracktion engine uses sadly JUCE and has so much bloat 
/// to handle memory and other things 

var editFile: *std.fs.File = undefined;

var engine = Engine{.ProjectName = "PlaybackDemo"};

var edit: *Edit.Edit = undefined;

fn addExampleData(file: *std.fs.File) !void {
    try file.writeAll(ogg.BITS_Export_2_ogg[0..]);
}

pub fn main() !void {
 
  var playButton: *zgt.Button_Impl  = undefined;
  var plugins: *zgt.Button_Impl = undefined;
  var settings: *zgt.Button_Impl = undefined;
  var editName = zgt.Label(.{ .text = "No Edit Loaded."});  //First assumtion new no editfile existing 
  
  var tmpDir = std.testing.tmpDir(.{});
  defer tmpDir.cleanup();

  var file = try tmpDir.dir.createFile("temp.ogg",.{});
  defer file.close();
      
  try addExampleData(&file);
  
  edit = Edit.createEmptyEdit(&engine,editFile);
  
  //TODO Add changelistener for edit transport
    
  var clip = Helper.loadAudioFileAsClip(edit,&file,"temp");

  _ = Helper.loopAroundClip(@TypeOf(clip),&clip);
  
  editName.setText("Demo song");
  
  playButton = &zgt.Button( .{.label = "Play/Pause", .onclick = togglePlay,});
  plugins = &zgt.Button(.{ .label = "Plugins",   .onclick = pluginScan  });
  settings = &zgt.Button(.{ .label = "Settings",  .onclick = deviceSettings });  //        Helper.togglePlay(edit),
    
  try updatePlayButton(playButton);
    
  //TODO set timer in hertz startTimerHz(5);

  // GUI 
  try zgt.backend.init();

    var window = try zgt.Window.init();
    try window.set(
        zgt.Column(.{}, .{
            zgt.Row(.{}, .{
                plugins,                
                settings,
                playButton,
                editName,
                zgt.TextField( .{.text = ""}), //Need a timer for this
            }),
        })
    );

    window.resize(800, 600);
    window.show();
    zgt.runEventLoop();

}

fn pluginScan(button: *zgt.Button_Impl) !void {
    _ = button; 
    
}

fn deviceSettings(button: *zgt.Button_Impl) !void {
    _ = button;
    Helper.showAudioDeviceSettings(&engine);
}

fn togglePlay(button: *zgt.Button_Impl) !void {
    _ = button;
    Helper.togglePlay(edit);
}

fn updatePlayButton(button: *zgt.Button_Impl) !void {
    if(edit.transport.transportState.Playing){
        button.setLabel("Pause");
    }else {
        button.setLabel("Play");
    }
}

