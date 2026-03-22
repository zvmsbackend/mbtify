///|
fn already_mbitified(lines : Iter[StringView]) -> Bool {
  let mut indent = None
  for line in lines {
    if line.trim().is_empty() {
      continue
    }
    let start_trimmed = line.trim_start()
    if !start_trimmed.has_prefix("#|") {
      return false
    }
    let current_indent = line.length() - start_trimmed.length()
    match indent {
      None => indent = Some(current_indent)
      Some(i) if i != current_indent => return false
      _ => ()
    }
  }
  true
}

///|
pub fn mbtify(
  text : String,
  indent? : Int = 0,
  force? : Bool = false,
) -> String? {
  let lines = text.split("\n")
  if !force && already_mbitified(lines) {
    return None
  }
  let indent = " ".repeat(indent)
  Some(lines.iter().map(line => "\{indent}#|\{line}").join("\n"))
}
