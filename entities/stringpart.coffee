class StringPart
    constructor: (@parts) ->

    toString: ->
        "#{parts.join(' ')}"

    generator: {
        java: ->
            stringPart = '(""'
            for parts in @part
               stringPart += "+ (#{@parts.generator.java()})"
            return "#{stringPart})"
    }

module.exports = StringPart
