# Contributing

Thanks for wanting to help. The best way to help Light.web is to make something on it.

## Make a site

1. Install `lwserve` (see the [README](README.md)) and make a folder with an `index.sf` page.
2. Start it with `lwserve -name yourname.nerd -bore -dir ./pages`. Names are first come, first served, so keep the `.lw` folder next to your pages: it holds the keys that prove the name is yours.
3. Put a `document_description_crawl = "..."` line on the pages you want people to find. `search.cool` lists only pages that describe themselves.
4. The SFAGHC language is described at `sfadocs.nerd` (open it in the Light.web browser).
5. To run code on your site's server, add a `server.sfs` file (the SFAS language: routes, a small database, jobs). It only runs when somebody visits. The design is in the SFAS notes, and `sfashowcase.nerd` and `serverless.nerd` are examples.

## Run a mirror

A mirror is a read-only copy of the SFW name service that helps when the main one is away (`sfw -mirror <main> -bore`, see the
[README](README.md)). To list yours, open a pull request that adds one `host:port` line to `nodes.txt`. Make sure it answers
before you ask, and keep it running; a node that is down is dropped from the list.

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
