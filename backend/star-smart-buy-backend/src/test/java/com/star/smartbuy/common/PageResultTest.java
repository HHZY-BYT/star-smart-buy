package com.star.smartbuy.common;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * PageResult 分页结果测试
 */
class PageResultTest {

    @Test
    void testConstruction() {
        var records = List.of("a", "b", "c");
        PageResult<String> pr = new PageResult<>(100L, 1, 10, records);

        assertEquals(100L, pr.getTotal());
        assertEquals(1, pr.getPage());
        assertEquals(10, pr.getSize());
        assertEquals(3, pr.getRecords().size());
    }

    @Test
    void testStaticFactory() {
        var records = List.of("x", "y");
        PageResult<String> pr = PageResult.of(2L, 1, 20, records);

        assertEquals(2L, pr.getTotal());
        assertEquals(20, pr.getSize());
        assertSame(records, pr.getRecords());
    }
}
