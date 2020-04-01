// A simple hello world server
const std = @import("std");
const net = std.net;
const fs = std.fs;
const os = std.os;

pub const io_mode = .evented;

pub fn main() anyerror!void {
    const req_listen_addr = try net.Address.parseIp4("0.0.0.0", 5000);

    var server = net.StreamServer.init(.{});
    defer server.deinit();

    try server.listen(req_listen_addr);

    std.debug.warn("listening at {}\n", .{server.listen_address});

    while (true) {
        const conn = try server.accept();
        std.debug.warn("connection from {}\n", .{conn.address});
        _ = try conn.file.write(
            \\HTTP/1.1 200 OK
            \\Content-Length: 15
            \\Content-Type: text/plain; charset=UTF-8
            \\Server: Example
            \\Date: Wed, 17 Apr 2013 12:00:00 GMT
            \\
            \\Hello, World!
            \\
        );
        conn.file.close();
    }
}
