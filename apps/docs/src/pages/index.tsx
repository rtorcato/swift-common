import Link from '@docusaurus/Link'
import Layout from '@theme/Layout'
import clsx from 'clsx'
import type { ReactElement } from 'react'
import InstallTabs from '@site/src/components/InstallTabs'
import styles from './index.module.css'

/* ------------------------------------------------------------------ */
/* Icons                                                               */
/* ------------------------------------------------------------------ */

type IconKey = 'layers' | 'devices' | 'concurrency' | 'modules'

type IconProps = {
	icon: IconKey
	title: string
	className?: string
	size?: number
}

function Icon({ icon, title, className, size = 22 }: IconProps): ReactElement {
	return (
		<svg
			className={className}
			width={size}
			height={size}
			viewBox="0 0 24 24"
			fill="none"
			stroke="currentColor"
			strokeWidth={1.6}
			strokeLinecap="round"
			strokeLinejoin="round"
			role="img"
		>
			<title>{title}</title>
			{ICONS[icon]}
		</svg>
	)
}

const ICONS: Record<IconKey, ReactElement> = {
	layers: (
		<>
			<path d="m12 3 9 5-9 5-9-5 9-5Z" />
			<path d="m3 13 9 5 9-5" />
			<path d="m3 17 9 5 9-5" />
		</>
	),
	devices: (
		<>
			<rect x="2" y="5" width="14" height="11" rx="1.5" />
			<path d="M8 19h6" />
			<path d="M11 16v3" />
			<rect x="17" y="9" width="5" height="11" rx="1.2" />
		</>
	),
	concurrency: (
		<>
			<circle cx="12" cy="12" r="9" />
			<path d="M12 7v5l3 2" />
			<path d="M8 4.5a9 9 0 0 1 8 0" />
		</>
	),
	modules: (
		<>
			<rect x="3" y="3" width="7" height="7" rx="1.5" />
			<rect x="14" y="3" width="7" height="7" rx="1.5" />
			<rect x="3" y="14" width="7" height="7" rx="1.5" />
			<rect x="14" y="14" width="7" height="7" rx="1.5" />
		</>
	),
}

/* ------------------------------------------------------------------ */
/* Data                                                                */
/* ------------------------------------------------------------------ */

type Pillar = {
	title: string
	desc: string
	icon: IconKey
}

const PILLARS: Pillar[] = [
	{
		title: 'Two products, pay-what-you-use',
		desc: 'Core ships Foundation-only utilities. UI adds SwiftUI on top. Import only what you need.',
		icon: 'layers',
	},
	{
		title: 'Every Apple platform',
		desc: 'iOS 16+, macOS 13+, tvOS 16+, watchOS 9+. Multi-platform builds verified in CI.',
		icon: 'devices',
	},
	{
		title: 'Modern Swift',
		desc: 'async / await throughout. Sendable-ready. Built on the latest stable toolchain.',
		icon: 'concurrency',
	},
	{
		title: '130+ utilities',
		desc: 'Helpers, extensions, networking, managers, SwiftUI components, modifiers, and styles.',
		icon: 'modules',
	},
]

type Category = {
	name: string
	count: string
	desc: string
	chips: string[]
	target: 'Core' | 'UI'
}

const CATEGORIES: Category[] = [
	{
		name: 'Helpers',
		count: '21 helpers',
		desc: 'Date, math, crypto, currency, JSON, regex, random, mime-type, and more.',
		chips: ['DateHelper', 'MathHelper', 'CryptoHelper', 'JsonHelper'],
		target: 'Core',
	},
	{
		name: 'Extensions',
		count: '6 files',
		desc: 'Drop-in additions to Array, Bool, Date, Dictionary, Set, URL.',
		chips: ['ArrayExt', 'DateExt', 'SetExt', 'URLExt'],
		target: 'Core',
	},
	{
		name: 'Networking',
		count: 'async/await',
		desc: 'APIClient + Endpoint + typed NetworkError. URLSession under the hood.',
		chips: ['APIClient', 'Endpoint', 'HttpMethod', 'NetworkError'],
		target: 'Core',
	},
	{
		name: 'Managers & Models',
		count: 'stateful',
		desc: 'Keychain, location, app errors, themes, notifications, file-type enums.',
		chips: ['KeychainManager', 'LocationManager', 'AppLogger'],
		target: 'Core',
	},
	{
		name: 'Components',
		count: '25+ views',
		desc: 'Cards, buttons, containers, web view, QR codes, rating, sticky headers.',
		chips: ['CardContainer', 'LoadingView', 'RatingView', 'WebView'],
		target: 'UI',
	},
	{
		name: 'UI Helpers',
		count: '26 helpers',
		desc: 'Alerts, keyboard, colour, haptics, photo picker, local auth, vision kit.',
		chips: ['AlertHelper', 'HapticsHelper', 'KeyboardHelper'],
		target: 'UI',
	},
	{
		name: 'Modifiers & Styles',
		count: 'composable',
		desc: 'Animatable font, border radius, pressable button, rounded button, blur.',
		chips: ['BorderRadius', 'PressableButton', 'RoundedButton'],
		target: 'UI',
	},
	{
		name: 'UI Managers',
		count: 'observable',
		desc: 'Image cache, system theme tracking, sound, beacon detection.',
		chips: ['ImageCache', 'SystemTheme', 'SoundManager'],
		target: 'UI',
	},
]

const HERO_CODE = `import MatrixSwiftBaseCore

// Helpers
let clamped = MathHelper.clamp(150, min: 0, max: 100)
try await SleepHelper.milliseconds(250)
let token = RandomHelper.string(length: 32)

// Networking
let client = APIClient(baseURL: URL(string: "https://api.example.com")!)
let user: User = try await client.send(.users.me)`

