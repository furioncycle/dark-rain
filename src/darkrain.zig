// Project is trying to reimage Tracktion, which
// is heavily using JUCE
const std = @import("std");

pub const WavAudioClip = @import("wavaudioclip.zig");

pub const Edit = @import("edit.zig");

pub const AudioDevice = @import("audiodevice.zig");

pub const Engine = struct {
    ProjectName: []const u8,
   
};
      
pub const TransportControl = struct {
    transportState: TransportState = undefined,
    
    pub fn isPlaying(self: @This()) bool {
        _ = self;
        return false;
        //var ph = getNodePlayHead() orelse false;
        //return ph.isPlaying();
    }
    const Self = @This();
    pub fn stop(self: *Self,discardRecordings: bool, clearDevices: bool) void {
        self.transportState.DiscardRecordings = discardRecordings;
        self.transportState.ClearDevices = clearDevices; 
        self.transportState.CanSendMMCStop = true;
        self.transportState.InvertToStartPosSelection = false;
        self.transportState.Playing = false;
    }

    pub fn play(self: *Self, justSendMMCIfEndabled: bool) void {
        self.transportState.JustSendMMCIfEnabled = justSendMMCIfEndabled;
        self.transportState.Playing = true;
    }
    
    pub fn stopIfRecording(self: *Self) void {
        if(self.transportState.IsRecording) {
            self.stop(false,false);
        }
    }
    
};

pub const TransportState = struct {
    Playing: bool = undefined,    
    DiscardRecordings: bool = undefined,
    ClearDevices: bool = undefined,
    CanSendMMCStop: bool = undefined, 
    InvertToStartPosSelection: bool = undefined,
    JustSendMMCIfEnabled: bool = undefined,
    IsRecording: bool = undefined,
};

pub const EditTimeRange = struct {
    start: f32,
    end: f32, 
};

pub const ClipPosition = struct {
    time: EditTimeRange,
    offset: f32,
};

pub const AudioTrack = struct {
    pub fn InsertPoint(parent: *AudioTrack, preceding: *AudioTrack) *AudioTrack {
        _ = preceding;
        return parent;
    } 
    
    pub fn insertWaveClip(self: @This(),source: *std.fs.File, sourceName: []const u8, position: ClipPosition, deleteExistingClips: bool ) WavAudioClip {   
        _ = self;
        _ = source; 
        _ = sourceName;
        _ = position; 
        _ = deleteExistingClips;
        return WavAudioClip{};
    } 
};

pub const SelectionManager = struct {
    
};

pub fn removeAllClips(track: ?*AudioTrack) void {
    _ = track;
}

pub const AudioFile_Impl = struct {
    engine: *Engine,
    file: *std.fs.File, 
    
    pub fn isValid(self: @This()) bool {
        _ = self;
        return false;
    }
    
    pub fn len(self: @This()) u32 {
        _ = self;
        return 0;
    }
};

pub fn AudioFile(engine: *Engine, file: *std.fs.File) AudioFile_Impl {
    var audioFile = AudioFile_Impl{
        .engine = engine,
        .file = file,
    };
    return audioFile;
}