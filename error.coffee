error = {}
error.scannerError = (line, errstr, position) ->
    pointer = ""
    if position and position.line
        errstr += " at line: #{position.line}"
    if position and position.col
        errstr += " column: #{position.col}"
        pointer += " " while --position.col > 0
        pointer += "^"
    console.log "#{errstr}\n#{line}\n#{pointer}"
    error.count++

error.parserError = (kind, token) ->
    if token?
        console.log "Expected #{kind} found #{token.kind}"
    else
        console.log "Unexpected #{kind}"


error.count = 0;

module.exports = error;
