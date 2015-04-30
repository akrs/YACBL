class For
    # This should be varref, expresson, block
    constructor: (@innerId, @generator, @block) ->

    toString: ->
        "(#{@innerId} #{@generator} #{@block})"

    java: -> # TODO: check if type of generator is binary expression or iterable object
        if (@op is "..<" or @op is "...")
            return "for (int _#{@innerId.java()} = #{@leftSide.java()}; _#{@innerId.java()} #{if @iterator.op is '..<' then '<' else '<='} #{@iterator.op.rightSide.java()}; _#{@innerId.java()}++) #{@block.java()}"

module.exports = For
