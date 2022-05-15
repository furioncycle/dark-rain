const std = @import("std");
const edit = @import("edit.zig");

const Track = @This();

pub fn AudioTrack(edit: *edit.Edit) type {

    return struct {
       
    };
}

pub fn getInputTracks(comptime track: type) []*type {
    _ = track;    
    return null;
}

pub fn findSidechainSourceTracks() []*type {
    return null;
}

pub fn getTracks(comptime track: type, edit: *Edit, recursive: bool) []*type {
    results: ?[32]*track null;
    const trackVisit = fn(comptime track: type, comptime index: i16) bool {
        results[index] = track;
        return true;
    };
    edit.VisitAllTracks(trackVist, recursive)
}

