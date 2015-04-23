class Assign
    constructor: (@name, @op, @exp) ->

    toString: ->
        "(#{@name} #{@op} #{@exp})"

    type: (context) ->
        return null

module.exports = Assign
