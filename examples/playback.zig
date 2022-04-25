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
 
  //First assumtion new no editfile existing 
  var tmpDir = std.testing.tmpDir(.{});
  defer tmpDir.cleanup();

  var file = try tmpDir.dir.createFile("temp.ogg",.{});
  defer file.close();
      
  try addExampleData(&file);
  
  edit = Edit.createEmptyEdit(&engine,editFile);
  
  //TODO Add changelistener for edit transport
    
  
  var clip = Helper.loadAudioFileAsClip(edit,&file,"temp");
  _ = clip;
  // GUI 
  try zgt.backend.init();

    var window = try zgt.Window.init();
    try window.set(
        zgt.Column(.{}, .{
            zgt.Row(.{}, .{
                zgt.Button(.{ .label = "Plugins",   .onclick = buttonClicked }),
                zgt.Button(.{ .label = "Settings",  .onclick = buttonClicked }),
                zgt.Button(.{ .label = "Play/Pause", .onclick = updatePlayButton }),
                zgt.TextField( .{.text = "No Edit Loaded"}),
                zgt.TextField( .{.text = ""}), //Need a timer for this
            }),
        })
    );

    window.resize(800, 600);
    window.show();
    zgt.runEventLoop();

    //How to resize everything?
}

fn updatePlayButton(button: *zgt.Button_Impl) !void {
    if(edit.transport.transportState.Playing){
        button.setLabel("Pause");
    }else {
        button.setLabel("Play");
    }
}

fn buttonClicked(button: *zgt.Button_Impl) !void {
    std.log.info("You clicked button with text {s}", .{button.getLabel()});
}