class Assign
    constructor: (@name, @op, @exp) ->

    toString: ->
        "(#{@name} #{@op} #{@exp})"

module.exports = Assign