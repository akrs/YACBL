lookup = require('../generator').lookup
class FunctionCall
    constructor: (@id, @params) ->

    toString: ->
        "(#{@id.lexeme} (#{params?.join(' ')}))"

    java: ->
        id = lookup["#{@id}"] || "_#{@id}"
        params = ""
        for param in @params
            params += if param.token?.kind is 'STRLIT' then "\"#{param}\"" else "#{param.java()}"
        return "#{id}(#{params})"

module.exports = FunctionCall
