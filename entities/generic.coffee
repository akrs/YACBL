class GenericType
    constructor: (@outerType, @innerType) ->

    toString: ->
        return "#{@outerType} #{@innerType}"

module.exports = GenericType
