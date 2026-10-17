# Light.web: lwserve

`lwserve` runs a **Light.web** site from a folder of pages. Light.web is a small web of its own: sites have names like
`blog.nerd`, pages are written in **SFAGHC** (`.sf` files), and a browser finds a site by asking a name service where it lives.
This repository holds the downloads for the program that hosts a site.

## Install

Linux and macOS:

    curl -fsSL https://raw.githubusercontent.com/Luishae07/lightweb/main/install.sh | sh

The script downloads the right file from the [latest release](https://github.com/Luishae07/lightweb/releases/latest),
checks its checksum, and puts `lwserve` in `~/.local/bin`. Windows: download `lwserve-windows-amd64.exe` from the release page.

| File | For |
|---|---|
| `lwserve-linux-amd64`, `lwserve-linux-arm64` | Linux |
| `lwserve-macos-arm64`, `lwserve-macos-amd64` | macOS (Apple Silicon, Intel) |
| `lwserve-windows-amd64.exe` | Windows |
| `SHA256SUMS` | checksums of all of the above |

## Run a site

Make a folder with a front page, `index.sf`:

    page "Hello"
      document_description_crawl = "My first Light.web page"
      column gap=16
        h1 "Hello from my site"
        text "It works."

Browsers reach your site through the address you give with `-advertise`. On a home connection that is usually a tunnel;
for example with [bore](https://github.com/ekzhang/bore):

    bore local 7100 --to bore.pub        # prints the public port, for example bore.pub:41234
    lwserve -name mysite.nerd -advertise bore.pub:41234 -dir ./pages

`lwserve -h` lists every option. The name service is found automatically. A name is first come, first served, and your
site's keys are kept in `<folder>/.lw` (keep that folder: it is what proves the name is yours).

## About the name `.sf` pages

`.sf` pages describe structure, layout, style, state and logic in one file. A page can describe itself for search engines
with `document_description_crawl = "..."`. Pages in the older `.lw` format work too.

## Status and license

Early version (v0.1.0). The Light.web browser is not part of this repository yet.

Released under the [MIT License](LICENSE).
