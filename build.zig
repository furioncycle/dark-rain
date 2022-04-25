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

    try @import("examples/zgt/build.zig").install(playback, "examples/zgt");

    const playback_step = b.step("playback", "Run playback example");
    playback_step.dependOn(&playback.run().step);
}
