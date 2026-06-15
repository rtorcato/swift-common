import type * as Preset from '@docusaurus/preset-classic'
import type { Config } from '@docusaurus/types'
import { themes as prismThemes } from 'prism-react-renderer'

const config: Config = {
	title: 'swift-common',
	tagline:
		'Cross-platform Swift utilities for Apple platforms — Foundation Core + SwiftUI UI, from a single SwiftPM package.',
	favicon: 'img/logo.svg',

	url: 'https://rtorcato.github.io',
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
		colorMode: {
			defaultMode: 'dark',
			respectPrefersColorScheme: true,
		},
		navbar: {
			// The "swift-common" wordmark with orange "common" is baked into the
			// SVG logo (light + dark variants), so the title stays empty.
			title: '',
			logo: {
				alt: 'swift-common',
				src: 'img/logo.svg',
				srcDark: 'img/logo-dark.svg',
				width: 168,
				height: 26,
			},
			items: [
				{ to: '/docs', position: 'left', label: 'Docs' },
				{ to: '/docs/api/core', position: 'left', label: 'API' },
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
					title: 'Sibling projects',
					items: [
						{ label: 'js-common', href: 'https://rtorcato.github.io/js-common/' },
						{ label: 'browser-common', href: 'https://rtorcato.github.io/browser-common/' },
						{ label: 'js-tooling', href: 'https://rtorcato.github.io/js-tooling/' },
					],
				},
				{
					title: 'Community',
					items: [
						{
							label: 'License',
							href: 'https://github.com/rtorcato/swift-common/blob/main/LICENSE',
						},
					],
				},
			],
			copyright: `Copyright © ${new Date().getFullYear()} Richard Torcato. Built with Docusaurus.`,
		},
		prism: {
			theme: prismThemes.vsDark,
			darkTheme: prismThemes.vsDark,
			additionalLanguages: ['bash', 'json', 'swift'],
		},
	} satisfies Preset.ThemeConfig,
}

export default config
