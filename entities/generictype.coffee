class GenericType
    constructor: (@type, @innerType) ->

    toString: ->
        "#{@type} #{@innerType}"

module.exports = GenericType
