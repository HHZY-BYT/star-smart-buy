package com.star.smartbuy.controller;

import com.star.smartbuy.annotation.OperLog;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.Banner;
import com.star.smartbuy.mapper.BannerMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 管理员 - 轮播图管理控制器
 */
@RestController
@RequestMapping("/admin/banner")
public class AdminBannerController {

    @Resource
    private BannerMapper bannerMapper;

    /**
     * 获取轮播图列表（管理端，含隐藏的）
     */
    @GetMapping
    public Result<List<Banner>> list() {
        List<Banner> banners = bannerMapper.selectList(
            new LambdaQueryWrapper<Banner>().orderByAsc(Banner::getSort).orderByDesc(Banner::getId)
        );
        return Result.success(banners);
    }

    /**
     * 新增轮播图
     */
    @PostMapping
    @OperLog(module = "BANNER", type = "CREATE", description = "新增轮播图")
    public Result<Void> add(@RequestBody Banner banner) {
        if (banner.getImage() == null || banner.getImage().isEmpty()) {
            return Result.error("请上传轮播图图片");
        }
        banner.setCreatedAt(LocalDateTime.now());
        banner.setUpdatedAt(LocalDateTime.now());
        if (banner.getStatus() == null) banner.setStatus(1);
        if (banner.getSort() == null) banner.setSort(0);
        bannerMapper.insert(banner);
        return Result.success();
    }

    /**
     * 更新轮播图
     */
    @PutMapping
    @OperLog(module = "BANNER", type = "UPDATE", description = "更新轮播图")
    public Result<Void> update(@RequestBody Banner banner) {
        if (banner.getId() == null) {
            return Result.error("缺少轮播图ID");
        }
        banner.setUpdatedAt(LocalDateTime.now());
        bannerMapper.updateById(banner);
        return Result.success();
    }

    /**
     * 删除轮播图
     */
    @DeleteMapping("/{id}")
    @OperLog(module = "BANNER", type = "DELETE", description = "删除轮播图")
    public Result<Void> delete(@PathVariable Long id) {
        bannerMapper.deleteById(id);
        return Result.success();
    }
}