/* ------------------------------------------------------------------ */
/* Sections                                                            */
/* ------------------------------------------------------------------ */

function Hero(): ReactElement {
	return (
		<header className={styles.hero}>
			<div className={styles.heroGlow} aria-hidden />
			<div className={styles.heroInner}>
				<div className={styles.wordmark}>
					<span className={styles.wmSwift}>swift</span>
					<span className={styles.wmDash}>-</span>
					<span className={styles.wmCommon}>common</span>
				</div>
				<p className={styles.tagline}>
					Cross-platform Swift utilities for Apple platforms — Foundation Core + SwiftUI UI,
					from a single SwiftPM package.
				</p>

				<div className={styles.heroBody}>
					<CodeWindow />
				</div>

				<div className={styles.heroActions}>
					<div className={styles.heroButtons}>
						<Link
							className={clsx('button button--primary button--lg', styles.cta)}
							to="/docs/guides/installation"
						>
							Get started →
						</Link>
						<Link
							className={clsx('button button--lg', styles.ctaSecondary)}
							to="/docs/api/core"
						>
							Browse the API
						</Link>
					</div>
					<InstallTabs />
				</div>
			</div>
		</header>
	)
}

function CodeWindow(): ReactElement {
	return (
		<div className={styles.codeWindow}>
			<div className={styles.codeBar}>
				<span className={styles.dot} style={{ background: '#ff5f57' }} />
				<span className={styles.dot} style={{ background: '#febc2e' }} />
				<span className={styles.dot} style={{ background: '#28c840' }} />
				<span className={styles.codeFile}>App.swift</span>
			</div>
			<pre className={styles.codePre}>{HERO_CODE}</pre>
		</div>
	)
}

function Pillars(): ReactElement {
	return (
		<section className={styles.section}>
			<div className={styles.pillarGrid}>
				{PILLARS.map((p) => (
					<div key={p.title} className={styles.pillar}>
						<div className={styles.pillarIcon}>
							<Icon icon={p.icon} title={p.title} size={20} className={styles.pillarIconSvg} />
						</div>
						<div className={styles.pillarTitle}>{p.title}</div>
						<div className={styles.pillarDesc}>{p.desc}</div>
					</div>
				))}
			</div>
		</section>
	)
}

function Categories(): ReactElement {
	return (
		<section className={styles.section}>
			<div className={styles.sectionHead}>
				<div>
					<h2 className={styles.h2}>Core and UI, side by side</h2>
					<p className={styles.sub}>
						Two SwiftPM products. Four Apple platforms. 130+ types organised by what they need
						at compile time.
					</p>
				</div>
				<Link className={styles.viewAll} to="/docs/api/core">
					View full API →
				</Link>
			</div>
			<div className={styles.catGrid}>
				{CATEGORIES.map((c) => (
					<Link
						key={c.name}
						to={c.target === 'Core' ? '/docs/api/core' : '/docs/api/ui'}
						className={styles.card}
					>
						<div className={styles.cardHead}>
							<div className={styles.cardName}>{c.name}</div>
							<div className={styles.cardCount}>
								<span className={styles.targetBadge} data-target={c.target}>
									{c.target}
								</span>
								<span className={styles.cardCountText}>{c.count}</span>
							</div>
						</div>
						<p className={styles.cardDesc}>{c.desc}</p>
						<div className={styles.chips}>
							{c.chips.map((ch) => (
								<span key={ch} className={styles.chip}>
									{ch}
								</span>
							))}
						</div>
					</Link>
				))}
			</div>
		</section>
	)
}

type Sibling = {
	name: string
	tagline: string
	href: string
	dest: 'Docs' | 'GitHub'
}

const SIBLINGS: Sibling[] = [
	{
		name: '@rtorcato/js-common',
		tagline: 'Tree-shakeable TypeScript utilities — tiny bundles, full type safety, CLI included.',
		href: 'https://rtorcato.github.io/js-common/',
		dest: 'Docs',
	},
	{
		name: '@rtorcato/browser-common',
		tagline: 'Small, tree-shakeable TypeScript wrappers around 40+ browser Web APIs.',
		href: 'https://rtorcato.github.io/browser-common/',
		dest: 'Docs',
	},
	{
		name: '@rtorcato/js-tooling',
		tagline:
			'Shared Biome, TypeScript, Vitest and semantic-release presets that power the @rtorcato/* family.',
		href: 'https://rtorcato.github.io/js-tooling/',
		dest: 'Docs',
	},
]

function Siblings(): ReactElement {
	return (
		<section className={styles.section}>
			<div className={styles.sectionHead}>
				<div>
					<h2 className={styles.h2}>Sibling projects</h2>
					<p className={styles.sub}>
						More from <code>@rtorcato</code> — same conventions, same release pipeline.
					</p>
				</div>
			</div>
			<div className={styles.siblingGrid}>
				{SIBLINGS.map((s) => (
					<Link key={s.name} href={s.href} className={styles.card}>
						<div className={styles.cardHead}>
							<div className={styles.cardName}>{s.name}</div>
							<div className={styles.cardCount}>{s.dest} ↗</div>
						</div>
						<p className={styles.cardDesc}>{s.tagline}</p>
					</Link>
				))}
			</div>
		</section>
	)
}

export default function Home(): ReactElement {
	return (
		<Layout
			title="swift-common"
			description="Cross-platform Swift utilities for Apple platforms — Foundation Core + SwiftUI UI, from a single SwiftPM package."
		>
			<main>
				<Hero />
				<Pillars />
				<Categories />
				<Siblings />
			</main>
		</Layout>
	)
}
