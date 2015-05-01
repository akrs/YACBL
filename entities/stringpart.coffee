class StringPart
    constructor: (@parts) ->

    toString: ->
        "#{@parts.join(' ')}"

    java: ->
        stringPart = '(""'
        for part in @parts
           part = if part.id then "_#{part.id}" else "\"#{part.lexeme}\""
           stringPart += "+ (#{part})"
        return "#{stringPart})"

module.exports = StringPart
