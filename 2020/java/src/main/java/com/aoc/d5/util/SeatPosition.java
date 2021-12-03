package com.aoc.d5.util;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Data
public class SeatPosition {
    private int row;
    private int column;

    public SeatPosition(int row, int column) {
        this.row = row;
        this.column = column;
    }

    public int id() {
        return row * 8 + column;
    }
}