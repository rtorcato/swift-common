import type { SidebarsConfig } from '@docusaurus/plugin-content-docs'

const sidebars: SidebarsConfig = {
	docs: [
		{
			type: 'category',
			label: 'Start here',
			collapsed: false,
			items: [
				'index',
				'guides/installation',
				'guides/conventions',
				'guides/platforms',
			],
		},
		{
			type: 'category',
			label: 'API Reference',
			items: ['api/core', 'api/ui'],
		},
		{
			type: 'category',
			label: 'Releases',
			items: ['changelog'],
		},
	],
}

export default sidebars
