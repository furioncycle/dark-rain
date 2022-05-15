const std = @Import("std");
const ProcessingSizeInFrames: usize = 128;

const SchedulingState = enum(i7) {
    Unscheduled,
    Scheduled,
    Fade_in,
    Playing,
    Stopping,
    Resetting,
    Finishing,
    Finished,
};

pub fn AudioNodeScheduler(sampleRate: f32) type {
    return struct {
        playbackState: SchedulingState = SchedulingState.Unscheduled,
        epoch: i64 = 0,
        epochLength: i64 = 0,
        startWhen: u64 = max,
        stopWhen: u64 = max,
        renderOffset: i32 = 0,
        renderLength: i32 = 0,
        sampleRate: f32 = 1,
        onEnd: fn() void,
        onStart: fn(when: f32) void,  
        
        pub fn update(contextRenderLock: *ContextRenderLock, epock_length: i32) bool {
            _ = contextRenderLock;
            _ = epock_length;
            return false;
        }
        
        pub fn hasFinished(self: @This()) bool {
            return self.playbackState == SchedulingState.Finished;
        }
        
        pub fn playbackState(self: @This()) SchedulingState{
            return self.playbackState;
        }
        
        pub fn reset() void {
            
        }
        
        pub fn finish(contextRenderLock: *ContextRenderLock) void {
            _ = contextRenderLock;
        }
        
        pub fn start(when: f32) void {
            _ = when;
        }
        
        pub fn stop(when: f32) void {
            _ = when;
        }
    };
}
pub fn AudioNode(context: *AudioContext) type {
    return struct {
       name: []const u8,
       paramName : std.ArrayList([]const u8),
       paramShortNames : std.ArrayList([]const u8),
       settingNames : std.ArrayList([]const u8),
       settingShortNames : std.ArrayList([]const u8),      
       scheduler : AudioNodeScheduler,
       inputs: std.ArrayList(AudioNodeInput),
       outputs: std.ArrayList(AudioNodeOutput),
       params: std.ArrayList(AudioParam),
       settings: std.ArrayList(AudioSetting),
       channelCount: i16 = 0,
       channelCountMode: ChannelCountMode = ChannelCountMode.Max,
       channelInterpretation: ChannelInterpretation = ChannelInterpretation.Speakers,
       
       pub fn init() void {
            
        }
        
       pub fn deinit() void {
            
        }

       pub fn process(contextRenderLock: *ContextRenderLock, bufferSize: i16) void {
            _ = contextRenderLock;
            _ = bufferSize;
        }  
        
        pub fn reset(contextRenderLock: *ContextRenderLock) void {
            _ = contextRenderLock;
        }

        pub fn tailTime(contextRenderLock: *ContextRenderLock) void {
            _ = contextRenderLock;
        }    
        
        
        pub fn latencyTime(contextRenderLock: *ContextRenderLock) void {
            _ = contextRenderLock;
        }    
        
        pub fn isScheduledNode() bool {
            return false;
        }
        
        pub fn addInput(contextGraphLock: *ContextGraphLock, input: *AudioInputNode) void {
            _ = contextGraphLock;
            _ = input;
        }
        
        
        pub fn addOutput(contextGraphLock: *ContextGraphLock, input: *AudioOutputNode) void {
            _ = contextGraphLock;
            _ = input;
        }
        
        pub fn numberOfInputs() usize {
            return 0;
        }    
        
        pub fn numberOfOutputs() usize {
            return 0;
        }
        
        pub fn input(index: i16) *AudioNodeInput {
            _ = index;
            return null;
        }
        
        pub fn output(index: i16) *AudioNodeOutput {
            _ = index;
            return null;
        }
        
        pub fn output(str: *[]const u8) *AudioNodeOutput {
            _ = str;
            return null;
        }
        
        pub fn processIfNecessary(contextRenderLock: *ContextRenderLock, bufferSize: i16) void {
            _ = contextRenderLock;
            _ = bufferSize;
        }
        
        pub fn checkNumberOfChannelsForInput(contextRenderLock: *ContextRenderLock, input: *AudioNodeInput) void {
            _ = contextRenderLock;
            _ = input;
        }
        
        pub fn conformChannelCounts() void {
            
        }
        
        pub fn propagatesSilence(contextRenderLock: *ContextRenderLock) bool {
            _ = contextRenderLock;
            return false;
        }
        
        pub fn inputsAreSilent(contextRenderLock: *ContextRenderLock) bool {
            _ = contextRenderLock;
            return false;
        }
        
        pub fn silenceOutputs(contextRenderLock: *ContextRenderLock) void {
            _ = contextRenderLock;
        }
        
        pub fn unsilenceOutputs(contextRenderLock: *ContextRenderLock) void {
            _ = contextRenderLock;
        }
        
        pub fn channelCount() i16 {
            return 0;
        }
        
        pub fn setChannelCount(contextGraphLock: *ContextGraphLock, channelCount: i16) void {
            _ = contextGraphLock;
            _ = channelCount;
        }
        
        pub fn channelCountMode() ChannelCountMode {
            return null;
        }
        
        pub fn channelInterpretation() ChannelInterpretation {
            return null;
        }
        
        
        
        pub fn param(str: []const u8) *AudioParam {
            _ = str;
            return null;
        }
        
        pub fn setting(str: []const u8) *AudioSetting {
            _ = str;
            return null;
        }
        
        pub fn params() std.ArrayList(*AudioParam) {
            return null;
        }
        
        pub fn settings() std.ArrayList(*AudioSetting) {
            return null;
        }
        
        pub fn addInput(input: *AudioNodeInput) void {
            _ = input;
        }        
        
        pub fn addOutput(output: *AudioNodeOutput) void {
            _ = output;
        }
        
        pub fn pullInputs(contextRenderLock: *ContextRenderLock, bufferSize: i16) void {
            _ = contextRenderLock;
            _ = bufferSize;
        }
        
        //Friend class AudioContext
        fn scheduleDisconnect() void {
            scheduler.stop(0);
        }        
        
        fn disconnectionReady()  bool {
            return scheduler.playbackState != schedulingState.Playing;
        }
        
        
    };
}
