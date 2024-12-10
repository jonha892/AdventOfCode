from collections import deque

def is_in_bounds(x, y, topographic_map):
    return x >= 0 and y >= 0 and y < len(topographic_map) and x < len(topographic_map[y])

def p1(topographic_map):
    starting_positions = []
    for y, row in enumerate(topographic_map):
        for x, val in enumerate(row):
            if val == 0:
                starting_positions.append((x, y))
    
    s = 0
    total_finished_paths = 0
    for (x_start, y_start) in starting_positions:
        print(f"starting at {x_start}, {y_start}")
        path = []
        finished_paths = set()
        path.append((x_start, y_start))
        current_height = 0

        # dequeue
        queue = deque()
        queue.append((path, current_height))

        while len(queue) > 0:
            path, current_height = queue.popleft()
            #print(f"current path: {path}")

            options = [(0, 1), (1, 0), (0, -1), (-1, 0)]
            last_location = path[-1]
            for (offset_x, offset_y) in options:
                x = last_location[0] + offset_x
                y = last_location[1] + offset_y
                if not is_in_bounds(x, y, topographic_map):
                    continue
                if (x, y) in path:
                    continue

                new_height = topographic_map[y][x]
                if new_height == -1:
                    continue

                if new_height == 9 and current_height == 8:
                    finished_path = path.copy() + [(x, y)]
                    #print(f"finished path: {finished_path}")
                    finished_paths.add(tuple(finished_path))
                    continue
                elif new_height == current_height + 1:
                    new_path = path.copy() + [(x, y)]
                    queue.append((new_path, new_height))
        print(f"start has {len(finished_paths)} paths")
        total_finished_paths += len(finished_paths)
        unique_end_positions = set([x[-1] for x in finished_paths])
        print(f"unique end positions: {len(unique_end_positions)}")
        s += len(unique_end_positions)
    print("unique_ends", s)
    print("total_finished_paths", total_finished_paths)
if __name__ == "__main__":
    fn = 'inputs/day10_test.txt'
    fn = 'inputs/day10.txt'

    with open(fn) as f:
        topographic_map = [[int(x) if x != '.' else -1 for x in list(line.strip())] for line in f.readlines()]

    print(topographic_map)
    p1(topographic_map)