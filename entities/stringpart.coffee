class StringPart
    constructor: (@parts) ->

    toString: ->
        "#{parts.join(' ')}"

    java: ->
        stringPart = '(""'
        for parts in @part
           stringPart += "+ (#{@parts.generator.java()})"
        return "#{stringPart})"

module.exports = StringPart
