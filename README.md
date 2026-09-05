# Chirpy Starter

[![Gem Version](https://img.shields.io/gem/v/jekyll-theme-chirpy)][gem]&nbsp;
[![GitHub license](https://img.shields.io/github/license/cotes2020/chirpy-starter.svg?color=blue)][mit]

A minimal, ready-to-use template for creating a blog with the [**Chirpy**][chirpy] Jekyll theme. Get up and running in minutes with all critical files pre-configured.

## Why This Starter Exists

When installing Chirpy through [RubyGems.org][gem], Jekyll can only read a subset of theme files (`_data`, `_layouts`, `_includes`, `_sass`, `assets`) and limited `_config.yml` options from the gem. As a result, users cannot enjoy the full out-of-the-box experience that Chirpy offers.

To unlock all features, the following files must be present in your Jekyll site:

```shell
.
├── _config.yml
├── _plugins
├── _tabs
└── index.html
```

This starter bundles those files from the latest **Chirpy** release along with a [CD][CD] workflow, so you can start writing immediately.

## Usage

Check out the [theme's docs](https://github.com/cotes2020/jekyll-theme-chirpy/wiki).

## 发布新文章（Maokichan 个人使用说明）

### 方式一：用脚本（推荐）

只需给标题，其余交给脚本，然后直接写正文：

```powershell
# 最小用法
.\new-post.ps1 "文章标题"

# 带分类、标签、摘要
.\new-post.ps1 "文章标题" -Categories "随笔","笔记" -Tags "hello" -Description "一句话摘要"

# 带封面图（本地图片自动复制进 assets/img/posts/）
.\new-post.ps1 "文章标题" -Image "D:\pics\cover.png"

# 封面图已是站点路径或网络 URL（原样引用，不复制）
.\new-post.ps1 "文章标题" -Image "/assets/img/posts/cover.png"

# 手动指定日期（默认当前时间）
.\new-post.ps1 "文章标题" -Date "2026-09-05 10:00:00 +0800"
```

脚本会自动完成：

- 在 `_posts/` 生成 `YYYY-MM-DD-slug.md`（slug 自动由标题转换，中文保留）
- 填好 front matter（标题、日期、分类、标签、摘要、封面图）
- 自动用编辑器打开文件，只写正文即可

发布流程（写完正文后）：

```powershell
git add .
git commit -m "feat: 新文章《xxx》"
git push
```

push 后 GitHub Actions 会自动构建部署，几分钟后站点即可访问。

### 方式二：手动创建（不依赖脚本）

在 `_posts/` 下手动建文件，命名 `YYYY-MM-DD-标题.md`，front matter 格式：

```yaml
---
title: 文章标题
date: 2026-09-05 10:00:00 +0800
categories: [分类]
tags: [标签]
description: 摘要
image:
  path: /assets/img/posts/cover.png
  alt: 封面说明
---

正文内容
```

### 注意事项

- 文件名必须有 `YYYY-MM-DD-` 日期前缀，否则 Jekyll 不会渲染。
- 封面图放 `assets/img/posts/` 下，front matter 里用 `/assets/img/posts/文件名` 引用。
- Chirpy 额外语法（可选）：`> 提示文字` 下一行加 `{: .prompt-info }` 可渲染提示框（还有 `.prompt-tip` / `.prompt-warning` / `.prompt-danger`）。
- RSS 已移除，feed.xml 为空文件，无需处理。

## Contributing

This repository is automatically updated with new releases from the theme repository. If you encounter any issues or want to contribute to its improvement, please visit the [theme repository][chirpy] to provide feedback.

## License

This work is published under [MIT][mit] License.

[gem]: https://rubygems.org/gems/jekyll-theme-chirpy
[chirpy]: https://github.com/cotes2020/jekyll-theme-chirpy/
[CD]: https://en.wikipedia.org/wiki/Continuous_deployment
[mit]: https://github.com/cotes2020/chirpy-starter/blob/master/LICENSE
