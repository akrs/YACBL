class Loop
    constructor: (@typeOfLoop, @block) ->

    toString: ->
        "(#{@typeOfLoop} #{@block})"

module.exports = Loop