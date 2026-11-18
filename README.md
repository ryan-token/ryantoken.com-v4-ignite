## ryantoken.com

![Vercel](https://vercelbadge.vercel.app/api/ryan-token/ryantoken.com-v4-ignite)

[ryantoken.com](https://www.ryantoken.com) was created in [Swift](https://www.swift.org) with [Ignite](https://github.com/twostraws/Ignite) and is hosted on [Vercel](https://vercel.com).

* To preview the site: `ignite run`
* Or, to preview the site and open a browser window automatically: `ignite run --preview`
* After adding or changing an image in `Assets/images`, run `Scripts/optimize-images.sh` (needs `brew install webp pngquant`). It generates the WebP and 512px icon copies the build serves; originals are never modified. Commit the copies along with `Scripts/optimize-images.manifest`; until the script reruns, the build serves a changed image unoptimized and warns about it.

![Ignite Logo](/Assets/images/ignite.png)

[Previous versions](https://github.com/ryan-token/ryantoken.com-v3-svelte) of the site were built with [Svelte](https://svelte.dev/), [Tailwind](https://tailwindcss.com), [Publish](https://github.com/johnsundell/publish), [Netlify](https://www.netlify.com), and others.
