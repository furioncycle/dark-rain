const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});
    
    const lib = b.addStaticLibrary("dark-rain", "src/darkrain.zig");
    lib.setBuildMode(mode);
    lib.install();


    const main_tests = b.addTest("src/darkrain.zig");
    main_tests.setBuildMode(mode);
    main_tests.setTarget(target);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    const playback = b.addExecutable("playback","examples/playback.zig");
    playback.setTarget(target);
    playback.setBuildMode(mode);
    playback.addPackagePath("darkrain","src/darkrain.zig");
    
    const simpleExample = b.addExecutable("simple", "examples/simpleExample.zig");
    simpleExample.setTarget(target);
    simpleExample.setBuildMode(mode);
    simpleExample.addPackagePath("darkrain", "src/darkrain.zig");
    simpleExample.install();    
    simpleExample.linkSystemLibrary("pthread");
    simpleExample.linkSystemLibrary("m");
    simpleExample.linkSystemLibrary("dl");

    simpleExample.addIncludeDir("" ++ "miniaudio");
    simpleExample.addIncludeDir("" ++ "miniaudio/research");

    const c_flags = &[_][]const u8{"-DMA_NO_FLAC", "-DMA_NO_WEBAUDIO","-DMA_NO_ENCODING","-DMA_NO_NULL"};
    simpleExample.addCSourceFile(""++"src/c_src/miniaudio.c",c_flags);    
    
    try @import("examples/zgt/build.zig").install(playback, "examples/zgt");

    const playback_step = b.step("playback", "Run playback example");
    playback_step.dependOn(&playback.run().step);
    
    const simple_step = b.step("simple", "Run simple example");
    simple_step.dependOn(&simpleExample.run().step);
    
    
}
