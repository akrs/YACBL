error = (line, errstr, position) ->
    pointer = ""
    if position and position.line
        errstr += " at line: #{position.line}"
    if position and position.col
        errstr += " column: #{position.line}"
        pointer += " " while --position.col > 0
        pointer += "^"
    console.log "#{errstr}\n#{line}\n#{pointer}"
    error.count++

error.count = 0;

module.exports = error;