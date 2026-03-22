///|
fn already_mbitified(lines : Iter[StringView]) -> Bool {
  for line in lines; indent = None {
    if line.is_blank() {
      continue indent
    }
    let start_trimmed = line.trim_start()
    if !start_trimmed.has_prefix("#|") {
      return false
    }
    let current_indent = line.length() - start_trimmed.length()
    match indent {
      None => continue Some(current_indent)
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
  let lines = text.split("\n").to_array()
  if !force && already_mbitified(lines.iter()) {
    return None
  }
  let indent = " ".repeat(indent)
  Some(lines.iter().map(line => "\{indent}#|\{line}").join("\n"))
}

///|
pub fn dismbtify(text : String) -> String? {
  let output = StringBuilder::new()
  for line in text.split("\n"); indent = None {
    if line.is_blank() {
      output..write_view(line).write_char('\n')
      continue indent
    }
    let start_trimmed = line.trim_start()
    if !start_trimmed.has_prefix("#|") {
      return None
    }
    let current_indent = line.length() - start_trimmed.length()
    output..write_view(start_trimmed[2:]).write_char('\n')
    match indent {
      None => continue Some(current_indent)
      Some(i) if i != current_indent => return None
      _ => ()
    }
  }
  Some(output.to_string())
}
