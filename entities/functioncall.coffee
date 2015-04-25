class FunctionCall
    constructor: (@id, @params) ->

    toString: ->
        "(#{id.lexeme} (#{params?.join(' ')}))"

    generator: {
        java: ->
            return "#{@id}(#{params?.join(', ')})"
    }

module.exports = FunctionCall
