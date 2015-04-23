class GenericType
    constructor: (@_type, @innerType) ->

    toString: ->
        return "#{@_type}(#{@innerType})"

    type: ->
        return @_type

module.exports = GenericType
