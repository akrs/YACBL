class TupleDec
    constructor: (@names, @types, @exps) ->

    toString: ->
        "(#{@names.join(' ')} #{@type?.join(' ')} #{@exp?.join(' ')})"

module.exports = TupleDec
