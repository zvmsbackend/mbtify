///|
fn main {
  let flags = [
    @argparse.FlagArg::new(
      "force",
      short='f',
      about="Force mbtification even if already mbtified",
    ),
    @argparse.FlagArg::new("quiet", short='q', about="Suppress output"),
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
      @strconv.parse_int(indent_str) catch {
        e => {
          println("Invalid indent value: \{e}")
          return
        }
      }
    _ => 0
  }
  let force = matches.flags.get_or_default("force", false)
  let quiet = matches.flags.get_or_default("quiet", false)
  let text = @clipboard.read_text() catch {
    e => {
      println("Failed to read from clipboard: \{e}")
      return
    }
  }
  match @lib.mbtify(text, indent~, force~) {
    None => {
      if !quiet {
        println("Text is already mbtified. Use --force to mbtify anyway.")
      }
      return
    }
    Some(mbtified) => {
      @clipboard.write_text(mbtified) catch {
        e => {
          println("Failed to write to clipboard: \{e}")
          return
        }
      }
      if !quiet {
        println("Text mbtified and copied to clipboard.")
      }
    }
  }
}
