class Assign
    constructor: (@ids, @exps) ->

    toString: ->
        "(#{@ids.join(' ')} #{@exps.join(' ')})"

module.exports = Assign