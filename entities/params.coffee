class Params
    constructor: (@id, @type) ->

    toString: ->
        "(#{@id.join(' ')} #{@type.join(' ')})"