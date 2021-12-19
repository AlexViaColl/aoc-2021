const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var args = std.process.args();
    _ = args.skip();
    while (args.next(allocator)) |arg| {
        const path = arg catch "input.txt";

        const file = try std.fs.cwd().openFile(path, .{ .read = true });
        defer file.close();

        var line_buffer = try std.ArrayList(u8).initCapacity(allocator, 300);
        defer line_buffer.deinit();

        file.reader().readUntilDelimiterArrayList(&line_buffer, '\n', std.math.maxInt(usize)) catch |err| switch (err) {
            error.EndOfStream => {},
            else => |e| return e,
        };

        var iter = std.mem.split(line_buffer.items, "target area: ");
        const tmp = iter.next();

        const coords = iter.next();

        iter = std.mem.split(coords.?, ", ");
        const xrange = iter.next().?[2..];
        const yrange = iter.next().?[2..];

        iter = std.mem.split(xrange, "..");
        const xtarget_min = std.fmt.parseInt(i32, iter.next().?, 10);
        const xtarget_max = std.fmt.parseInt(i32, iter.next().?, 10);

        iter = std.mem.split(yrange, "..");
        const ytarget_min = std.fmt.parseInt(i32, iter.next().?, 10);
        const ytarget_max = std.fmt.parseInt(i32, iter.next().?, 10);

        const xtarget = Range {
            .min = xtarget_min catch 0,
            .max = xtarget_max catch 0,
        };
        const ytarget = Range {
            .min = ytarget_min catch 0,
            .max = ytarget_max catch 0,
        };

        part1(xtarget, ytarget);
        part2(xtarget, ytarget);
    }
}

fn part1(xtarget: Range, ytarget: Range) void {
    var ymax: i32 = 0;
    var x: i32 = 1;
    while (x != xtarget.max + 1) {
        var y: i32 = 0;
        while (y != -ytarget.min) {
            if (reaches_target(Vec2 {.x = x, .y = y}, xtarget, ytarget)) {
                const new_max = get_max_y(Vec2 {.x = x, .y = y}, xtarget, ytarget);
                if (new_max > ymax) {
                    ymax = new_max;
                }
            }

            y += 1;
        }
        x += 1;
    }

    std.debug.print("Part 1: {}\n", .{ymax});
}

fn part2(xtarget: Range, ytarget: Range) void {
    var count: u64 = 0;
    var x: i32 = 1;

    while (x != xtarget.max + 1) {
        var y: i32 = ytarget.min;
        while (y != -ytarget.min) {
            if (reaches_target(Vec2 {.x = x, .y = y}, xtarget, ytarget)) {
                count += 1;
            }

            if (ytarget.min < 0) y += 1 else y += -1;
        }
        x += 1;
    }

    std.debug.print("Part 2: {}\n", .{count});
}

const Range = struct {
    min: i32,
    max: i32,
};

const Vec2 = struct {
    x: i32,
    y: i32,
};

fn get_max_y(vel_in: Vec2, xtarget: Range, ytarget: Range) i32 {
    var max_y: i32 = 0;
    var pos = Vec2 {.x = 0, .y = 0};
    var vel = vel_in;
    while (true) {
        if (pos.x > xtarget.max and pos.y < ytarget.max) {
            break;
        }
        if (pos.x >= xtarget.min and pos.x <= xtarget.max and pos.y >= ytarget.min and pos.y <= ytarget.max) {
            break;
        }

        if (pos.y > max_y) {
            max_y = pos.y;
        }

        const new_pos_vel = step(pos, vel);
        pos = new_pos_vel[0];
        vel = new_pos_vel[1];
    }
    return max_y;
}

fn reaches_target(vel_in: Vec2, xtarget: Range, ytarget: Range) bool {
    var pos = Vec2 {.x = 0, .y = 0};
    var vel = vel_in;
    while (true) {
        if (pos.x > xtarget.max) {
            break;
        }
        if (pos.y < ytarget.min) {
            break;
        }
        if (pos.x >= xtarget.min and pos.x <= xtarget.max and pos.y >= ytarget.min and pos.y <= ytarget.max) {
            break;
        }

        const new_pos_vel = step(pos, vel);
        pos = new_pos_vel[0];
        vel = new_pos_vel[1];
    }

    return pos.x >= xtarget.min and pos.x <= xtarget.max and pos.y >= ytarget.min and pos.y <= ytarget.max;
}

fn step(pos_in: Vec2, vel_in: Vec2) [2]Vec2 {
    var pos = pos_in;
    var vel = vel_in;
    pos.x += vel.x;
    pos.y += vel.y;
    if (vel.x > 0) {
        vel.x += -1;
    } else if (vel.x < 0) {
        vel.x += 1;
    }
    vel.y -= 1;
    return .{pos, vel};
}
