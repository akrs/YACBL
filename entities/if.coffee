class If
    constructor: (@condition, @block) ->

    toString: ->
        "(#{@condition} #{@block})"

module.exports = If