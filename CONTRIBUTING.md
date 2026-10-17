# Contributing

Thanks for wanting to help. The best way to help Light.web is to make something on it.

## Make a site

1. Install `lwserve` (see the [README](README.md)) and make a folder with an `index.sf` page.
2. Start it with `lwserve -name yourname.nerd -bore -dir ./pages`. Names are first come, first served, so keep the `.lw` folder next to your pages: it holds the keys that prove the name is yours.
3. Put a `document_description_crawl = "..."` line on the pages you want people to find. `search.cool` lists only pages that describe themselves.
4. The SFAGHC language is described at `sfadocs.nerd` (open it in the Light.web browser).

## Report a bug

Open an issue and tell us:

- what you did, what you expected, and what happened instead;
- your computer (Mac with Intel or Apple Silicon, Linux, Windows) and the version (`lwserve -version`, or the release you installed);
- for the browser: the lines from the **F12** panel for the page that failed;
- the address of the site, if it is a public one.

Please do not put passwords, keys or other private details in an issue. The `.lw` folder of a site holds its keys and should never be shared.

## Suggest something

Open an issue. A small, concrete idea ("a `table` element with a header row") is easier to act on than a big one.

## Code

The source for the browser and `lwserve` is not published in this repository yet, so pull requests are not possible for now. Issues, bug reports, sites and ideas are all welcome.

## License

By contributing here you agree that your contribution is released under the [MIT License](LICENSE).
