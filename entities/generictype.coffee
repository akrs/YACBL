class GenericType
    constructor: (@_type, @innerType) ->

    toString: ->
        return "#{@_type}(#{@innerType})"

    java: (context) ->
        if @_type.lexeme is "ID" then "#{@innerType.java()}[]" else "#{@_type.java()}"

    type: ->
        return @_type

module.exports = GenericType
