## Zig Buildpack

This is a Buildpack for [Zig](https://ziglang.org/), the general-purpose
programming language and toolchain for maintaining robust, optimal, and
reusable software.

This buildpack is for building a zig project and deploying using heroku or
similar platforms.

### Usage and files needed

A `build.zig` file is needed. This is a standard zig build file except
it must contain a line with the following comment:


```zig
// zig-release: zig-linux-x86_64-<version-string+hash>.tar.xz
```

The buildpack looks for `// zig-release:` and uses whatever follows to determine
which version of zig to download and extract (see bin/steps/zig_compile).


The supported zig builds are the ones in [this list](https://ziglang.org/download/).

If the repo contains a `prebuild.zig` file in the repository root, that
will be run before building (eg to download files/repos needed).

It will run then run `zig build` and the rest is up to the `Procfile`.


### Example


An example `build.zig` shows how to define the zig version runtime.

```zig
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

```


