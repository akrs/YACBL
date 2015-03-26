class ArrayAccess
    constructor: (@id, @exp) ->

    toString: ->
        "#{@id}[#{@exp}]"

module.exports = ArrayAccess