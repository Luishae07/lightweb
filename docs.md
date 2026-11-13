# SFAS documentation

SFAS is the server language of Light.web. A website uses it to run code on its own server: answer requests with data, keep a
small database, convert files, and push live messages to open pages. It runs inside `lwserve`, the program that hosts a site,
and nothing runs until somebody visits (see [Serverless](#serverless)).

This page covers the `sfas` command, the language, the built-in functions, the database, the powers a program has, functions from
the function store, and live pages.

## Contents

1. [Download and first program](#download-and-first-program)
2. [The `sfas` command](#the-sfas-command)
3. [The language](#the-language)
4. [Built-in functions](#built-in-functions)
5. [A website with server code](#a-website-with-server-code)
6. [LightDB, the database](#lightdb-the-database)
7. [What a program may do](#what-a-program-may-do)
8. [Functions and the function store](#functions-and-the-function-store)
9. [Jobs: code without code](#jobs-code-without-code)
10. [Serverless](#serverless)
11. [Live pages (WATCH)](#live-pages-watch)
12. [Errors](#errors)
13. [Not built yet](#not-built-yet)

## Download and first program

Download `sfas` for your system from the [latest release](https://github.com/Luishae07/lightweb/releases/latest):

| System | File |
|---|---|
| Linux (Intel/AMD) | `sfas-linux-amd64` |
| Linux (ARM) | `sfas-linux-arm64` |
| Mac (Apple Silicon) | `sfas-macos-arm64` |
| Mac (Intel) | `sfas-macos-amd64` |
| Windows | `sfas-windows-amd64.exe` |

On Linux and Mac make it runnable and put it on your path:

    chmod +x sfas-linux-amd64
    mv sfas-linux-amd64 ~/.local/bin/sfas

Write `hello.sfs`:

    people <- [{name: "Ada", age: 36}, {name: "Grace", age: 85}]
    oldest <- people | sort age down | take 1
    say "{oldest}"

Run it:

    sfas run hello.sfs
    [{name: "Grace", age: 85}]

There is also a command for working with a database directly: see [The `lightdb` command](#the-lightdb-command).

## The `sfas` command

    sfas run [options] program.sfs          run a program
    sfas check program.sfs                  report mistakes without running it
    sfas pin [options] function/path        download a function, keep it, and write functions.lock
    sfas get [options] site-folder /path    answer one request of a website the way lwserve would, and print the answer

| Option | Meaning |
|---|---|
| `-functions dir` | the folder of functions (default: `functions` next to the program) |
| `-store name` | the Light.web site that serves functions (default `functions.nerd`) |
| `-sfw address` | the name service (default: found automatically) |
| `-timeout 30s` | stop a program that runs longer; `0` turns the limit off |
| `-sandbox` | with `get`: cut the powers of programs down to the site's own folder |

`sfas check` reads the whole program and reports a mistake with its file and line, for example a wrong indent, without running anything.

`sfas get ./mysite /api/posts` is the quickest way to test a route: it prints `OK <type>` and the answer, or the error code.

## The language

A program is lines. Lines nest by indentation, like pages. `//` starts a comment.

### Values

number, text, yes/no, nothing, list, map, function. Lists and maps can hold any value.

    n <- 42
    name <- "Ada"
    ok <- yes
    list <- [1, 2, 3]
    person <- {name: "Ada", age: 36}
    say person.name

Text with `{expression}` in it is filled in. Write `\{` for a plain brace.

    say "{person.name} is {person.age}"

### Names, arrows and pipes

`name <- value` makes or changes a name (`=` works too). A **pipe** `|` hands the result so far to the next command as its first argument:

    nums <- range 1 6
    total <- nums | map (x -> x * x) | sum
    say total

- A command is a function name followed by its arguments: `sort age down`, `take 3`.
- A bare word that is not a name in the program is the text of the word. That is why `sort age down` needs no quotes.
- Inside parentheses a pipeline is a value: `say (nums | map (x -> x * 2))`.
- Lambdas are written `x -> expression` or `(a, b) -> expression`.

### Control flow

    if p.age > 50
      say "old"
    else if p.age > 20
      say "grown"
    else
      say "young"

    for p in people            // for k, v in map   and   for x, i in list also work
      say p.name

    while n > 0
      n = n - 1

    func square(x)
      return x * x

    try
      fail "oops"
    catch e
      say "caught: {e.message}"

`break` and `continue` work in loops. `and`, `or` and `not` combine tests.

## Built-in functions

| Group | Functions |
|---|---|
| Output | `say` (alias `print`) |
| Text | `len`, `upper`, `lower`, `trim`, `split`, `join`, `contains`, `replace`, `starts`, `ends`, `repeat`, `slice` |
| Convert | `number`, `text`, `type` |
| Numbers | `round`, `floor`, `ceil`, `abs`, `min`, `max`, `sum`, `sqrt`, `pow`, `random` |
| Lists | `range`, `sort`, `take`, `skip`, `reverse`, `first`, `last`, `add`, `unique` |
| Higher order | `map`, `filter`, `reduce`, `any`, `all`, `find` |
| Maps | `keys`, `values`, `has`, `get`, `put`, `remove`, `merge` |
| JSON | `json`, `fromjson` |
| Time | `now`, `iso` |
| Mistakes | `fail`, `assert` |

Examples:

    say ("a,b,c" | split ",")            // ["a", "b", "c"]
    say (people | filter (p -> p.age > 40) | map (p -> p.name))
    say (sort [3, 1, 2])                 // [1, 2, 3]
    say (json {a: 1})                    // {"a":1}

## A website with server code

Put a `server.sfs` file in the site folder. `lwserve` runs it when somebody visits. A **route** answers an address with data:

    route get "/api/posts"
      return db.posts.sort(at, down).limit(30)

    route get "/api/sign"
      name <- trim(request.name)
      if name != ""
        db.posts.add({name: name, at: now()})
      return db.posts.sort(at, down).limit(30)

- `request` holds the form fields and address values (`request.name`), the method and the site's name.
- `return` sends the value back, as JSON for maps and lists.
- `reply(body, type)` sends text or any bytes with a content type; `notfound()` answers `X1`.

A `.sf` page can also have a `server` block that runs before the page is drawn:

    page "Guestbook"
      server
        posts = db.posts.sort(at, down).limit(20)
      column
        for p in posts
          text "{p.name}"

Test a route without starting the site:

    sfas get ./mysite /api/posts

## LightDB, the database

Every site has its own database in `<site folder>/.lw/data/`: tables of maps, each record with an automatic `id`, a write-ahead log
(a crash loses at most the transaction that was running) and sorted indexes. No SQL: queries are written in the language.

| Call | What it does |
|---|---|
| `db.posts.add({...})` | add a record, returns it with its `id` |
| `db.posts.get(id)` | one record by id |
| `db.posts.update(id, {...})` | change fields of a record |
| `db.posts.remove(id)` | delete a record |
| `db.posts.all()` | every record |
| `db.posts.count()` | how many |
| `db.posts.index("at")` | keep a sorted index on a field, for fast sorting and ranges |
| `db.posts.find(field, value)` | records where the field equals the value |
| `db.posts.range(field, from, to)` | records whose field lies between two values |
| `db.posts.clear()` | delete all records |
| `.sort(field, down)` / `.limit(n)` | order and cut the result |

Keep what a program must remember in LightDB or in files, never in memory: a serverless program can stop at any moment.

### The `lightdb` command

`lightdb` opens a database, or makes one, and lets you work with it, like `sqlite3` does for SQLite. Download `lightdb-<your system>`
from the [latest release](https://github.com/Luishae07/lightweb/releases/latest) (same systems as `sfas`).

    lightdb mydata                     open the database in the folder mydata (made if it is not there)
    lightdb mydata -c 'db.posts.all()' run one command and print the answer
    lightdb mydata -f setup.sfs        run a file of commands
    echo 'db.tables()' | lightdb mydata

Point it at a site's own database with `lightdb mysite/.lw/data` (stop the site first: one program may open a database at a time).

Every line is SFAS. An expression prints its value; a statement is run. Names you make stay until you leave.

    lightdb> db.posts.add({title: "hi", n: 1})
    {id: 1, title: "hi", n: 1}
    lightdb> db.posts.all()
    [{id: 1, title: "hi", n: 1}]
    lightdb> x <- 5
    lightdb> x * 2
    10
    lightdb> for p in db.posts.all()
         ...>   say p.title
         ...>
    hi

A line that starts with `if`, `for`, `while`, `func`, `try` or `route` starts a block, which ends at an empty line.

| Command | What it does |
|---|---|
| `.tables` | list the tables |
| `.count [table]` | rows per table |
| `.schema [table]` | rows, indexes and the fields of the first row |
| `.dump [table]` | every row as JSON, one per line |
| `.mode json` / `.mode text` | how answers are printed (or start with `-json`) |
| `.read file.sfs` | run a file |
| `.compact` | shrink the log file |
| `.help`, `.quit` | help, leave (Ctrl-D too) |

Options: `-c command`, `-f file`, `-json`, `-new` (fail if the database exists), `-existing` (fail if it does not, so a typo does not
make an empty database). In `-c`, `-f` and pipes the exit code is 1 if a command failed. For arrow-key history use `rlwrap lightdb mydata`.

## What a program may do

The person who runs `lwserve` wrote the site and owns the machine, and visitors never run server code, they only send requests.
So by default a program may do what its admin can:

| Power | What it is |
|---|---|
| `request`, `reply` | the request, and the answer |
| `db` | the site's database |
| `read`, `write`, `append`, `exists`, `list`, `delete` | files the admin's account can reach |
| `run(command, args)` | run another program and read its output |
| `env` | environment variables |
| `fetch(url)` | an outgoing web request |
| `hash`, `uuid`, `hashpassword`, `checkpassword`, `sign`, `verify` | passwords, ids, signatures |
| `log` | write to the server log |

A request that runs longer than 30 seconds is stopped, and a failing program gives the visitor an error page without taking the
server down.

**`-sandbox`** is for hosting somebody else's site, or being careful. Programs then get only their own folder and database, no
`run` or `env`, `fetch` only to hosts listed in `.lw/allow.txt`, and limits on memory, time and bytes written. Start `lwserve`
or `lwhost` with `-sandbox`.

## Functions and the function store

A function is named by a path, like a Go import: `text/title`, `math/clamp`, `xml/json/convert`. Use one with `GetFunction`:

    GetFunction text/truncate
    say (truncate("a long sentence", 6))

Lookup order:

1. the site's own `functions/` folder (`functions/text/truncate.sfs`)
2. the function store, the Light.web site `functions.nerd` (or `-store name`), or a site you name in the path: `mylib.nerd/tools/csv/convert`

A function is plain source text, so you can read it before you trust it. The first download writes its fingerprint into
`functions.lock` next to the site (like `go.sum`). A later download that does not match is refused. `sfas pin xml/json/convert`
downloads and pins one on purpose. A new function from a library nobody has vouched for needs `allow_untrusted_functions=true` on the line.

In the store now: `text/title`, `text/slug`, `text/words`, `text/truncate`, `text/markdown`, `math/clamp`, `math/average`,
`math/stats`, `list/chunk`, `list/group`, `csv/json/convert`, `xml/json/convert`, `json/pretty`, `convert`.

**Native functions** are Go code inside `lwserve`, called by the same path. `png/convert/jxl` is one: it turns a PNG into a lossless
JPEG XL file, using our own encoder (no outside tool). Its output is 30 to 45 percent smaller than the PNG for screenshots.

## Jobs: code without code

Some sites only need a small job done. A job is a few `key=value` lines:

    GetFunction png/convert/jxl allow_untrusted_functions=true
    ConvertPng=/pics/photo.png
    ConvertJxl=/pics/photo.jxl

Opening `/pics/photo.jxl` runs the function on the PNG and returns the answer. No file has to exist on disk. The result is kept until the
source changes. Each function names its own input and output lines (`png/convert/jxl` takes `ConvertPng=` and gives `ConvertJxl=`;
`xml/json/convert` takes `GetJson=` and gives `XmlFile=`).

A job that fetches a file adds `GetUrl=`, `SaveFile=` and either `Refresh=1h` (refresh on the first visit after an hour) or
`WakeEvery=1h` (refresh on a schedule, with no visitor).

## Serverless

There is no always-running server program. `lwserve` stays running, small, and starts the site's server code only when somebody asks.

    lwserve -name mysite.nerd -bore -dir ./site -idle 5m

- The first visit that needs server code starts it; `lwserve` waits until it is ready.
- After `-idle` time (default 5 minutes) with no visitors, it stops. The next visit starts it again.
- A start must finish in 15 seconds.
- One running copy per site. Static pages and files are answered by `lwserve` itself, without waking anything.
- No background timers inside a program: use `WakeEvery=`.
- An open live connection keeps the program awake until it closes.

For your own program that speaks plain HTTP, `-app "./myserver"` starts it when needed and gives it a free port in the `PORT` environment variable.

## Live pages (WATCH)

For chat, polls and dashboards, **WATCH** keeps a connection open and both sides push messages. It is plain text with length-prefixed
payloads (up to 64 KiB each).

In a page, one head line opens the connection:

    watch /live sub=room name={nick} -> chat
    ...
    for m in chat
      text "{m.user}: {m.text}"
    button "Send" -> say chat room msg then msg = ""

`chat` is the list of messages (oldest first, last 200), `chat_who` the people present, `chat_status` is `connecting`, `live` or
`offline`, `chat_me` your connection id and `chat_typing` the people typing. Actions: `say <watch> <channel> <value>`,
`typing <watch> <channel>`, `listen <watch> <channel>`.

Features: many channels on one connection and patterns like `room.*`; the last 500 messages of each channel with ids, replayed to
a client that comes back after a drop; presence (join, leave, rename); typing events; direct messages; heartbeats every 25 seconds;
a limit of 20 messages a second per connection.

Optional hooks, written as ordinary routes: `/__live/connect`, `/__live/subscribe`, `/__live/message`. A route may refuse with
`return {allow: no, message: "..."}` or change what is sent with `return {data: {...}}`.

Server code can call `publish(channel, value)`, `members(channel)`, `history(channel, since, limit)`, `push(id, value)`,
`kick(id, reason)` and `livestats()`.

From a terminal: `lwlive chatstuff.what room` joins a channel (`/who`, `/nick`, `/dm`, `/hist`, `/typing`).

## Errors

A mistake is an error with a file and a line, never a crash of the server:

    error: t.sfs line 2: there is no name "squar"
    error: t.sfs line 2: I do not understand "+" here

A word that is not a name is read as text, so `say squar` prints `squar`; a call like `squar(x)` is the one that fails.
`sfas check` finds mistakes in the shape of the program (like the second one) before a visitor does. Inside `try` / `catch e`, `e` holds `message`, `line` and `file`.

## Not built yet

- a REPL (an interactive prompt)
- lossy JPEG XL, animation, and the reverse direction (`jxl/convert/png`)
- other native converters (`png/convert/webp`, `audio/convert/opus`)
- the sandbox's memory limits on every system

Questions or a mistake in this page: open an issue at <https://github.com/Luishae07/lightweb/issues>.
