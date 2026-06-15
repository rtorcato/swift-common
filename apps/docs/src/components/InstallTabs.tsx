import { type ReactElement, useState } from 'react'
import styles from './InstallTabs.module.css'

type Tab = {
	id: string
	label: string
	/** Shown in the command row. Multi-line strings render with newlines preserved. */
	snippet: string
	/** Whether to render a copy button (Xcode is instructions, not a copy-paste). */
	copyable: boolean
}

const TABS: Tab[] = [
	{
		id: 'package',
		label: 'Package.swift',
		snippet: '.package(url: "https://github.com/rtorcato/swift-common", branch: "main")',
		copyable: true,
	},
	{
		id: 'xcode',
		label: 'Xcode',
		snippet: 'File → Add Package Dependencies… → paste the repo URL',
		copyable: false,
	},
]

function CopyIcon({ done }: { done: boolean }): ReactElement {
	return (
		<svg
			width="16"
			height="16"
			viewBox="0 0 24 24"
			fill="none"
			stroke="currentColor"
			strokeWidth={1.7}
			strokeLinecap="round"
			strokeLinejoin="round"
			role="img"
		>
			<title>{done ? 'Copied' : 'Copy'}</title>
			{done ? (
				<path d="M20 6 9 17l-5-5" />
			) : (
				<>
					<rect x="9" y="9" width="11" height="11" rx="2" />
					<path d="M5 15V5a2 2 0 0 1 2-2h10" />
				</>
			)}
		</svg>
	)
}

export default function InstallTabs(): ReactElement {
	const [active, setActive] = useState(TABS[0].id)
	const [copied, setCopied] = useState(false)
	const tab = TABS.find((t) => t.id === active) ?? TABS[0]

	async function copy() {
		try {
			await navigator.clipboard.writeText(tab.snippet)
		} catch {
			// Clipboard may be unavailable (e.g., insecure context) — ignore.
		}
		setCopied(true)
		setTimeout(() => setCopied(false), 1300)
	}

	return (
		<div className={styles.wrap}>
			<div className={styles.tabs} role="tablist" aria-label="Install method">
				{TABS.map((t) => (
					<button
						key={t.id}
						type="button"
						role="tab"
						aria-selected={active === t.id}
						className={active === t.id ? styles.tabActive : styles.tab}
						onClick={() => {
							setActive(t.id)
							setCopied(false)
						}}
					>
						{t.label}
					</button>
				))}
			</div>
			<div className={styles.cmdRow}>
				{tab.copyable ? (
					<>
						<code className={styles.cmd}>{tab.snippet}</code>
						<button
							type="button"
							className={styles.copy}
							onClick={copy}
							aria-label={copied ? 'Copied' : 'Copy snippet'}
							data-copied={copied}
						>
							<CopyIcon done={copied} />
						</button>
					</>
				) : (
					<span className={styles.cmd}>{tab.snippet}</span>
				)}
			</div>
		</div>
	)
}
