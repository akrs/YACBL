class Returns
    constructor: (@id, @type) ->

    toString: ->
        "(#{@id.join(' ')} #{@type.join(' ')})"

module.exports = Returns