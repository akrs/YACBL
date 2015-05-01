class TypeConversion
    constructor: (@targetType, @block, @return) ->

    analyse: (context) ->
        return @block.analyse() and @return.type() is @targetType.toString()

module.exports = TypeConversion
