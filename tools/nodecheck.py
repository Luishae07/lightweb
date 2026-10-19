#!/usr/bin/env python3
"""Updates nodes.txt with the state of every Light.web name service node: how fast it answers and how many sites it knows.
Run by .github/workflows/nodes.yml every five minutes. Only the standard library is used.

nodes.txt keeps one host:port per line; this script adds a comment after it, for example
    bore.pub:25960  # ping 0.7s, sites 80
Old and new browsers cut the comment off, so they read the line the same way."""
import re
import socket
import ssl
import sys
import time
import urllib.request

PATH = "nodes.txt"
MAIN_URL = "https://lightweb-sfw-address.luishae0701.workers.dev"


def ask(addr, line):
    host, port = addr.rsplit(":", 1)
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE  # only a health check: nothing secret is sent or trusted here
    best = None
    for _ in range(3):  # the best of three, so one slow moment does not count
        t = time.time()
        try:
            with socket.create_connection((host, int(port)), timeout=6) as s, ctx.wrap_socket(s, server_hostname=host):
                d = time.time() - t
                best = d if best is None else min(best, d)
        except OSError:
            pass
    if best is None:
        return None, None
    try:
        with socket.create_connection((host, int(port)), timeout=8) as s, ctx.wrap_socket(s, server_hostname=host) as c:
            c.sendall((line + "\n").encode())
            c.settimeout(8)
            buf = b""
            while True:
                try:
                    d = c.recv(65536)
                except OSError:
                    break
                if not d:
                    break
                buf += d
        head, _, body = buf.partition(b"\n")
        if not head.startswith(b"OK "):
            return best, None
        return best, len([x for x in body.decode(errors="replace").split("\n") if x.strip()])
    except OSError:
        return best, None


def describe(addr):
    ping, sites = ask(addr, "LIST")
    if ping is None:
        return "down"
    # rounded to half seconds: every change of nodes.txt starts a new build of the website, so it must not change for small jitter
    p = "ping %.1fs" % max(0.5, round(ping * 2) / 2)
    return p + (", sites %d" % sites if sites is not None else "")


def main():
    lines = open(PATH).read().split("\n")
    out = []
    for ln in lines:
        if ln.startswith("# main SFW:"):
            continue  # rewritten below
        code = ln.split("#", 1)[0].strip()
        if code and re.fullmatch(r"[^\s:]+:\d+", code):
            ln = "%s  # %s" % (code, describe(code))
        out.append(ln)
    try:
        req = urllib.request.Request(MAIN_URL, headers={"User-Agent": "lightweb-nodecheck"})
        main_addr = urllib.request.urlopen(req, timeout=8).read(200).decode().strip()
        if re.fullmatch(r"[^\s:]+:\d+", main_addr):
            # the main SFW is found by the browser through its own address, so it is only reported here
            first = next((i for i, l in enumerate(out) if not l.startswith("#")), len(out))
            out.insert(first, "# main SFW: %s" % describe(main_addr))
    except OSError as e:
        print("could not read the main SFW address:", e)
    text = "\n".join(out)
    if text != "\n".join(lines):
        open(PATH, "w").write(text)
        print("nodes.txt updated")
    else:
        print("nodes.txt unchanged")


if __name__ == "__main__":
    sys.exit(main())
