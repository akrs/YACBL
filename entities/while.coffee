class While
    constructor: (@exp) ->

    toString: ->
        "(#{@exp})"

module.exports = While