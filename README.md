# Light.web: the browser and lwserve

`lwserve` runs a **Light.web** site from a folder of pages. Light.web is a small web of its own: sites have names like
`blog.nerd`, pages are written in **SFAGHC** (`.sf` files), and a browser finds a site by asking a name service where it lives.
This repository holds the downloads for the program that hosts a site.

## Install lwserve (runs a site)

Linux and macOS:

    curl -fsSL https://raw.githubusercontent.com/Luishae07/lightweb/main/install.sh | sh

The script downloads the right file from the [latest release](https://github.com/Luishae07/lightweb/releases/latest),
checks its checksum, and puts `lwserve` in `~/.local/bin`. Windows: download `lwserve-windows-amd64.exe` from the release page.

| File | For |
|---|---|
| `lwserve-linux-amd64`, `lwserve-linux-arm64` | Linux |
| `lwserve-macos-arm64`, `lwserve-macos-amd64` | macOS (Apple Silicon, Intel) |
| `lwserve-windows-amd64.exe` | Windows |
| `Light.web-macos-apple-silicon.zip`, `Light.web-macos-intel.zip` | the Light.web browser for Mac |
| `SHA256SUMS` | checksums of all of the above |

## The browser (macOS)

The Light.web browser is a small Mac app, for Apple Silicon and Intel:

    curl -fsSL https://raw.githubusercontent.com/Luishae07/lightweb/main/install-app.sh | sh

It downloads the right version, checks it, and puts `Light.web.app` in Applications. Open it, press **Cmd+L**, and type a name,
for example `blog.nerd`, `sfadocs.nerd` or `search.cool`.

You can also download `Light.web-macos-apple-silicon.zip` or `Light.web-macos-intel.zip` from the
[latest release](https://github.com/Luishae07/lightweb/releases/latest) yourself. The app is not signed by Apple, so macOS
asks you to confirm the first time: right-click the app, choose **Open**, and confirm. (The installer above avoids this.)
Not sure which chip you have? Run `uname -m`: `arm64` is Apple Silicon, `x86_64` is Intel.

## Run a site

Make a folder with a front page, `index.sf`:

    page "Hello"
      document_description_crawl = "My first Light.web page"
      column gap=16
        h1 "Hello from my site"
        text "It works."

Then start it. On a home connection the easy way is `-bore`: `lwserve` opens a free public tunnel through
[bore.pub](https://github.com/ekzhang/bore) by itself, registers the address it is given, and does it again if the tunnel
restarts. If bore is not installed, the prebuilt program is downloaded for you (to `~/.lightweb/bin`).

    lwserve -name mysite.nerd -bore -dir ./pages

Your pages stay encrypted all the way; the relay only passes the traffic on. If you already have a public address or your own
tunnel, give it with `-advertise host:port` instead of `-bore`.

`lwserve -h` lists every option. The name service is found automatically. A name is first come, first served, and your
site's keys are kept in `<folder>/.lw` (keep that folder: it is what proves the name is yours).

## Run an SFW mirror (help the name service)

The SFW is the name service that tells a browser where a name like `mysite.nerd` lives. A mirror is a read-only copy of it.
Anyone can run one, so names can still be looked up when the main SFW is away.

Download `sfw-<your system>` from the [latest release](https://github.com/Luishae07/lightweb/releases/latest) and start it:

    ./sfw-macos-arm64 -mirror <address of the main SFW> -listen :7001

It copies every name from the main SFW once a minute and answers lookups itself. It keeps its files in
`~/.lightweb-sfw-mirror`. A mirror cannot take registrations: sites keep registering at the main SFW.

You do not have to trust a mirror. Every record carries the site owner's signature, the mirror leaves out any record it cannot
prove, and the browser checks the signature again, so a mirror cannot change where a name points without being caught. A mirror
can only show an out-of-date address (one that has since moved).

To try a mirror, start the browser with `-sfw host:port` of the mirror. The browser does not switch to mirrors by itself yet.
Names show up in a mirror after their site next refreshes its registration, which happens every 10 minutes.

## About the name `.sf` pages

`.sf` pages describe structure, layout, style, state and logic in one file. A page can describe itself for search engines
with `document_description_crawl = "..."`. Pages in the older `.lw` format work too.

## Status and license

Early version (v0.3.3). The browser and `lwserve` are built from source that is not published here yet.

Released under the [MIT License](LICENSE).
