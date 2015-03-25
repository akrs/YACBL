class If
    constructor: (@exp, @block) ->

    toString: ->
        "(#{@exp} #{@block})"

module.exports = If