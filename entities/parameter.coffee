class Parameter
    constructor: (@name, @type) ->

    toString: ->
        "(#{@name} : #{@type})"

    java: (context) ->
        return "(#{@type.lexeme} #{@name.lexeme})"

module.exports = Parameter
