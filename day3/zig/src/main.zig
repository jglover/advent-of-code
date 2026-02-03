const std = @import("std");

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);
    var line_no: usize = 0;
    var total: usize = 0;

    while (try reader.interface.takeDelimiter('\n')) |line| {
        line_no += 1;

        if (line.len == 0) continue;

        var max_joltage: usize = 0;

        // Try all pairs of batteries (i, j) where i < j
        for (line, 0..) |char, i| {
            const first_digit = std.fmt.charToDigit(char, 10) catch continue;

            // Inner loop: try each battery after position i
            for (line[i + 1 ..]) |inner_char| {
                const second_digit = std.fmt.charToDigit(inner_char, 10) catch continue;

                // Calculate joltage from these two batteries
                const joltage = first_digit * 10 + second_digit;

                // Track maximum
                if (joltage > max_joltage) {
                    max_joltage = joltage;
                }
            }
        }

        total += max_joltage;

        std.debug.print("Line {d}: {s} -> max joltage: {d}\n", .{ line_no, line, max_joltage });
    }

    std.debug.print("\nTotal output joltage: {d}\n", .{total});
}
