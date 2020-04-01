// This tells the buildpack which version to install
// zig-release: zig-linux-x86_64-0.5.0+9e019ed26.tar.xz

const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const exe = b.addExecutable("zhttpd", "main.zig");
    exe.setBuildMode(.ReleaseSafe);
    const run_cmd = exe.run();

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    b.default_step.dependOn(&exe.step);
    b.installArtifact(exe);
}
