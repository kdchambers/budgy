const std = @import("std");

const usage_message =
    \\budgy - Manage budget and expenses in the terminal
    \\usage:
    \\  budgy <command>
    \\  commands:
    \\    b[udget] <monthly_budget>
    \\    e[xpense] <value> <name>
    \\    s[tatus]
    \\    reset (delete save file)
    \\
;

var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};

pub fn main() !void {
    const allocator = general_purpose_allocator.allocator();
    defer _ = general_purpose_allocator.deinit();

    var arena_instance = std.heap.ArenaAllocator.init(allocator);
    defer _ = arena_instance.deinit();

    const arena = arena_instance.allocator();
    const args = try std.process.argsAlloc(arena);

    if (args.len < 2) {
        std.debug.print(usage_message, .{});
        return;
    }

    const matches = std.mem.startsWith;
    const command = args[1];

    if (matches(u8, command, "b")) {
        if (args.len != 3) {
            std.log.err("Budget command takes 1 argument. `budget <monthly_budget>`", .{});
            return;
        }
        const monthly_budget = args[2];
        std.log.info("Monthly budget set to {s}", .{monthly_budget});
    } else if (matches(u8, command, "e")) {
        if (args.len != 4) {
            std.log.err("Expense command takes 2 arguments. `expense <value> <name>`", .{});
            return;
        }
        const value = args[2];
        const name = args[3];
        std.log.info("New expense '{s}' of {s}", .{ name, value });
    } else if (matches(u8, command, "s")) {
        std.log.info("Current status", .{});
    } else if (matches(u8, command, "reset")) {
        std.log.info("Resetting file", .{});
    } else {
        std.log.err("Invalid command argument: {s}", .{args[1]});
        std.debug.print("{s}\n", .{usage_message});
    }
}
