#!/bin/bash

# 设置颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

clear
echo -e "${BLUE}"
echo "================================================"
echo "   🔍 团队知识库 - 添加行业调研记录"
echo "================================================"
echo -e "${NC}"

# 检查是否在正确的目录
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ 错误：当前不在知识库目录中！${NC}"
    echo ""
    echo "请按以下步骤操作："
    echo "1. cd到team-memory目录"
    echo "2. 重新运行此脚本"
    echo ""
    exit 1
fi

# 同步最新内容
echo -e "${BLUE}📥 正在同步最新内容...${NC}"
if ! git pull; then
    echo ""
    echo -e "${YELLOW}⚠️  同步失败，但可以继续。如果担心冲突，请先联系技术同事。${NC}"
    echo ""
    read -p "是否继续？(y/n): " continue
    if [ "$continue" != "y" ]; then
        exit 1
    fi
fi

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   第1步：选择调研类型${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo "请选择调研类型："
echo "1) 企业调研"
echo "2) 高校调研"
echo "3) 专家访谈"
echo ""
read -p "请输入选项 (1/2/3): " type_choice

case $type_choice in
    1)
        research_type="企业"
        type_dir="companies"
        ;;
    2)
        research_type="高校"
        type_dir="universities"
        ;;
    3)
        research_type="专家"
        type_dir="experts"
        ;;
    *)
        echo -e "${RED}❌ 无效选项！${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   第2步：填写基本信息${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# 获取调研对象名称
read -p "🏢 ${research_type}名称（如：XX科技/清华大学/张三）: " target_name
if [ -z "$target_name" ]; then
    echo -e "${RED}❌ 名称不能为空！${NC}"
    exit 1
fi

# 获取记录人
read -p "👤 记录人（你的名字）: " author
if [ -z "$author" ]; then
    echo -e "${RED}❌ 记录人不能为空！${NC}"
    exit 1
fi

# 获取位置
read -p "📍 所在城市（如：北京市）: " location

# 获取走访日期
today=$(date +%Y-%m-%d)
read -p "📅 走访日期（默认今天 ${today}）: " visit_date
if [ -z "$visit_date" ]; then
    visit_date=$today
fi

# 获取标签
read -p "🏷️  标签（用逗号分隔，如：robotics,AI）: " tags
if [ -z "$tags" ]; then
    tags="未分类"
fi

