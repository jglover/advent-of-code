const std = @import("std");

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);
    var line_no: usize = 0;
    var total: u64 = 0;

    while (try reader.interface.takeDelimiter('\n')) |line| {
        line_no += 1;

        if (line.len == 0) continue;

        // this is important because we need to constrain the max index 
        const num_batteries = 12;
        var selected_digits: [num_batteries]u8 = undefined;
        var start_idx: usize = 0;

        // for each position, pick the largest digit while ensuring we have enough remaining digits
        for (0..num_batteries) |i| {
            // we need 12 digits from the line, in order, but we need to make sure we've got enough digits.
            const end_idx = line.len - num_batteries + i;

            var max_digit: u8 = 0;
            var max_idx: usize = start_idx;

            for (start_idx..end_idx + 1) |j| {
                const digit = std.fmt.charToDigit(line[j], 10) catch continue;
                // find the max digit for this line,
                if (digit > max_digit) {
                    max_digit = digit;
                    max_idx = j;
                }
            }

            selected_digits[i] = max_digit;
            start_idx = max_idx + 1;
        }

        // convert selected digits to a number
        var joltage: u64 = 0;
        for (selected_digits) |digit| {
            joltage = joltage * 10 + digit;
        }

        total += joltage;

        std.debug.print("Line {d}: {s} -> joltage: {d}\n", .{ line_no, line, joltage });
    }

    std.debug.print("\nTotal output joltage: {d}\n", .{total});
}
