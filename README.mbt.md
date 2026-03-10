# sennenki/mbtify

I LOVE MOONBIT MULTILINE STRING LITERALS!

This commandline tool helps you prefix the lines in your clipboard with `#|`. Supports optional idention.

Usage:

```
Usage: mbtify [options] [indent] ...

Options:
  -f, --force    Force mbtification even if already mbtified
  -q, --quiet    Suppress output
```

Example. Clipboard data before:

```
many
lines
of
texts
```

After executing `mbtify 2`:

```
  #|lines
  #|of
  #|texts
```
