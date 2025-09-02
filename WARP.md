# WARP.md - AI Agent Context for Dimi's Corner

This file provides guidance to AI agents (including Warp AI) when working with this Hugo blog project.

---

## 🌐 Project Overview

**Dimi's Corner** is a Hugo static site using the neopost theme, deployed via Docker and Portainer GitOps.

- **Site URL**: https://dimiscorner.coolphill.com
- **Static Site Generator**: Hugo v0.149.0
- **Theme**: neopost (with custom "meow" color scheme)
- **Content Management**: Decap CMS at `/admin`
- **Architecture**: Multi-stage Docker build → Nginx serving
- **Deployment**: Portainer GitOps (auto-deploy from GitHub master branch)
- **Server**: Remote server at `phill@192.168.1.39`

---

## 📁 Current Project Structure

```
dimis-corner/
├── hugo.yaml                    # Hugo configuration (YAML format)
├── content/
│   ├── en/                     # English content (multilingual setup)
│   │   ├── posts/              # Blog posts
│   │   ├── sidebar/            # Sidebar content (bio, basic-info, _index.md)
│   │   └── welcome-header/     # Homepage welcome section
│   └── jp/                     # Japanese content (disabled)
├── themes/neopost/             # Neopost theme (git submodule)
├── data/custom_themes.yaml    # Custom color themes ("meow" theme)
├── static/                     # Static assets
│   ├── admin/                  # Decap CMS files
│   │   ├── index.html
│   │   └── config.yml
│   └── *.png                   # Theme images (cat.png, flower.png, etc.)
├── Dockerfile                  # Multi-stage build with error checking
└── WARP.md                     # This file
```

---

## ⚠️ Critical Understanding: Hugo Build Process

### The Docker Build Issue
**IMPORTANT**: This project had recurring issues where Docker builds would fail silently, causing the site to revert to Nginx default page. The Dockerfile now includes comprehensive error checking and debugging.

### How the Build Works:
1. **Stage 1 (hugomods/hugo:exts)**: Builds Hugo site → `/src/public/`
2. **Stage 2 (nginx:1.27-alpine)**: Serves static files from `/usr/share/nginx/html/`

### If Site Shows Nginx Default Page:
```bash
# Manual fix (temporary):
docker run --rm --network=none -v $(pwd):/src -w /src hugomods/hugo:exts --minify --gc
cat public/index.html | ssh phill@192.168.1.39 "docker exec -i hugo_nginx sh -c 'cat > /usr/share/nginx/html/index.html'"
```

### Deployment Flow:
1. Push to GitHub master branch
2. Portainer GitOps detects change
3. Rebuilds Docker container automatically
4. New container should serve updated site

---

## 🎨 Theme & Content System

### Neopost Theme Features:
- **Multilingual support** (English/Japanese)
- **Custom color schemes** via `data/custom_themes.yaml`
- **Current theme**: "meow" (light blue/pink)
- **Image galleries**: title-images, ending-images
- **Read more** functionality with configurable length
- **Sidebar system**: bio, basic-info, navigation links

### Content Structure:
- **Posts**: `content/en/posts/*.md`
- **Sidebar**: `content/en/sidebar/{bio.md, basic-info.md, _index.md}`
- **Welcome**: `content/en/welcome-header/_index.md`

### Post Front Matter Format:
```yaml
---
title: "Post Title"
date: "2025-02-09T10:00:00-03:00"
tags: ["tag1", "tag2"]
title-images: ["/photo1.png"]
ending-images: ["/photo2.png", "/photo3.png"]
author: "Dimi"
draft: false
table-of-contents: false
---
```

---

## 🛠️ Development Commands

### Local Hugo Build (for testing):
```bash
# Test build locally
docker run --rm --network=none -v $(pwd):/src -w /src hugomods/hugo:exts --minify --gc

# Check generated files
ls -la public/
head public/index.html
```

### Container Management:
```bash
# Check remote container status
ssh phill@192.168.1.39 "docker ps --filter 'name=hugo'"

# View container logs
ssh phill@192.168.1.39 "docker logs hugo_nginx --tail 20"

# Access container
ssh phill@192.168.1.39 "docker exec -it hugo_nginx sh"
```

### Content Management:
- **Admin Interface**: https://dimiscorner.coolphill.com/admin
- **Authentication**: GitHub OAuth
- **Content Path**: `content/en/posts/`
- **Media**: Upload to `static/` directory

---

## 🔧 Configuration Files

### `hugo.yaml` - Site Configuration
```yaml
title: "Dimi's Corner"
baseURL: 'https://dimiscorner.coolphill.com'
theme: "neopost"
languages:
  en:
    contentDir: content/en
params:
  theme: "meow"  # Custom theme in data/custom_themes.yaml
  posts-per-page: 5
```

### `data/custom_themes.yaml` - Color Schemes
```yaml
- name: "meow"
  site-bg: "/flowertile.png"
  accent-color: "#f55cc0"
  # ... more color definitions
```

### `static/admin/config.yml` - Decap CMS
```yaml
backend:
  name: github
  repo: Ph-ill/dimis-corner
collections:
  - name: "posts"
    folder: "content/en/posts"
```

---

## ⚡ Quick Fixes & Common Issues

### Site Shows Nginx Default Page:
1. Check if Portainer rebuild completed
2. Manual fix: Run local build → copy index.html to container
3. Check Docker build logs for Hugo errors

### Admin Panel Not Loading:
1. Verify `static/admin/index.html` and `config.yml` exist
2. Check GitHub authentication setup
3. Simple config uses GitHub backend (not git-gateway)

### Theme Issues:
1. Verify `themes/neopost/` contains theme files
2. Check `hugo.yaml` has `theme: "neopost"`
3. Ensure required content structure exists (sidebar, welcome-header)

---

## 📋 AI Agent Guidelines

### When Making Changes:
1. **Test locally first** with Hugo Docker container
2. **Commit and push** to trigger Portainer deployment
3. **Verify deployment** - check if site loads correctly
4. **If broken**: Fix immediately or revert commit

### Content Creation:
- Use `content/en/posts/` directory
- Follow neopost theme frontmatter format
- Include `title-images` and `ending-images` for galleries
- Test with local Hugo build before pushing

### Never:
- Use terminal commands to read files (use read_files tool)
- Make assumptions about Hugo build success
- Ignore Docker build failures
- Break the existing theme structure
