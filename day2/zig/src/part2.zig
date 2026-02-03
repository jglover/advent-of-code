const std = @import("std");

fn isInvalidId(num: u64) bool {
    // Convert number to string
    var buf: [32]u8 = undefined;
    const str = std.fmt.bufPrint(&buf, "{d}", .{num}) catch return false;

    if (str.len < 2) return false;

    // we need at least two repetitions so length/2 is our max, try all possibilities.
    var pattern_len: usize = 1;
    while (pattern_len <= str.len / 2) : (pattern_len += 1) {
        // check if total length is divisible by pattern length
        if (str.len % pattern_len != 0) continue;

        // check if the string is made up of the pattern repeated
        const pattern = str[0..pattern_len];
        var is_repeated = true;

        var i: usize = pattern_len;
        while (i < str.len) : (i += pattern_len) {
            const segment = str[i .. i + pattern_len];
            if (!std.mem.eql(u8, pattern, segment)) {
                is_repeated = false;
                break;
            }
        }

        if (is_repeated) {
            return true;
        }
    }

    return false;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(content);

    var sum: u64 = 0;

    // parse ranges (ranges are comma seoarated)
    var range_iter = std.mem.tokenizeAny(u8, content, ",\n\r");
    while (range_iter.next()) |range_str| {
        const trimmed = std.mem.trim(u8, range_str, " \t\r\n");
        if (trimmed.len == 0) continue;

        // parse the numbers between start-end
        var dash_iter = std.mem.splitScalar(u8, trimmed, '-');
        const start_str = dash_iter.next() orelse continue;
        const end_str = dash_iter.next() orelse continue;

        const start = try std.fmt.parseInt(u64, start_str, 10);
        const end = try std.fmt.parseInt(u64, end_str, 10);

        // check if each id is valid
        var num = start;
        while (num <= end) : (num += 1) {
            if (isInvalidId(num)) {
                sum += num;
            }
        }
    }

    std.debug.print("Sum of invalid IDs: {d}\n", .{sum});
}
