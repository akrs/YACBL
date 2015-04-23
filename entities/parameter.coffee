class Parameter
    constructor: (@name, @type) ->

    toString: ->
        "(#{@name} : #{@type})"

    generator: {
        java: ->
            return "(#{@type.lexeme} #{@name.lexeme})"
    }

module.exports = Parameter
