class While
    constructor: (@condition, @block) ->

    toString: ->
        "(#{@condition} #{@block})"

module.exports = While