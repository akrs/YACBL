fs = require 'fs'
byline = require 'byline'
{XRegExp} = require 'xregexp'
error = require './error'

LETTER = XRegExp '[\\p{L}]'
DIGIT = XRegExp '[\\p{Nd}]'
WORD_CHAR = XRegExp '[\\p{L}\\p{Nd}_]'
KEYWORDS = ///^(?:
            Obj
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

commenting = false
scan = (line, linenumber, tokens) ->
    return if not line
    emit = (kind, lexeme) ->
        tokens.push {kind, lexeme: lexeme or kind, line: linenumber, col: start+1}

    [start, pos] = [0, 0]

    loop
        if not commenting
            # Skip spaces
            pos++ while /\s/.test line[pos]
            start = pos

            # Nothing on the line
            break if pos >= line.length

            # Multi-line comment
            if line.substring(pos, pos + 3) is '###'
                commenting = true
                break

            # Comment
            break if line[pos] is '#'

            # Two-character tokens
            if /// <=|==|>=|!=           # Relative checkers
                  |\+=|-=|\/=|\*=|\+\+|--  # Modify and reassign
                  |->                   # Function arrow
                  |<<|>>                # Bitshift
                  |\|\||&&              # And & Or
               ///.test line.substring(pos, pos+2)
                emit line.substring pos, pos+2
                pos += 2

            else if /\"/.test line[pos]
                pos++ while not /[^\\]\"/.test(line.substring pos, pos + 2)
                emit 'STRLIT', line.substring start + 1, pos + 1

                pos += 2

            # One-character tokens
            else if /[+\-*\/(),:=<>\{\}\^&\|!]/.test line[pos]
                emit line[pos++]

            # Reserved words or identifiers
            else if LETTER.test line[pos]
                pos++ while WORD_CHAR.test(line[pos]) and pos < line.length
                word = line.substring start, pos
                emit (if KEYWORDS.test word then word else 'ID'), word

            # Numeric literals
            else if DIGIT.test line[pos]
                pos++ while DIGIT.test line[pos]
                if line[pos] is '.' and DIGIT.test line[pos + 1]
                    pos++ while DIGIT.test line[pos]
                    emit 'FLOATLIT', line.substring start, pos
                else if line[pos] is '.'
                    error line, "Bad float format: #{line[pos]}", {line: linenumber, col: pos}
                else
                    emit 'INTLIT', line.substring start, pos

            else
                error line, "Illegal character: #{line[pos]}", {line: linenumber, col: pos+1}
                pos++
        else
            pos++ while line.substring pos, pos + 3 is not '###'
            break if pos >= line.length
            commenting = false
