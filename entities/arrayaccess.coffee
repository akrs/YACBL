class ArrayAccess
    # This should be varref, expression
    constructor: (@id, @exp) ->

    toString: ->
        "#{@id}[#{@exp}]"

module.exports = ArrayAccess
