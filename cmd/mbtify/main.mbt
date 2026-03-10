const Usage =
  #|Usage: mbtify [options] [indent] ...
  #|
  #|Options:
  #|  -f, --force    Force mbtification even if already mbtified
  #|  -q, --quiet    Suppress output

fn main {
  let force = Ref::new(false)
  let quiet = Ref::new(false)
  let specs = [
    ("-f", "--force", @argparser.Set(force), "Force mbtification even if already mbtified"),
    ("-q", "--quiet", @argparser.Set(quiet), "Suppress output")
  ]
  let mut indent = None
  @argparser.parse(specs, s => indent = Some(s), Usage, @sys.get_cli_args()[1:].to_array()) catch {
    @argparser.ErrorMsg(msg) => {
      println("Error parsing arguments: \{msg}")
      return
    }
    e => {
      println("Unexpected error: \{e}")
      return
    }
  }
  let indent_value = @strconv.parse_int(indent.unwrap_or("0")) catch {
    e => {
      println("Invalid indent value: \{e}")
      return
    }
  }
  let text = @clipboard.read_text() catch {
    e => {
      println("Failed to read from clipboard: \{e}")
      return
    }
  }
  match @lib.mbtify(text, indent=indent_value, force=force.val) {
    None => {
      if !quiet.val {
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
      if !quiet.val {
        println("Text mbtified and copied to clipboard.")
      }
    }
  }
}
