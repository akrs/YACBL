class FunctionCall
    constructor: (@id, @params) ->

    toString: ->
        "(#{id.lexeme} (#{params?.join(' ')}))"

module.exports = FunctionCall
