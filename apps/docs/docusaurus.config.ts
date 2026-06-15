import type * as Preset from '@docusaurus/preset-classic'
import type { Config } from '@docusaurus/types'
import { themes as prismThemes } from 'prism-react-renderer'

const config: Config = {
	title: 'swift-common',
	tagline:
		'Cross-platform Swift utilities for Apple platforms — Core (pure Foundation) and UI (SwiftUI) products from a single SwiftPM package.',
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

	presets: [
		[
			'classic',
			{
				docs: {
					sidebarPath: './sidebars.ts',
					routeBasePath: '/',
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
				docsRouteBasePath: '/',
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
			title: 'swift-common',
			logo: {
				alt: 'swift-common',
				src: 'img/logo.svg',
			},
			items: [
				{
					type: 'docSidebar',
					sidebarId: 'docs',
					position: 'left',
					label: 'Docs',
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
					title: 'Docs',
					items: [
						{ label: 'Installation', to: '/guides/installation' },
						{ label: 'Conventions', to: '/guides/conventions' },
						{ label: 'Platform support', to: '/guides/platforms' },
					],
				},
				{
					title: 'API',
					items: [
						{ label: 'Core overview', to: '/api/core' },
						{ label: 'UI overview', to: '/api/ui' },
					],
				},
				{
					title: 'More',
					items: [
						{ label: 'GitHub', href: 'https://github.com/rtorcato/swift-common' },
						{
							label: 'Issues',
							href: 'https://github.com/rtorcato/swift-common/issues',
						},
					],
				},
			],
			copyright: `Copyright © ${new Date().getFullYear()} Richard Torcato. Built with Docusaurus.`,
		},
		prism: {
			theme: prismThemes.github,
			darkTheme: prismThemes.dracula,
			additionalLanguages: ['bash', 'json', 'swift'],
		},
	} satisfies Preset.ThemeConfig,
}

export default config