# 生成文件名
filename=$(echo "$target_name" | sed 's/\.md$//')
filepath="research/${type_dir}/${filename}.md"

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   第3步：创建文件${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo -e "📄 将创建文件：${GREEN}${filepath}${NC}"
echo ""

# 根据类型创建不同模板
if [ "$type_choice" == "1" ]; then
    # 企业模板
    cat > "$filepath" << EOF
---
name: ${target_name}
type: 企业
industry:
location: ${location}
visit_date: ${visit_date}
status: 已接洽
tags: [${tags}]
---

# ${target_name}

## 基本信息
- **全称**: ${target_name}
- **成立时间**:
- **规模**:
- **官网**:
- **地址**: ${location}

## 联系人
| 姓名 | 职位 | 联系方式 | 备注 |
|------|------|----------|------|
|      |      |          |      |

## 业务范围
- **核心产品**:
- **技术方向**:
- **应用场景**:

## 走访记录

### ${visit_date} 初次走访

**参与人员**: ${author}

**讨论内容**:
-

**关键信息**:
-

**后续计划**:
- [ ]

## 学习收获

（记录从该企业学到的经验、技术、方法等）

## 相关资料
-

---

**记录人**: ${author}
**记录日期**: ${visit_date}
EOF

elif [ "$type_choice" == "2" ]; then
    # 高校模板
    cat > "$filepath" << EOF
---
name: ${target_name}
type: 高校
location: ${location}
visit_date: ${visit_date}
status: 已接洽
tags: [${tags}]
---

# ${target_name}

## 基本信息
- **全称**: ${target_name}
- **类型**: 高校/研究所
- **相关院系**:
- **官网**:
- **地址**: ${location}

## 联系人
| 姓名 | 职位 | 联系方式 | 研究方向 |
|------|------|----------|----------|
|      |      |          |          |

## 研究方向
- **主要研究领域**:
- **技术优势**:
- **相关项目**:

## 走访记录

### ${visit_date} 初次走访

**参与人员**: ${author}

**讨论内容**:
-

**关键信息**:
-

**后续计划**:
- [ ]

## 学习收获

（记录学到的理论、技术、研究方法等）

## 相关资料
-

---

**记录人**: ${author}
**记录日期**: ${visit_date}
EOF

else
    # 专家模板
    cat > "$filepath" << EOF
---
name: ${target_name}
type: 专家
affiliation:
expertise:
visit_date: ${visit_date}
tags: [${tags}]
---

# ${target_name}

## 基本信息
- **姓名**: ${target_name}
- **职位**:
- **所属机构**:
- **专业领域**:
- **联系方式**:

## 专业背景
- **教育背景**:
- **工作经历**:
- **主要成果**:

## 访谈记录

### ${visit_date} 访谈

**参与人员**: ${author}

**讨论主题**:
-

**核心观点**:
-

**建议**:
-

## 学习收获

（记录专家的见解、建议、经验等）

## 相关资料
-

---

**记录人**: ${author}
**记录日期**: ${visit_date}
EOF
fi

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 文件创建失败！${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 文件创建成功！${NC}"
echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   第4步：编辑内容${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo "📝 即将打开编辑器，请："
echo "   1. 补充详细信息"
echo "   2. 填写走访内容"
echo "   3. 保存并关闭编辑器"
echo ""
read -p "按回车打开编辑器..."

# 尝试不同编辑器
if command -v code &> /dev/null; then
    code "$filepath"
elif command -v nano &> /dev/null; then
    nano "$filepath"
elif command -v vim &> /dev/null; then
    vim "$filepath"
else
    open "$filepath"
fi

echo ""
read -p "✅ 确认已完成编辑？(y/n): " edited
if [ "$edited" != "y" ]; then
    echo ""
    echo -e "${YELLOW}⚠️  取消操作。文件已保存在：${filepath}${NC}"
    echo "   你可以稍后手动编辑并提交。"
    exit 0
fi

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   第5步：提交到团队库${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

echo "📤 正在准备提交..."
git add .

echo "📝 正在创建提交记录..."
if ! git commit -m "feat: 添加「${target_name}」${research_type}调研记录 by @${author}"; then
    echo ""
    echo -e "${YELLOW}⚠️  提交失败！可能是没有改动需要提交。${NC}"
    exit 1
fi

echo "🚀 正在上传到GitHub..."
if ! git push; then
    echo ""
    echo -e "${RED}❌ 上传失败！${NC}"
    echo ""
    echo "可能的原因："
    echo "1. 网络问题 - 请检查网络连接"
    echo "2. 需要先pull - 有同事在你之前提交了内容"
    echo "3. 权限问题 - 请确认你有仓库访问权限"
    echo ""
    echo "尝试自动修复..."
    if ! git pull --rebase; then
        echo ""
        echo -e "${RED}⚠️  自动修复失败，请联系技术同事协助。${NC}"
        exit 1
    fi
    echo "正在重新上传..."
    if ! git push; then
        echo -e "${RED}❌ 仍然失败，请联系技术同事。${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}   🎉 成功！${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo "✅ 调研记录已成功分享到团队知识库！"
echo ""
echo "📊 文件位置：${filepath}"
echo "🌐 网站将在1-2分钟后自动更新"
echo "🔗 访问：https://eai-tech-liauto.github.io/team-memory/"
echo ""
echo "感谢你的贡献！💪"
echo ""
