# Skills Repository Notes

本文总结一个 agent skills 仓库可以采用的通用架构和设计特点。目标是形成可维护、可安装、可按需扩展的 skill 组织方式。

## 总体定位

skills 仓库用于沉淀 agent 在特定任务中的工作方法、项目约定、领域知识和可复用工具。它不是通用 SDK，也不是应用框架，而是把隐性的操作经验写成明确规则，让 agent 在相关任务中稳定复用。

好的 skill 仓库通常偏实用、强边界、强触发条件。它不需要覆盖所有可能做法，而应该明确默认路径、推荐模式、禁用做法和何时切换到其他 skill。

## 仓库结构

推荐结构如下：

```text
README.md
scripts/
  package-skills.sh
skills/
  <skill-name>/
    SKILL.md          # agent 入口，包含触发描述和核心规则
    agents/
      openai.yaml     # 可选，UI 展示元数据
    references/       # 按需读取的长参考材料
    resources/        # 按需读取的短参考材料
    scripts/          # 可执行 helper，处理确定性任务
    assets/           # 模板、图片、字体、示例文件等输出素材
    evals/            # 可选，评测样例
```

其中 `SKILL.md` 是核心入口。它通常包含 YAML frontmatter：

```md
---
name: skill-name
description: What this skill does. Use when ...
---
```

`name` 和 `description` 用于让 agent 判断什么时候加载这个 skill。`description` 应写成精确触发器，明确列出任务类型、关键词、文件类型和适用场景。

## Skill 切分方式

skill 应按 agent 的实际工作场景拆分，而不是按大而全的主题堆在一起。

合适的拆分方式：

- 语法类 skill：处理某种文件格式或语言语法。
- 集成类 skill：处理框架、服务、API、工具链之间的连接。
- 工作流类 skill：处理发布、诊断、代码审查、迁移、测试等流程。
- 领域类 skill：处理业务模型、术语、策略和组织内约定。
- 风格类 skill：处理写作、设计、代码风格、交互规范。

每个 skill 只解决一个明确场景。多个 skill 可以互相路由，例如语法 skill 可以提示：需要服务集成时改用 HTTP skill；需要交互行为时改用 UI interaction skill。

## 渐进披露

skill 仓库应使用 progressive disclosure，避免一次性把所有资料塞进上下文。

推荐三层结构：

1. `description`：只负责触发判断。
2. `SKILL.md`：放核心流程、快路径、硬规则和常用示例。
3. `references/`、`resources/`、`assets/`：任务需要时再读取或使用。

`SKILL.md` 里应该明确说明什么时候读哪个参考文件。例如：

- 修改复杂配置时读 `references/config.md`
- 做生产发布时读 `references/release.md`
- 需要确定性操作时运行 `scripts/helper.sh`
- 生成输出文件时复制或修改 `assets/template.*`

这样可以让 skill 保持轻量，同时保留足够深的背景材料。

## 文档风格

面向 agent 的 skill 文档应直接、具体、可执行。

建议：

- 直接给规则，不写长篇理念。
- 用 `Do` / `Don't`、`Hard Rules`、`When to use` 表达边界。
- 给真实代码片段或命令片段。
- 明确默认选择和例外条件。
- 明确失败时的诊断路径。
- 明确何时升级到其他 skill。
- 把项目偏好写成规则，而不是散落在聊天记录里。

agent 不需要泛泛介绍，它需要可执行的约束、判断标准和下一步动作。

## 元数据

Codex 识别 skill 的核心信息来自 `SKILL.md` frontmatter：

- `name`：skill 名称
- `description`：skill 能力和触发条件

可以额外提供 `agents/openai.yaml` 作为 UI 展示元数据，例如展示名称、短描述、默认提示等。

如果仓库还需要目录索引、版本、作者、摘要、引用来源，也可以增加自定义元数据文件。但这类文件应视为仓库自己的发布/索引信息，不应替代 `SKILL.md` frontmatter。

## 打包策略

如果需要发布 zip 包，建议打包完整 skill 目录，而不是只打包 `SKILL.md`。

应该包含：

- `SKILL.md`
- `agents/`
- `references/`
- `resources/`
- `scripts/`
- `assets/`
- 其他被 `SKILL.md` 明确引用的文件

应该排除：

- 已生成的 zip 文件
- 临时目录
- 缓存文件
- 与 skill 功能无关的开发产物

如果只打包入口文件，安装后可能出现 `SKILL.md` 引用了参考资料，但实际文件不存在的问题。这会破坏渐进披露设计。

## 可借鉴原则

- 每个 skill 只解决一个明确场景。
- `description` 写成精确触发规则。
- `SKILL.md` 保持短而可执行。
- 大段背景知识拆到 `references/`。
- 短而常用的补充材料放到 `resources/`。
- 可重复、易错、确定性的操作放进 `scripts/`。
- 输出素材、模板、字体、图片放进 `assets/`。
- skill 之间明确路由，不做巨型万能 skill。
- 发布包应包含被入口文件引用的全部资源。

## 主要风险

- skill 过大：触发后占用太多上下文。
- skill 过泛：触发条件模糊，容易误用。
- skill 过碎：任务需要同时加载太多 skill。
- 参考文件缺失：入口文档引用了不存在的资源。
- 规则过时：工具链或项目约定变化后未同步更新。
- 自定义元数据过多：看似完整，实际不被 agent 使用。

## 本仓库建议

本仓库可以从小结构开始：

```text
skills/
  <skill-name>/
    SKILL.md
    agents/
      openai.yaml
    references/
    scripts/
    assets/
```

建议流程：

1. 先写一个高频任务的 `SKILL.md`。
2. 把触发条件写清楚。
3. 把核心流程压到入口文件。
4. 把长背景资料拆到 `references/`。
5. 把确定性操作沉淀成脚本。
6. 再补打包脚本和评测样例。
