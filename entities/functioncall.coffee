class FunctionCall
    constructor: (@id, @params) ->

    toString: ->
        return "(#{id.lexeme} (#{params?.join(' ')}))"

module.exports = FunctionCall
