package com.star.smartbuy.controller;

import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.Banner;
import com.star.smartbuy.entity.Notice;
import com.star.smartbuy.mapper.BannerMapper;
import com.star.smartbuy.mapper.NoticeMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 首页数据接口
 * <p>
 * 提供轮播图和公告查询，面向小程序用户，无需登录即可访问。
 * </p>
 *
 * @author StarSmart Buy Team
 * @since 1.0
 */
@RestController
@RequestMapping("/home")
public class HomeController {

    @Resource
    private BannerMapper bannerMapper;

    @Resource
    private NoticeMapper noticeMapper;

    /**
     * 获取首页数据（轮播图 + 公告）
     */
    @GetMapping
    public Result<Map<String, Object>> getHomeData() {
        // 获取显示状态的轮播图，按排序升序
        List<Banner> banners = bannerMapper.selectList(
            new LambdaQueryWrapper<Banner>()
                .eq(Banner::getStatus, 1)
                .orderByAsc(Banner::getSort)
                .orderByDesc(Banner::getId)
        );

        // 获取显示状态的公告，按时间降序
        List<Notice> notices = noticeMapper.selectList(
            new LambdaQueryWrapper<Notice>()
                .eq(Notice::getStatus, 1)
                .orderByDesc(Notice::getId)
        );

        Map<String, Object> data = new HashMap<>();
        data.put("banners", banners);
        data.put("notices", notices);
        return Result.success(data);
    }

    /**
     * 单独获取轮播图（显示状态）
     */
    @GetMapping("/banners")
    public Result<List<Banner>> getBanners() {
        List<Banner> banners = bannerMapper.selectList(
            new LambdaQueryWrapper<Banner>()
                .eq(Banner::getStatus, 1)
                .orderByAsc(Banner::getSort)
                .orderByDesc(Banner::getId)
        );
        return Result.success(banners);
    }

    /**
     * 单独获取公告列表（显示状态）
     */
    @GetMapping("/notices")
    public Result<List<Notice>> getNotices() {
        List<Notice> notices = noticeMapper.selectList(
            new LambdaQueryWrapper<Notice>()
                .eq(Notice::getStatus, 1)
                .orderByDesc(Notice::getId)
        );
        return Result.success(notices);
    }
}
