import Link from '@docusaurus/Link'
import CommandBlock from '@rtorcato/shared-docs/components/CommandBlock'
import type { ReactElement } from 'react'
import styles from './UseWithAI.module.css'

// Local copy of @rtorcato/shared-docs' <UseWithAI />: that component always adds
// a "node_modules/<pkg>/AGENTS.md" card, which doesn't exist for a SwiftPM package.
// Swap back to the shared one if it gains a way to drop that card.
const REPO = 'rtorcato/swift-common'
const PLUGIN = 'swift-common'

const targets = [
	{
		title: 'Any coding agent',
		desc: <>Pull the skill into any tool the skills CLI supports.</>,
		commands: [`npx skills add https://github.com/${REPO} --skill ${PLUGIN}`],
	},
	{
		title: 'Claude Code',
		desc: <>The repo is its own plugin marketplace — register it once, then install the plugin.</>,
		commands: [`/plugin marketplace add ${REPO}`, `/plugin install ${PLUGIN}@${PLUGIN}`],
	},
	{
		title: 'Cursor, Copilot, Codex',
		desc: (
			<>
				They read <code>AGENTS.md</code> from the repo root. Copy it into your project's agent config.
			</>
		),
		commands: [`https://github.com/${REPO}/blob/main/AGENTS.md`],
	},
]

export default function UseWithAI(): ReactElement {
	return (
		<section className={styles.section}>
			<div className={styles.sectionHead}>
				<div>
					<h2 className={styles.h2}>Use with AI</h2>
					<p className={styles.sub}>
						A skill ships in the repo so AI coding tools use swift-common the way it's meant to be used.
					</p>
				</div>
				<Link className={styles.viewAll} href={`https://github.com/${REPO}/blob/main/AGENTS.md`}>
					Read the rules →
				</Link>
			</div>
			<div className={styles.aiStack}>
				{targets.map((t) => (
					<div key={t.title} className={styles.card}>
						<div className={styles.cardTitle}>{t.title}</div>
						<div className={styles.cardDesc}>{t.desc}</div>
						<div className={styles.cmds}>
							<CommandBlock commands={t.commands} />
						</div>
					</div>
				))}
			</div>
		</section>
	)
}
