const std = @import("std");

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);
    var zero_count: i64 = 0;
    var position: i64 = 50;

    while (try reader.interface.takeDelimiter('\n')) |line| {
        if (line.len == 0) continue;
        const direction = line[0];
        const rotation = try std.fmt.parseInt(i64, line[1..], 10);

        switch (direction) {
            'L' => {
                if (position == 0) {
                    // if we are at 0 and rotate > 99 we passed 0. 
                    zero_count += @divFloor(rotation, 100);
                } else if (rotation >= position) {
                    // passed 0, calculate how many 00:08:53
                    zero_count += 1 + @divFloor(rotation - position, 100);
                }
                position = @mod(position - rotation, 100);
            },
            'R' => {
                // calculate how many times we pass 0 
                zero_count += @divFloor(position + rotation, 100);
                position = @mod(position + rotation, 100);
            },
            else => {
                std.debug.print("Panic: direction could not be determined", .{});
            }
        }
    }

    std.debug.print("{d}\n", .{zero_count});
}
