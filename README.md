# Dimi's Corner

A Hugo-based blog built for a friend, based on the [Hugo](https://gohugo.io/) static site generator and the [neopost](https://github.com/colorchestra/hugo-neopost-theme) theme.

## Credits

- **[Hugo](https://gohugo.io/)** - Fast static site generator
- **[neopost theme](https://github.com/colorchestra/hugo-neopost-theme)** - Original Hugo theme by colorchestra

## Functional Modifications

### Dynamic Background System
- Added automatic background tile rotation on page load
- Uses Hugo's `readDir` to scan `static/bg_tiles/` directory
- Generates JavaScript array of available images at build time
- Randomly selects and applies tiled background from available images

### Portfolio Page
- Created dedicated `/portfolio` page with custom layout
- Moved welcome header content from homepage to portfolio page
- Added filtering system for posts tagged with "portfolio"
- Homepage now displays only blog posts with pagination

### Content Management
- Integrated with Decap CMS for web-based content editing
- Admin interface accessible at `/admin/`
- Configured for GitHub backend with OAuth authentication

### Navigation Updates
- Modified sidebar navigation links (Portfolio, Archive)
- Maintained responsive design and mobile compatibility

### Theme Customization
- Custom color palette configuration via `data/custom_themes.yaml`
- Modified avatar styling (square shape with rounded corners, centered alignment)
- Extended CSS for background image override functionality

## Deployment

The site uses Docker multi-stage builds and deploys via Portainer GitOps:
- Automatic rebuilds on GitHub repository updates
- Container-based deployment with Nginx serving static files
- Build-time Hugo compilation with theme integration

## File Structure

```
├── content/en/          # English content
│   ├── posts/           # Blog posts
│   ├── portfolio/       # Portfolio page content
│   └── sidebar/         # Sidebar configuration
├── static/
│   └── bg_tiles/        # Background tile images
├── themes/neopost/      # Modified neopost theme
├── data/
│   └── custom_themes.yaml # Color scheme configuration
└── admin/               # Decap CMS configuration
```

---

## 📜 Licensing

This repository contains both the source code for the blog's theme and infrastructure, as well as the blog's creative content. These two components are licensed separately.

### Code License

All source code used to generate and display this site is licensed under the **MIT License**. You can find a copy of the license in the `LICENSE` file.

### Content License

All creative content, including all text and images found within the blog posts, is the exclusive property of **Dimi's Corner**.

**© 2025 Dimi's Corner. All Rights Reserved.**

This content is **not** open source. Permission is required for any reuse, republication, or distribution.

### Dependencies

This project builds upon:
- **[Hugo](https://gohugo.io/)** (Apache 2.0 License)
- **[neopost theme](https://github.com/colorchestra/hugo-neopost-theme)** (See original theme license)
