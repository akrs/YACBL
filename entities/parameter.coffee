class Parameter
    constructor: (@name, @type) ->

    toString: ->
        "(#{@name} : #{@type})"

    java: ->
        return "(#{@type.lexeme} #{@name.lexeme})"

module.exports = Parameter
