class GenericType
    constructor: (@_type, @innerType) ->

    toString: ->
        return "#{@_type}(#{@innerType})"

    generator: {
        java: ->
            if @_type.lexeme is "ID" then "#{@innerType.generator.java()}[]" else "#{@_type.generator.java()}"
    }
    type: ->
        return @_type

module.exports = GenericType
