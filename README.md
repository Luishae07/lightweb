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
| `Light.web-windows-amd64.exe`, `Light.web-windows-amd64.zip` | the Light.web browser for Windows (the same program, bare or zipped) |
| `lightweb_0.3.7_amd64.deb` | the Light.web browser for Debian and Ubuntu (22.04 or newer) |
| `SHA256SUMS` | checksums of all of the above |

## Direct downloads (v0.3.7)

| For | Download |
|---|---|
| Windows (bare program) | [Light.web-windows-amd64.exe](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/Light.web-windows-amd64.exe) |
| Windows (zipped) | [Light.web-windows-amd64.zip](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/Light.web-windows-amd64.zip) |
| Debian / Ubuntu | [lightweb_0.3.7_amd64.deb](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/lightweb_0.3.7_amd64.deb) |
| Mac, Apple Silicon | [Light.web-macos-apple-silicon.zip](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/Light.web-macos-apple-silicon.zip) |
| Mac, Intel | [Light.web-macos-intel.zip](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/Light.web-macos-intel.zip) |
| lwserve, Linux (amd64) | [lwserve-linux-amd64](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/lwserve-linux-amd64) |
| lwserve, Linux (arm64) | [lwserve-linux-arm64](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/lwserve-linux-arm64) |
| lwserve, Mac (Apple Silicon) | [lwserve-macos-arm64](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/lwserve-macos-arm64) |
| lwserve, Mac (Intel) | [lwserve-macos-amd64](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/lwserve-macos-amd64) |
| lwserve, Windows | [lwserve-windows-amd64.exe](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/lwserve-windows-amd64.exe) |
| sfw, Linux (amd64) | [sfw-linux-amd64](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/sfw-linux-amd64) |
| sfw, Linux (arm64) | [sfw-linux-arm64](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/sfw-linux-arm64) |
| sfw, Mac (Apple Silicon) | [sfw-macos-arm64](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/sfw-macos-arm64) |
| sfw, Mac (Intel) | [sfw-macos-amd64](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/sfw-macos-amd64) |
| sfw, Windows | [sfw-windows-amd64.exe](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/sfw-windows-amd64.exe) |
| checksums of every file | [SHA256SUMS](https://github.com/Luishae07/lightweb/releases/download/v0.3.7/SHA256SUMS) |

The newest release is always at <https://github.com/Luishae07/lightweb/releases/latest>.

## The browser (macOS)

The Light.web browser is a small Mac app, for Apple Silicon and Intel:

    curl -fsSL https://raw.githubusercontent.com/Luishae07/lightweb/main/install-app.sh | sh

It downloads the right version, checks it, and puts `Light.web.app` in Applications. Open it, press **Cmd+L**, and type a name,
for example `blog.nerd`, `sfadocs.nerd` or `search.cool`.

You can also download `Light.web-macos-apple-silicon.zip` or `Light.web-macos-intel.zip` from the
[latest release](https://github.com/Luishae07/lightweb/releases/latest) yourself. The app is not signed by Apple, so macOS
asks you to confirm the first time: right-click the app, choose **Open**, and confirm. (The installer above avoids this.)
Not sure which chip you have? Run `uname -m`: `arm64` is Apple Silicon, `x86_64` is Intel.

## The browser (Windows and Linux)

Windows: download `Light.web-windows-amd64.exe` and open it (or take the `.zip` and unzip it). It is not signed, so SmartScreen may ask you
to confirm: choose **More info**, then **Run anyway**.

**About the virus scan.** The `.exe` is not signed, and on VirusTotal one engine out of about 70, Bkav Pro, flags it as
`W32.Malware.…` (a generic guess, not a named virus). The others, including Microsoft Defender, do not. This is common for
small unsigned programs. To be sure you have the same file that was scanned, compare its checksum with `SHA256SUMS`
(`Get-FileHash Light.web-windows-amd64.exe` in PowerShell); the current one is
`2b0f7df4d80d56f603f7dca75ee7b6005acfece6359e2f0e07a8c4e4425e4cf0`. If you would rather not take our word for it, run it in
Windows Sandbox or a virtual machine first.

Debian and Ubuntu:

    curl -fsSLO https://github.com/Luishae07/lightweb/releases/download/v0.3.7/lightweb_0.3.7_amd64.deb
    sudo apt install ./lightweb_0.3.7_amd64.deb

Then start **Light.web** from the menu, or run `lightweb`. Press **Ctrl+L** and type a name such as `blog.nerd`.

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

On a home connection, add `-bore`: the mirror opens a free public tunnel through [bore.pub](https://github.com/ekzhang/bore) by
itself (downloading bore to `~/.lightweb/bin` if it is missing), prints its public address, and opens the tunnel again if it
stops. Add that address to `nodes.txt` to list your mirror.

    ./sfw-macos-arm64 -mirror <address of the main SFW> -bore -listen :7001

It copies every name from the main SFW once a minute and answers lookups itself. It keeps its files in
`~/.lightweb-sfw-mirror`. A mirror cannot take registrations: sites keep registering at the main SFW.

You do not have to trust a mirror. Every record carries the site owner's signature, the mirror leaves out any record it cannot
prove, and the browser checks the signature again, so a mirror cannot change where a name points without being caught. A mirror
can only show an out-of-date address (one that has since moved).

## How the browser picks a name service

The browser reads [`nodes.txt`](nodes.txt) (the list of mirrors, one `host:port` per line) and asks the main SFW and every mirror
how fast they answer. It uses the quickest one, with a small preference for the main SFW, and does this again every five minutes.
If the chosen node does not answer, or a mirror does not know a name, the browser asks the next one. A mirror's answer is
only used if the site owner signed it within the last two hours; otherwise the browser asks the main SFW. Registrations and new
top-level names always go to the main SFW.

To add your mirror, open a pull request that adds one line (`your.host:7001`) to `nodes.txt`. To use one node only, start the
browser with `-sfw host:port`.

Names show up in a mirror after their site next refreshes its registration, which happens every 10 minutes.

## Server programs (SFAS)

`lwserve` can run server code for a site. Put a `server.sfs` file in the site folder; it is written in SFAS, the server
language of Light.web. A program has routes, a small database (LightDB) and no always-running process: `lwserve` starts the
code when somebody visits and stops it after `-idle` time (default 5 minutes).

A job is three lines, with no code. This one turns a PNG into a lossless JPEG XL file, made by our own encoder that is built
into `lwserve`:

    GetFunction png/convert/jxl allow_untrusted_functions=true
    ConvertPng=/pics/photo.png
    ConvertJxl=/pics/photo.jxl

Opening `/pics/photo.jxl` returns the converted picture. Other functions come from the function store, the site
`functions.nerd` (for example `xml/json/convert`); each downloaded function is pinned in `functions.lock`.

## About the name `.sf` pages

`.sf` pages describe structure, layout, style, state and logic in one file. A page can describe itself for search engines
with `document_description_crawl = "..."`. Pages in the older `.lw` format work too.

## Status and license

Early version (v0.3.7). The browser and `lwserve` are built from source that is not published here yet.

Released under the [MIT License](LICENSE).
