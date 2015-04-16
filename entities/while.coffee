class While
    constructor: (@condition, @block) ->

    toString: ->
        "(#{@exp} #{@block})"

module.exports = While