class For
    # This should be varref, expresson, block
    constructor: (@innerId, @generator, @block) ->

    toString: ->
        "(#{@innerId} #{@generator} #{@block})"

module.exports = For
