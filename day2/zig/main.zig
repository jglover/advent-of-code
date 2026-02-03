const std = @import("std");

fn isInvalidId(num: u64) bool {
    // Convert number to string
    var buf: [32]u8 = undefined;
    const str = std.fmt.bufPrint(&buf, "{d}", .{num}) catch return false;

    // Length must be even to be repeated twice
    if (str.len % 2 != 0) return false;
    if (str.len == 0) return false;

    // Check if first half equals second half
    const half = str.len / 2;
    const first_half = str[0..half];
    const second_half = str[half..];

    return std.mem.eql(u8, first_half, second_half);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read input file
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(content);

    var sum: u64 = 0;

    // Parse ranges (comma-separated)
    var range_iter = std.mem.tokenizeAny(u8, content, ",\n\r");
    while (range_iter.next()) |range_str| {
        const trimmed = std.mem.trim(u8, range_str, " \t\r\n");
        if (trimmed.len == 0) continue;

        // Parse "start-end"
        var dash_iter = std.mem.splitScalar(u8, trimmed, '-');
        const start_str = dash_iter.next() orelse continue;
        const end_str = dash_iter.next() orelse continue;

        const start = try std.fmt.parseInt(u64, start_str, 10);
        const end = try std.fmt.parseInt(u64, end_str, 10);

        // Check each number in range
        var num = start;
        while (num <= end) : (num += 1) {
            if (isInvalidId(num)) {
                sum += num;
            }
        }
    }

    std.debug.print("Sum of invalid IDs: {d}\n", .{sum});
}
