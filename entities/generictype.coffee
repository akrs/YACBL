class GenericType
    constructor: (@type, @innerType) ->

    toString: ->
        return "#{@type} #{@innerType}"

module.exports = GenericType
