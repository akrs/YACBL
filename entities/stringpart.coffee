class StringPart
    constructor: (@parts) ->

    toString: ->
        "#{parts.join(' ')}"

    java: ->
        stringPart = '(""'
        for parts in @part
           stringPart += "+ (#{@parts.java()})"
        return "#{stringPart})"

module.exports = StringPart
