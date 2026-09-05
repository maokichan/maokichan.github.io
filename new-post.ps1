<#
.SYNOPSIS
  生成一篇 Chirpy 博客文章：自动取名、填 front matter、复制封面图，然后打开编辑。

.DESCRIPTION
  用法示例：
    # 最小用法：只给标题
    .\new-post.ps1 "我的新文章"

    # 带分类、标签、摘要
    .\new-post.ps1 "我的新文章" -Categories "随笔","笔记" -Tags "hello","test" -Description "一句话摘要"

    # 带封面图：本地图片会被自动复制到 assets/img/posts/ 并写入 front matter
    .\new-post.ps1 "我的新文章" -Image "D:\pics\cover.png"

    # 封面图已是站点路径或网络 URL（不复制，原样引用）
    .\new-post.ps1 "我的新文章" -Image "/assets/img/posts/cover.png"

  生成的文件位于 _posts\YYYY-MM-DD-slug.md，随后自动用默认编辑器打开，直接写正文即可。
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Title,

    # 文件名里的 slug。留空则根据标题自动生成（中文保留）。
    [string]$Slug,

    # 分类，可多个，如 -Categories "随笔","笔记"
    [string[]]$Categories,

    # 标签，可多个，如 -Tags "hello","test"
    [string[]]$Tags,

    # 文章摘要（列表页和 SEO 显示）
    [string]$Description,

    # 封面图：本地文件路径（自动复制进 assets/img/posts/），或站点路径(/...) / 网络 URL（原样引用）
    [string]$Image,

    # 发布日期，默认当前时间，格式：2026-09-05 10:00:00 +0800
    [string]$Date
)

$ErrorActionPreference = "Stop"

$repoRoot = $PSScriptRoot
$postsDir  = Join-Path $repoRoot "_posts"
$imgDir    = Join-Path $repoRoot "assets\img\posts"

if (-not (Test-Path -LiteralPath $postsDir)) {
    throw "未找到 _posts 目录：$postsDir"
}

# ---------- 日期 ----------
if ($Date) {
    $dt = [datetime]::Parse($Date, [System.Globalization.CultureInfo]::InvariantCulture)
}
else {
    $dt = Get-Date
}
$datePart = $dt.ToString("yyyy-MM-dd")
$dateTime = $dt.ToString("yyyy-MM-dd HH:mm:ss +0800")

# ---------- slug ----------
if (-not $Slug) {
    $Slug = $Title.Trim() -replace '[\s\p{P}\p{S}]+', '-'   # 空白/标点 -> 连字符
    $Slug = $Slug.Trim('-')
}
$Slug = ($Slug -replace '["\\/:*?<>|]', '-').Trim('-. ')
if (-not $Slug) { $Slug = "post" }

$filePath = Join-Path $postsDir "$datePart-$Slug.md"
if (Test-Path -LiteralPath $filePath) {
    throw "文件已存在：$filePath"
}

# ---------- 封面图 ----------
$imagePath = ""
if ($Image) {
    if (Test-Path -LiteralPath $Image) {
        # 本地文件 -> 复制进 assets/img/posts/
        $ext = [System.IO.Path]::GetExtension($Image)
        if (-not $ext) { $ext = ".png" }
        if (-not (Test-Path -LiteralPath $imgDir)) {
            New-Item -ItemType Directory -Path $imgDir | Out-Null
        }
        $imgName = "$datePart-$Slug$($ext.ToLower())"
        Copy-Item -LiteralPath $Image -Destination (Join-Path $imgDir $imgName) -Force
        $imagePath = "/assets/img/posts/$imgName"
        Write-Host "封面图已复制 -> assets\img\posts\$imgName"
    }
    elseif ($Image -like "/*" -or $Image -like "http*") {
        # 站点路径 / 网络 URL：原样引用
        $imagePath = $Image
    }
    else {
        Write-Warning "找不到本地图片 '$Image'，且不是 / 或 http 开头，已忽略封面图。"
    }
}

# ---------- 组装 front matter ----------
$lines = @(
    "---"
    "title: $Title"
    "date: $dateTime"
)
if ($Categories -and $Categories.Count -gt 0) {
    $lines += "categories: [$($Categories -join ', ')]"
}
if ($Tags -and $Tags.Count -gt 0) {
    $lines += "tags: [$($Tags -join ', ')]"
}
if ($Description) {
    $lines += "description: $Description"
}
if ($imagePath) {
    $lines += "image:"
    $lines += "  path: $imagePath"
    $lines += "  alt: $Title"
}
$lines += "---"
$lines += ""
$lines += "<正文内容>"
$lines += ""

Set-Content -LiteralPath $filePath -Value $lines -Encoding utf8
Write-Host ""
Write-Host "已创建：$filePath"

# ---------- 打开编辑 ----------
if (Get-Command code -ErrorAction SilentlyContinue) {
    code $filePath
}
else {
    Start-Process $filePath
}
