#!/usr/bin/env bash
# Render the committed brand PNGs from their SVG sources.
# Sizes come from the brand-asset spec: 1280x320 banner, 1280x786 mobile,
# 1280x640 social card, 512x512 PWA icon, favicon.ico.
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v rsvg-convert >/dev/null 2>&1; then
	echo "brand/render.sh needs librsvg — install it with: brew install librsvg" >&2
	echo "(apt: apt-get install librsvg2-bin)" >&2
	exit 1
fi

rsvg-convert -w 1280 -h 320 brand/banner.svg        -o brand/banner.png
rsvg-convert -w 1280 -h 786 brand/banner-mobile.svg -o brand/banner-mobile.png
rsvg-convert -w 1280 -h 640 brand/social-card.svg   -o brand/social-card.png
rsvg-convert -w 512  -h 512 brand/favicon.svg       -o brand/favicon-512.png
echo "rendered: brand/banner.png brand/banner-mobile.png brand/social-card.png brand/favicon-512.png"

# favicon.ico: the 16 and 32 sizes, packed with ImageMagick when present.
if command -v magick >/dev/null 2>&1; then
	magick -background none brand/favicon.svg -define icon:auto-resize=16,32 brand/favicon.ico
	echo "rendered: brand/favicon.ico"
else
	# Single quotes: in double quotes the backticks would run npx (#72).
	echo 'skipped brand/favicon.ico: needs ImageMagick (`magick`) or `npx @rtorcato/brand-kit render`' >&2
fi

# The docs site gets copies (never overwritten), like `brand-kit`'s docs sync.
img=apps/docs/static/img
if [ -d apps/docs ]; then
	mkdir -p "$img"
	for f in favicon.svg favicon.ico social-card.png; do
		if [ -f "brand/$f" ] && [ ! -e "$img/$f" ]; then
			cp "brand/$f" "$img/$f"
			echo "copied: $img/$f"
		fi
	done
fi

# The --social canvases, each rendered only when its source exists.
social() {
	if [ -f "brand/$1.svg" ]; then
		rsvg-convert -w "$2" -h "$3" "brand/$1.svg" -o "brand/$1.png"
		echo "rendered: brand/$1.png"
	fi
}
social banner-light 1280 320
social banner-mobile-light 1280 786
social avatar 400 400
social instagram-post 1080 1080
social story 1080 1920
social x-header 1500 500
social linkedin-banner 1584 396
social youtube-banner 2560 1440
social facebook-cover 1640 624
