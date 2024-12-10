import tqdm

def p1(disk_map):
    print(disk_map)
    total_len = sum(disk_map)
    print(total_len, len(disk_map))

    # init layout
    disk_layout = []#['.'] * total_len
    mode = "file"
    id_ = 0
    for idx, v in enumerate(disk_map):
        for _ in range(v):
            if mode == "file":
                disk_layout.append(id_)
            else:
                disk_layout.append('.')
        mode = "free" if mode == "file" else "file"
        if idx % 2 == 0:
            id_ += 1
        #print(disk_layout)

    # compress
    for idx in range(len(disk_layout) -1, 0, -1):
        id_ = disk_layout[idx]
        if id_ != '.':
            try:
                first_index = disk_layout.index('.')
                if first_index < idx:
                    disk_layout[first_index] = id_
                    disk_layout[idx] = '.'
            except ValueError:
                continue
        #print(disk_layout)
    
    #cals checksum
    checksum = 0
    for idx, v in enumerate(disk_layout):
        if v == '.':
            continue
        checksum += idx * v
    print(checksum)

def compress(disk_layout, free_space, current_file_id, current_file_start, current_file_len):
    isPrint = current_file_id == 5460
    if isPrint:
        pass
        #print(f"free_space: {free_space}")
    for i, f in enumerate(free_space):
        if isPrint:
            pass
            #print(f, current_file_start, current_file_len)
        if f['len'] >= current_file_len:
            if f['start'] > current_file_start:
                if isPrint:
                    print("no shift")
                return disk_layout, free_space
            # remove old file from current_file_start to current_file_start + current_file_len replace with '.'
            if isPrint:
                # print current layout around current_file_start and free space
                print(f"BEFORE: free space {disk_layout[f['start']-3:f['end']+3]}")
                print(f"BEFORE: file       {disk_layout[current_file_start-3:current_file_start+current_file_len+3]}")
                print(f"BEFORE: len {len(disk_layout)}")

            for idx in range(current_file_start, current_file_start + current_file_len):
                disk_layout[idx] = '.'
            
            # insert file id to free space
            for idx in range(f['start'], f['start'] + current_file_len):
                disk_layout[idx] = current_file_id
            if isPrint:
                # print current layout around current_file_start and free space
                print(f"AFTER : free space {disk_layout[f['start']-3:f['end']+3]}")
                print(f"AFTER : file       {disk_layout[current_file_start-3:current_file_start+current_file_len+3]}")
                print(f"AFTER : len {len(disk_layout)}")

            # update free space
            new_free_len = f['len'] - current_file_len


            #import os
            #os.exit()
            if new_free_len == 0:
                del free_space[i]
                return disk_layout, free_space
            free_space[i] = {
                'start': f['start'] + current_file_len,
                'end': f['end'],
                'len': new_free_len
            }
            return disk_layout, free_space
    return disk_layout, free_space

def p2(disk_map):
    print(disk_map)
    total_len = sum(disk_map)
    print(total_len, len(disk_map))

    # init layout
    disk_layout = []#['.'] * total_len
    mode = "file"
    id_ = 0
    for idx, v in enumerate(disk_map):
        for _ in range(v):
            if mode == "file":
                disk_layout.append(id_)
            else:
                disk_layout.append('.')
        mode = "free" if mode == "file" else "file"
        if idx % 2 == 0:
            id_ += 1
        #print(disk_layout)

    # free space
    # search for all free space defined by start and endindex (inclusive), and length
    free_space = []
    curr_start = -1
    for idx, v in enumerate(disk_layout):
        if v == '.' and curr_start == -1:
            curr_start = idx
        elif v != '.' and curr_start != -1:
            free_space.append({
                'start': curr_start,
                'end': idx-1,
                'len': idx - curr_start
            })
            curr_start = -1
    #print(disk_layout)
    #print(free_space)


    #disk_layout = ''.join([str(x) for x in disk_layout])

    # compress
    #current_file = []
    current_file_len = 0
    current_file_id = ''
    #print(disk_layout)
    proccessed_files = set()
    for idx in tqdm.tqdm(range(len(disk_layout) -1, 0, -1)):
        id_ = disk_layout[idx]

        if id_ != '.' and current_file_len == 0:
            current_file_id = id_
            #print('new file', current_file_id)
            current_file_len = 1
        elif id_ == current_file_id:
            #print('same file', current_file_id)
            current_file_len += 1
        else:
            current_file_start_idx = idx+1

            if current_file_id == 5460:
                print(f"len: {current_file_len}, start: {current_file_start_idx}")
                

            #print(current_file_id, current_file_start_idx, current_file_len)
            if current_file_id not in proccessed_files:
                disk_layout, free_space = compress(disk_layout, free_space, current_file_id, current_file_start_idx, current_file_len)
                proccessed_files.add(current_file_id)
            if id_ != '.':
                current_file_id = id_
                current_file_len = 1
            else:
                current_file_id = ''
                current_file_len = 0
        #print(disk_layout)
    
    #print(''.join([ str(x) for x in disk_layout]))
    with open('out.txt', 'w') as f:
        for idx, v in enumerate(disk_layout):
            f.write(f"{idx}: {v}\n")

    #calc checksum
    checksum = 0
    for idx, v in enumerate(disk_layout):
        if v == '.':
            continue
        checksum += idx * int(v)
    print(checksum)
    #print(free_space)


if __name__ == '__main__':
    fn = 'inputs/day9_test.txt'
    fn = 'inputs/day9.txt'

    with open (fn) as f:
        lines = f.readlines()
        print(list(lines[0]))
        disk_map = [ int(x) for x in list(lines[0]) ]
    
    #p1(disk_map)
    p2(disk_map)