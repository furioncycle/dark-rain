const std = @import("std");

const TransportControl = @import("darkrain.zig").TransportControl;
const Engine = @import("darkrain.zig").Engine;
const Track = @import("darkrain.zig").Track;
const SelectionManager = @import("darkrain.zig").SelectionManager;
const AudioTrack = @import("darkrain.zig").AudioTrack;

pub const Edit = struct {
      transport: TransportControl = undefined,
      engine: *Engine = undefined,
      id: usize,
      
      const Self = @This() ;
      
      pub fn ensureNumberOfAudioTracks(self: *Self,minimumNumTracks: usize) void {
            _ = self;
            _ = minimumNumTracks;
      }
    
      pub fn InsertNewAudioTracks(self: *Self, track: Track, sm: *SelectionManager) void {
          _ = self;
          _ = track;
          _ = sm;
      }   
};

pub fn createEmptyEdit(engine: *Engine, editFile: *std.fs.File) *Edit{
     _ = editFile;
     
     var options = Options{
        .engine = engine,
        .id = 0,          
     };        
     return &Edit{
       . transport = .{
          .transportState = .{
              .Playing = false,
          },
       },
       .engine = options.engine,
       .id = options.id,
    }; //TODO finish up the structure
} 

const Options = struct {
    engine: *Engine,
    id: usize,
    //editState: ValueTree,
    //editProjectItemId: ProjectItemId,  
    
    //role: EditRole = forEditing,
    //loadContext: ?*LoadContext = undefined,
    //numUndoLevelsToStore: i16 = Edit.getDefaultUndoLevels(),
    
    //editFileRetriver: *fn()std.fs.File,
   // filePathResolver: *fn(path: []const u8) std.fs.File,
};


//Utilities
pub fn getAudioTracks(edit: *Edit) []*AudioTrack {
    _ = edit;
    return  undefined;
}

pub fn getTopLevelTrack(edit: *Edit) []*Track {
    _ = edit;
    return undefined;
}

