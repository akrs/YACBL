class Assign
    constructor: (@nameToken, @opToken, @exp) ->
        @name = @nameToken.lexeme
        @op = @opToken.lexeme

    toString: ->
        "(#{@name} #{@op} #{@exp})"

    generator: {
        java: ->
            return "#yac_{@name.generator.java()} #{@op} #{@exp.generator.java()};"
    }

module.exports = Assign
