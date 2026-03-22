# sennenki/mbtify

I LOVE MOONBIT MULTILINE STRING LITERALS!

This commandline tool helps you prefix the lines in your clipboard with `#|`. Supports optional idention.

Usage:

```
Usage: mbtify [options] [indent]

Arguments:
  indent  Indentation level

Options:
  -h, --help       Show help information.
  -f, --force      Force mbtification even if already mbtified
  -q, --quiet      Suppress output
  -d, --dismbtify  Dismbtify the text
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
  #|many
  #|lines
  #|of
  #|texts
```

And then `mbtify -d`:

```
many lines
of
texts
```
