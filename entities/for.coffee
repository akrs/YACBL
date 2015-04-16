class For
    constructor: (@innerId, @generator, @block) ->

    toString: ->
        "(#{@innerId} #{@generator} #{@block})"

module.exports = For