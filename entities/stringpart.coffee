class StringPart
    constructor: (@parts) ->

    toString: ->
        "#{parts.join(' ')}"

    generator: {
        java: ->
            stringPart = "(\"\""
            @parts.forEach (@part) -> 
               stringPart += "+ (#{@parts.generator.java()})"
            return "#{stringPart})"
    }

module.exports = StringPart
