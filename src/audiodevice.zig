const std = @import("std");
const miniAudio = @import("c.zig").ma;

pub const AudioDeviceInfo = struct {
    index: i32 = -1,
    identifier: []u8 = undefined,
    num_output_channels: u32 = 0,
    num_input_channels: u32 = 0,
    supported_samplerates: std.ArrayListUnmanaged(f32) = std.ArrayListUnmanaged(f32){},
    nominal_samplerate: f32 = 0,
    is_default_output: bool = false,
    is_default_input: bool = false,  
};

pub const AudioStreamConfig = struct {
    device_index: i32 = -1,
    desired_channels: u32 = 0,
    desired_samplerate: f32 = 0.0,
};

var devices = std.ArrayListUnmanaged(AudioDeviceInfo){};
var probed: bool = false;

//TODO is using different backends
pub fn makeAudioDeviceList(alloc: std.mem.Allocator) !std.ArrayListUnmanaged(AudioDeviceInfo) {
    
    initContext();
    if(probed){
        return devices;
    }
    
    probed = true;
    
    var result: miniAudio.ma_result = undefined;
    var playbackDevicedInfos: [*c]miniAudio.ma_device_info = undefined;
    var playbackDeviceCount: miniAudio.ma_uint32 = undefined;
    var captureDeviceInfos: [*c]miniAudio.ma_device_info = undefined;
    var captureDeviceCount: miniAudio.ma_uint32 = undefined;
    
    result = miniAudio.ma_context_get_devices(&context, &playbackDevicedInfos, &playbackDeviceCount, &captureDeviceInfos, &captureDeviceCount);
    if(result != miniAudio.MA_SUCCESS){
        std.log.err("Failed to retrieve audio device inforamtion",.{});
        return devices;
    }
    
    var device: miniAudio.ma_uint32 = 0;
    while(device < playbackDeviceCount): (device += 1){
        var lab_device_info: AudioDeviceInfo = .{};    
        lab_device_info.index = @intCast(i32,devices.items.len);
        lab_device_info.identifier = captureDeviceInfos[device].name[0..];
        
        if(miniAudio.ma_context_get_device_info(&context, miniAudio.ma_device_type_capture, &playbackDevicedInfos[device].id, &playbackDevicedInfos[device]) != miniAudio.MA_SUCCESS){
            continue;
        }
        
        lab_device_info.num_output_channels = 0;
        lab_device_info.num_input_channels = 2;
        try lab_device_info.supported_samplerates.append(alloc,@bitCast(f32,captureDeviceInfos[device].nativeDataFormats[device].sampleRate));
        lab_device_info.nominal_samplerate = 48000.0;
        lab_device_info.is_default_output = false;
        lab_device_info.is_default_input = (device == 0);

        try devices.append(alloc,lab_device_info);
        
    }
    return devices;
}

var context: miniAudio.ma_context =undefined;
pub fn initContext() void {
    if(miniAudio.ma_context_init(null, 0, null,&context) != miniAudio.MA_SUCCESS){
        std.debug.print("Failed to initialize",.{});
    }
}

const AudioDeviceIndex = struct {
    index: u32,
    valid: bool,
};

pub fn getDefaultOutputAudioDeviceIndex(alloc: std.mem.Allocator) !AudioDeviceIndex {
    var outputDevices = try makeAudioDeviceList(alloc);
    for(outputDevices.items) |out,idx| {
        if(out.is_default_output){
            return AudioDeviceIndex{.index = @intCast(u32,idx), .valid = true};
        }
    }
    return AudioDeviceIndex{.index = 0,.valid = false};
}

pub fn getDefaultInputAudioDeviceIndex(alloc: std.mem.Allocator) !AudioDeviceIndex {
   var inputDevices = try makeAudioDeviceList(alloc);
   for(inputDevices.items) |in,idx| {
        if(in.is_default_input){
            return AudioDeviceIndex{.index = @intCast(u32,idx), .valid = true};
        }
    }
    return AudioDeviceIndex{.index = 0,.valid = false};
}