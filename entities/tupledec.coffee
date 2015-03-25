class TupleDec
    constructor: (@id, @type, @exp) ->

    toString: ->
        "(#{@id.join(' ')} #{@type.join(' ')} #{@exp.join(' ')})"

module.exports = TupleDec