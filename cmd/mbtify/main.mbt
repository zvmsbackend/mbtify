///|
fn main {
  let flags = [
    @argparse.FlagArg::new(
      "force",
      short='f',
      about="Force mbtification even if already mbtified",
    ),
    @argparse.FlagArg::new("quiet", short='q', about="Suppress output"),
    @argparse.FlagArg::new("dismbtify", short='d', about="Dismbtify the text"),
  ]
  let indent_arg = @argparse.PositionArg::new(
    "indent",
    num_args=@argparse.ValueRange::new(lower=0, upper=1),
    about="Indentation level",
  )
  let command = @argparse.Command::new("mbtify", flags~, positionals=[
    indent_arg,
  ])
  let matches = command.parse() catch {
    e => {
      println("Error parsing arguments: \{e}")
      return
    }
  }
  let indent = match matches.values.get("indent") {
    Some([indent_str]) =>
      @string.parse_int(indent_str) catch {
        e => {
          println("Invalid indent value: \{e}")
          return
        }
      }
    _ => 0
  }
  let force = matches.flags.get_or_default("force", false)
  let quiet = matches.flags.get_or_default("quiet", false)
  let dismbtify = matches.flags.get_or_default("dismbtify", false)
  fn log(s) {
    if !quiet {
      println(s)
    }
  }
  let text = @clipboard.read_text() catch {
    e => {
      println("Failed to read from clipboard: \{e.to_repr()}")
      return
    }
  }
  if dismbtify {
    match @lib.dismbtify(text) {
      None => log("Text is not mbtified")
      Some(dismbtified) => {
        @clipboard.write_text(dismbtified) catch {
          e => {
            println("Failed to write to clipboard: \{e.to_repr()}")
            return
          }
        }
        log("Text dismbtified and copied to clipboard.")
      }
    }
  } else {
    match @lib.mbtify(text, indent~, force~) {
      None => log("Text is already mbtified. Use --force to mbtify anyway.")
      Some(mbtified) => {
        @clipboard.write_text(mbtified) catch {
          e => {
            println("Failed to write to clipboard: \{e.to_repr()}")
            return
          }
        }
        log("Text mbtified and copied to clipboard.")
      }
    }
  }
}
