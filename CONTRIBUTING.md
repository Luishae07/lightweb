# Contributing

Thanks for wanting to help. The best way to help Light.web is to host a mirror. A mirror keeps the name service reachable for everyone, and it takes one command.

## Host a mirror (the best way to help)

The SFW is the name service that tells a browser where a name like `blog.nerd` lives. A mirror is a read-only copy of it. When the
main SFW is slow or away, browsers ask a mirror instead, so every mirror makes Light.web faster and harder to knock over. You do
not need a public address, a domain or a server in a data center: a laptop on a home connection is enough.

**Why it is safe for everyone.** Every record in the name service is signed by the site that owns it. A mirror leaves out any
record it cannot prove, and the browser checks the signature again, so a mirror cannot change where a name points. The worst it can
do is show an address that has since moved. Running one does not give anybody access to your computer, and a mirror cannot take
registrations; sites keep registering at the main SFW.

**How to start one**

1. Download `sfw-<your system>` from the [latest release](https://github.com/Luishae07/lightweb/releases/latest) (Linux, macOS or
   Windows, Intel or ARM). Check it against `SHA256SUMS` if you like.
2. Start it. On a home connection add `-bore`: the mirror opens a free public tunnel by itself, prints its public address, and
   opens the tunnel again if it drops.

       ./sfw-linux-amd64 -mirror <address of the main SFW> -bore -listen :7001

   The address of the main SFW is in the [README](README.md). The mirror copies every name once a minute and keeps its files in
   `~/.lightweb-sfw-mirror`.
3. Write down the public address it prints (it looks like `bore.pub:12345`). You can test it from the Light.web browser with
   `-sfw bore.pub:12345`: open any site name, and if the page loads, the mirror works.
4. Open a pull request that adds one line, that address, to `nodes.txt`. The list is checked about every five minutes. Nodes are
   ranked by how fast they answer, so a slow or dead one is simply not used.

**Keep it running.** A mirror is only useful while it is up. If you can leave it on a home server, a Raspberry Pi, or a small
cloud machine, run it as a service (`systemd` on Linux, a Login Item or `launchd` on macOS). A free bore address can change when
the tunnel restarts; the mirror prints the new one, and your line in `nodes.txt` then needs updating. If your node is down for
long it will be removed from the list, and you can always add it back.

Two mirrors that run for months are worth more than ten that run for a day.

## Or make a site

1. Install `lwserve` (see the [README](README.md)) and make a folder with an `index.sf` page.
2. Start it with `lwserve -name yourname.nerd -bore -dir ./pages`. Names are first come, first served, so keep the `.lw` folder next to your pages: it holds the keys that prove the name is yours.
3. Put a `document_description_crawl = "..."` line on the pages you want people to find. `search.cool` lists only pages that describe themselves.
4. The SFAGHC language is described at `sfadocs.nerd` (open it in the Light.web browser).
5. To run code on your site's server, add a `server.sfs` file (the SFAS language: routes, a small database, jobs). It only runs when somebody visits. The design is in the SFAS notes, and `sfashowcase.nerd` and `serverless.nerd` are examples.

## Share a function

Server programs can load ready-made functions by path (`GetFunction text/words`) from the function store, the site
`functions.nerd`. A function is a plain text `.sfs` file in the SFAS language, so it can be read before it is trusted. If you
wrote one that others could use (a converter, a text or list helper), open an issue with its source and what it does. We read it,
test it, and add it to the store. A function that needs speed (images, audio) has to be native Go code inside `lwserve`, so
describe the job and we will look at it together.

## Report a bug

Open an issue and tell us:

- what you did, what you expected, and what happened instead;
- your computer (Mac with Intel or Apple Silicon, Linux, Windows, iPhone) and the version (`lwserve -version`, or the release you installed);
- for the browser: the lines from the **F12** panel for the page that failed;
- for server code: the error text (it names the file and the line, and an `X4` code means the server code failed);
- the address of the site, if it is a public one.

Please do not put passwords, keys or other private details in an issue. The `.lw` folder of a site holds its keys and should never be shared.

## Suggest something

Open an issue. A small, concrete idea ("a `table` element with a header row") is easier to act on than a big one.

## Code

The source for the browser and `lwserve` is not published in this repository yet, so pull requests are not possible for now. Issues, bug reports, sites and ideas are all welcome.

## License

By contributing here you agree that your contribution is released under the [MIT License](LICENSE).
