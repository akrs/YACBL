class For
    constructor: (@id, @range) ->

    toString: ->
        "(#{@id} #{@range})"

module.exports = For