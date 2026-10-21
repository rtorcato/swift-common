import type * as Preset from '@docusaurus/preset-classic'
import type { Config } from '@docusaurus/types'
import { footerCopyright, GITHUB_PROFILE, projectFamilyItems } from '@rtorcato/shared-docs'
import { themes as prismThemes } from 'prism-react-renderer'

// The @rtorcato family, from the shared single source of truth
// (@rtorcato/shared-docs). Surfaced as a navbar "Projects" dropdown and in the
// footer, so a change to the family list lands on every site's next build.
const PROJECT_FAMILY = projectFamilyItems()

const config: Config = {
	title: 'swift-common',
	tagline:
		'Cross-platform Swift utilities for Apple platforms — Foundation Core + SwiftUI UI, from a single SwiftPM package.',
	favicon: 'img/favicon.svg',

	url: 'https://docs.torcato.dev',
	baseUrl: '/swift-common/',

	organizationName: 'rtorcato',
	projectName: 'swift-common',

	onBrokenLinks: 'warn',

	markdown: {
		format: 'detect',
		hooks: {
			onBrokenMarkdownLinks: 'warn',
		},
	},

	i18n: {
		defaultLocale: 'en',
		locales: ['en'],
	},

	headTags: [
		{
			tagName: 'link',
			attributes: { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
		},
		{
			tagName: 'link',
			attributes: {
				rel: 'preconnect',
				href: 'https://fonts.gstatic.com',
				crossorigin: 'anonymous',
			},
		},
		{
			tagName: 'link',
			attributes: {
				rel: 'stylesheet',
				href: 'https://fonts.googleapis.com/css2?family=Geist:wght@400;500;600;700;800&family=Geist+Mono:wght@400;500;600;700&display=swap',
			},
		},
	],

	presets: [
		[
			'classic',
			{
				docs: {
					sidebarPath: './sidebars.ts',
					// Marketing landing (src/pages/index.tsx) owns '/'; docs are at '/docs'.
					routeBasePath: '/docs',
					editUrl: 'https://github.com/rtorcato/swift-common/edit/main/apps/docs/',
				},
				blog: false,
				theme: {
					customCss: './src/css/custom.css',
				},
			} satisfies Preset.Options,
		],
	],

	plugins: [
		// `torcato.dev /` navbar breadcrumb + `← torcato.dev` drawer row. The footer
		// row comes from footerCopyright() below.
		'@rtorcato/shared-docs/docusaurus',
		[
			'@easyops-cn/docusaurus-search-local',
			{
				hashed: true,
				indexDocs: true,
				indexBlog: false,
				docsRouteBasePath: '/docs',
				highlightSearchTermsOnTargetPage: true,
				searchBarShortcutHint: false,
			},
		],
	],

	themeConfig: {
		image: 'img/social-card.png',
		colorMode: {
			defaultMode: 'dark',
			respectPrefersColorScheme: true,
		},
		navbar: {
			title: 'swift-common',
			logo: {
				alt: 'swift-common',
				src: 'img/logo.svg',
				srcDark: 'img/logo-dark.svg',
				width: 26,
				height: 26,
			},
			items: [
				{ to: '/docs', position: 'left', label: 'Docs' },
				{ to: '/docs/api/core', position: 'left', label: 'API' },
				{
					type: 'dropdown',
					label: 'Projects',
					position: 'left',
					items: [{ label: 'All on GitHub →', href: GITHUB_PROFILE }, ...PROJECT_FAMILY],
				},
				{
					href: 'https://github.com/rtorcato/swift-common',
					label: 'GitHub',
					position: 'right',
				},
			],
		},
		footer: {
			style: 'dark',
			links: [
				{
					title: 'Documentation',
					items: [
						{ label: 'Installation', to: '/docs/guides/installation' },
						{ label: 'Conventions', to: '/docs/guides/conventions' },
						{ label: 'Platform support', to: '/docs/guides/platforms' },
						{ label: 'API reference', to: '/docs/api/core' },
					],
				},
				{
					title: 'Resources',
					items: [
						{ label: 'GitHub', href: 'https://github.com/rtorcato/swift-common' },
						{ label: 'Issues', href: 'https://github.com/rtorcato/swift-common/issues' },
						{ label: 'Changelog', to: '/docs/changelog' },
					],
				},
				{
					title: 'Projects',
					items: PROJECT_FAMILY,
				},
				{
					title: 'Community',
					items: [
						{ label: '@rtorcato', href: GITHUB_PROFILE },
						{
							label: 'License',
							href: 'https://github.com/rtorcato/swift-common/blob/main/LICENSE',
						},
					],
				},
			],
			copyright: footerCopyright(),
		},
		prism: {
			theme: prismThemes.vsDark,
			darkTheme: prismThemes.vsDark,
			additionalLanguages: ['bash', 'json', 'swift'],
		},
	} satisfies Preset.ThemeConfig,
}

export default config
