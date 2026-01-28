# 📋 架构决策记录 (ADR)

## 什么是ADR？

Architecture Decision Records（架构决策记录）是记录项目中重要技术决策的文档。

## 为什么需要ADR？

- **追溯性**: 未来可以了解"为什么当时这样决定"
- **知识传承**: 新成员可以快速了解关键决策
- **避免重复讨论**: 已经决定的事情不用反复争论
- **决策透明**: 团队所有人都能看到决策过程

## 记录格式

每个决策记录一个文件，命名格式：`YYYYMMDD-决策标题.md`

### 模板

```markdown
# ADR-001: 选择NVIDIA Orin作为计算平台

## 状态
已采纳 | 2026-01-20

## 背景
家用人形机器人需要强大的AI计算能力，同时要控制成本和功耗...

## 决策
选择NVIDIA Jetson Orin作为主控计算平台

## 理由
1. AI性能强大：275 TOPS
2. 功耗可控：<30W
3. 生态成熟：有大量开发资源
4. 成本合理：约$500

## 后果
### 正面
- 可以运行复杂的AI模型
- 开发效率高

### 负面
- 依赖NVIDIA生态
- 需要专门的散热设计

## 备选方案
1. Intel NUC: 通用性强但AI性能不足
2. 自研ASIC: 性能最优但成本和周期不可控

## 参考资料
- [NVIDIA Orin产品页](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-orin/)
- 内部技术评估文档: `./技术方案/计算平台选型.md`
```

## 当前决策记录

目前还没有正式的ADR记录。

**建议添加的决策**：
- 计算平台选型（Orin vs 其他）
- 通信架构（ROS2 vs 自研）
- 控制器架构（集中式 vs 分布式）
- 视觉方案（RGB-D vs LiDAR + Camera）
- 电池技术选择
- 操作系统选择（Ubuntu vs 定制Linux）

## 如何添加新的决策记录？

1. 在 `decisions/` 目录创建新文件
2. 使用命名格式：`YYYYMMDD-标题.md`
3. 按照上面的模板填写内容
4. 提交到Git仓库

## 相关资源

- [什么是ADR？](https://adr.github.io/)
- [ADR最佳实践](https://github.com/joelparkerhenderson/architecture-decision-record)
- 团队技术方案文档：`./topics/技术方案/`

---

**提示**: 重大技术决策前，先写ADR征求团队意见，然后记录最终决定。
