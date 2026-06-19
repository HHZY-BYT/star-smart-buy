package com.star.smartbuy.controller;

import com.star.smartbuy.annotation.OperLog;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.Notice;
import com.star.smartbuy.mapper.NoticeMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 管理员 - 公告管理控制器
 */
@RestController
@RequestMapping("/admin/notice")
public class AdminNoticeController {

    @Resource
    private NoticeMapper noticeMapper;

    /**
     * 获取公告列表（管理端，含隐藏的）
     */
    @GetMapping
    public Result<List<Notice>> list() {
        List<Notice> notices = noticeMapper.selectList(
            new LambdaQueryWrapper<Notice>().orderByDesc(Notice::getId)
        );
        return Result.success(notices);
    }

    /**
     * 新增公告
     */
    @PostMapping
    @OperLog(module = "NOTICE", type = "CREATE", description = "新增公告")
    public Result<Void> add(@RequestBody Notice notice) {
        if (notice.getTitle() == null || notice.getTitle().isEmpty()) {
            return Result.error("请输入公告标题");
        }
        notice.setCreatedAt(LocalDateTime.now());
        notice.setUpdatedAt(LocalDateTime.now());
        if (notice.getStatus() == null) notice.setStatus(1);
        noticeMapper.insert(notice);
        return Result.success();
    }

    /**
     * 更新公告
     */
    @PutMapping
    @OperLog(module = "NOTICE", type = "UPDATE", description = "更新公告")
    public Result<Void> update(@RequestBody Notice notice) {
        if (notice.getId() == null) {
            return Result.error("缺少公告ID");
        }
        notice.setUpdatedAt(LocalDateTime.now());
        noticeMapper.updateById(notice);
        return Result.success();
    }

    /**
     * 删除公告
     */
    @DeleteMapping("/{id}")
    @OperLog(module = "NOTICE", type = "DELETE", description = "删除公告")
    public Result<Void> delete(@PathVariable Long id) {
        noticeMapper.deleteById(id);
        return Result.success();
    }
}
