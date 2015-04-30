class FunctionCall
    constructor: (@id, @params) ->

    toString: ->
        "(#{id.lexeme} (#{params?.join(' ')}))"

    java: ->
        return "#{@id}(#{params?.join(', ')})"

module.exports = FunctionCall
