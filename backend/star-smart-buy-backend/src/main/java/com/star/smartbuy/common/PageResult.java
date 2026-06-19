package com.star.smartbuy.common;

import com.baomidou.mybatisplus.core.metadata.IPage;
import lombok.Data;

import java.util.List;

/**
 * 统一分页结果
 * <p>
 * 替代手动构造 HashMap 的分页返回方式，提供类型安全的分页数据结构。
 * 支持从 MyBatis-Plus 的 IPage 直接构建，也支持手动传参构建。
 * </p>
 *
 * @param <T> 数据记录类型
 */
@Data
public class PageResult<T> {

    /** 总记录数 */
    private long total;
    /** 当前页码 */
    private int page;
    /** 每页大小 */
    private int size;
    /** 数据列表 */
    private List<T> records;

    /** 全参数构造方法 */
    public PageResult(long total, int page, int size, List<T> records) {
        this.total = total;
        this.page = page;
        this.size = size;
        this.records = records;
    }

    /** 从 MyBatis-Plus 的 IPage 构建 */
    public static <T> PageResult<T> of(IPage<T> page) {
        return new PageResult<>(page.getTotal(), (int) page.getCurrent(),
                (int) page.getSize(), page.getRecords());
    }

    /** 手动传参构建（用于非 MP 分页场景） */
    public static <T> PageResult<T> of(long total, int page, int size, List<T> records) {
        return new PageResult<>(total, page, size, records);
    }
}
