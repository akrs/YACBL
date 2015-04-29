class FunctionCall
    constructor: (@id, @params) ->

    toString: ->
        return "(#{id} (#{params?.join(' ')}))"

module.exports = FunctionCall
