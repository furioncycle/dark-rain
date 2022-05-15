const std = @import("std");
const AudioDevice = @import("darkrain").AudioDevice;
const AudioStreamConfig = AudioDevice.AudioStreamConfig;
const AudioDeviceInfo = AudioDevice.AudioDeviceInfo;
const tuple = struct {
    inputConfig: AudioStreamConfig = .{},
    outputConfig: AudioStreamConfig = .{},
};

fn getDefaultAudioDeviceConfiguration(with_input: bool) !tuple {
    
    var audioDevices = try AudioDevice.makeAudioDeviceList(std.testing.allocator);
    const default_output_device = try AudioDevice.getDefaultOutputAudioDeviceIndex(std.testing.allocator);
    const default_input_device = try AudioDevice.getDefaultInputAudioDeviceIndex(std.testing.allocator);
    
    var defaultOutputInfo: AudioDeviceInfo = undefined;
    var defaultInputInfo: AudioDeviceInfo = undefined;
    for (audioDevices.items)|item|{
        if(item.index == default_output_device.index) {
            defaultOutputInfo = item;
        } else if(item.index == default_input_device.index) defaultInputInfo = item;
    }
    var outputConfig: AudioStreamConfig = .{};
    if(defaultOutputInfo.index != -1){
        outputConfig.device_index = defaultOutputInfo.index;
        outputConfig.desired_channels = @minimum(2, defaultOutputInfo.num_output_channels);
        outputConfig.desired_samplerate =defaultOutputInfo.nominal_samplerate;
    }
    var inputConfig: AudioStreamConfig = .{};
    if(with_input){
        if(defaultInputInfo.index != -1){
            inputConfig.device_index = defaultInputInfo.index;
            inputConfig.desired_channels = @minimum(1, defaultInputInfo.num_input_channels);
            inputConfig.desired_samplerate = defaultInputInfo.nominal_samplerate;
        }else {
            std.debug.panic("Default audio input device was requested but none were found",.{});
        }
    }
    return tuple{.inputConfig = inputConfig,.outputConfig = outputConfig,};
}

pub fn main() !void {
//    var context: ?*AudioContext = undefined;
    
    var defaultAudioDeviceConfiguration = try getDefaultAudioDeviceConfiguration(false);
    _ = defaultAudioDeviceConfiguration;
//    context = try makeRealtimeAudioContext(defaultAudioDeviceConfiguration.second, defaultAudioDeviceConfiguration.first);
    //var ac : AudioContext = context.?.get();
    
  //  const musicClip = try MakeBusFromSampleFile("");
}
