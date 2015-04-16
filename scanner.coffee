fs = require 'fs'
byline = require 'byline'
{XRegExp} = require 'xregexp'
error = require('./error').scannerError

LETTER = XRegExp '[\\p{L}]'
DIGIT = XRegExp '[\\p{Nd}]'
WORD_CHAR = XRegExp '[\\p{L}\\p{Nd}_]'
KEYWORDS = ///^(?:
            Obj
            |class
            |func
            |int
            |bool
            |float
            |uint
            |tuple
            |for
            |while
            |if
            |public
            |private
            |protected
            |void
            |null
            |main
            |in
            |true
            |false
            |return
            |Interface
           )$///

module.exports = (filename, callback) ->
    baseStream = fs.createReadStream filename, {encoding: 'utf8'}
    baseStream.on 'error', (err) -> error(err)

    stream = byline baseStream, {keepEmptyLines: true}
    tokens = []
    linenumber = 0
    stream.on 'readable', () ->
        scan stream.read(), ++linenumber, tokens
    stream.once 'end', () ->
        tokens.push {kind: 'EOF', lexeme: 'EOF'}
        callback tokens

module.exports.scanString = (str) ->
    tokens = []
    scan str, 1, tokens
    return tokens

commenting = false
scan = (line, linenumber, tokens) ->
    return if not line
    emit = (kind, lexeme) ->
        tokens.push {kind, lexeme: (if lexeme? then lexeme else kind), line: linenumber, col: start+1}

    [start, pos] = [0, 0]
    interpolating = false
    interpolatingDepth = 0

    loop
        if commenting
            pos++ until (line.substring(pos, pos + 3) is '###') or (pos >= line.length)
            if pos >= line.length
                tokens.push {kind: 'EOL', lexeme: 'EOL', line: linenumber}
                break
            pos += 3
            commenting = false

        else
            # Skip spaces
            pos++ while /\s/.test line[pos]
            start = pos

            # Nothing on the line
            if pos >= line.length
                if interpolating
                    error line, 'Unexpected newline', {line: linenumber, col: pos}
                tokens.push {kind: 'EOL', lexeme: 'EOL', line: linenumber}
                break

            # Multi-line comment
            if line.substring(pos, pos + 3) is '###'
                commenting = true
                pos += 3
                continue

            # Comment
            if line[pos] is '#'
                tokens.push {kind: 'EOL', lexeme: 'EOL', line: linenumber}
                break

            # Three-character tokens
            if /\.\.[\.<]/.test line.substring(pos, pos + 3)
                emit line.substring(pos, pos + 3)
                pos += 3

            # Two-character tokens
            else if ///:=                   # Assignment
                  |<=|==|>=|!=              # Relative checkers
                  |\+=|-=|\/=|\*=|\+\+|--   # Modify and reassign
                  |->                       # Function arrow
                  |<<|>>                    # Bitshift
                  |\|\||&&                  # And & Or
               ///.test line.substring(pos, pos+2)
                emit line.substring pos, pos+2
                pos += 2

            else if /\"/.test line[pos]
                pos++                                                       # I wish there was negative lookbehind
                until (/^"|\$\(/.test(line.substring pos, pos + 2) and line[pos - 1] isnt '\\') or pos > line.length
                    pos++
                if pos > line.length
                    error line, 'Unexpected newline', {line: linenumber, col: pos}
                    return
                if /\$\(/.test(line.substring pos, pos + 2)
                    emit 'STRPRT', line.substring ++start, pos
                    start = pos
                    emit '$('
                    interpolating = true
                    interpolatingDepth = 0
                    pos += 2
                else
                    emit 'STRLIT', line.substring ++start, pos
                    pos++

            # One-character tokens
            else if /^(?:[+\-*%\/(),:=<>\[\]\{\}\^\&\|!]|(?:\.[^0-9]))/.test(line.substring(pos, pos + 2))
                emit line[pos++]
                if interpolating
                    interpolatingDepth++ if line[pos - 1] is '('
                    if line[pos - 1] is ')'
                        if interpolatingDepth isnt 0
                            interpolatingDepth--
                        else
                            start = pos
                            interpolating = false
                            pos++ until /^"|\$\(/.test(line.substring pos, pos + 2) and line[pos - 1] isnt '\\' or pos > line.length
                            if pos > line.length
                                error line, 'Unexpected newline', {line: linenumber, col: pos}
                            emit 'STRPRT', line.substring start, pos

                            if /\$\(/.test(line.substring pos, pos + 2)
                                start = pos
                                emit '$('
                                interpolating = true
                                interpolatingDepth = 0
                                pos++
                            pos++

            # Reserved words or identifiers
            else if LETTER.test line[pos]
                pos++ while WORD_CHAR.test(line[pos]) and pos < line.length
                word = line.substring start, pos
                emit (if KEYWORDS.test(word) then word else 'ID'), word

            # Numeric literals
            else if DIGIT.test(line[pos]) or /\./.test line[pos]
                pos++ while DIGIT.test line[pos]
                if line[pos] is '.' and DIGIT.test line[pos + 1]
                    loop
                        pos++
                        break unless DIGIT.test line[pos]
                    emit 'FLOATLIT', line.substring start, pos
                else if line[pos] is '.'
                    error line, "Bad float format: #{line[pos]}", {line: linenumber, col: pos}
                else
                    emit 'INTLIT', line.substring start, pos

            else
                error line, "Illegal character: #{line[pos]}", {line: linenumber, col: pos+1}
                pos++
