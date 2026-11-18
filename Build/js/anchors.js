// Section anchors on the Apps and Projects pages (e.g. /apps#outrank).
//
// 1. Clicking a header's link icon copies the section's clean URL to the clipboard
//    and briefly shows a "Copied" confirmation (styles in custom.css).
// 2. When a page is opened at an anchor, the browser jumps to it before the
//    screenshots above it have loaded. As they load they push the section down, so
//    once everything has loaded, settle on the section again - unless the visitor
//    has already started scrolling.
(() => {
    // og:url is the canonical address (https://www.ryantoken.com/apps), so copied links
    // never carry /index.html, a localhost origin, or a query string.
    const ogURL = document.querySelector('meta[property="og:url"]')?.content;
    const baseURL = (ogURL || location.origin + location.pathname).split("#")[0];

    document.addEventListener("click", async (event) => {
        const link = event.target.closest(".anchor-link");
        if (!link || !navigator.clipboard) return; // Without clipboard access, just follow the link.

        event.preventDefault();
        const id = link.getAttribute("href").slice(1);

        try {
            await navigator.clipboard.writeText(`${baseURL}#${id}`);
        } catch {
            location.hash = id;
            return;
        }

        // Put the anchor in the address bar too, without scrolling.
        history.replaceState(null, "", `#${id}`);

        const icon = link.querySelector("i");
        clearTimeout(link.copiedTimer);
        clearTimeout(link.iconTimer);
        icon.classList.replace("bi-link-45deg", "bi-check2");
        link.classList.remove("copied");
        void link.offsetWidth; // Restart the animation on repeat clicks.
        link.classList.add("copied");

        link.copiedTimer = setTimeout(() => {
            link.classList.remove("copied");
            // Swap the icon back after the confirmation has faded out.
            link.iconTimer = setTimeout(() => icon.classList.replace("bi-check2", "bi-link-45deg"), 250);
        }, 1600);
    });

    const navigation = performance.getEntriesByType("navigation")[0];
    if (!location.hash || navigation?.type === "reload" || navigation?.type === "back_forward") return;

    // Only keys that scroll count; Tab, modifiers, and shortcuts shouldn't cancel the settle.
    const scrollKeys = new Set(["ArrowUp", "ArrowDown", "PageUp", "PageDown", "Home", "End", " "]);
    let visitorScrolled = false;
    const markScrolled = (event) => {
        if (event.type === "keydown" && !scrollKeys.has(event.key)) return;
        visitorScrolled = true;
    };
    const scrollEvents = ["wheel", "touchmove", "keydown", "mousedown"];
    for (const type of scrollEvents) addEventListener(type, markScrolled, { passive: true });

    addEventListener("load", () => {
        for (const type of scrollEvents) removeEventListener(type, markScrolled);
        if (visitorScrolled) return;
        let id = location.hash.slice(1);
        try { id = decodeURIComponent(id); } catch {} // Malformed escapes (e.g. #%E0) would otherwise throw.
        const target = document.getElementById(id);
        target?.scrollIntoView({ block: "start" }); // Honors .section-anchor's scroll-margin-top.
    });
})();
