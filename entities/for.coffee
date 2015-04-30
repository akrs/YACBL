class For
    # This should be varref, expresson, block
    constructor: (@innerId, @generator, @block) ->

    toString: ->
        "(#{@innerId} #{@generator} #{@block})"

    java: -> # TODO: check if type of generator is binary expression or iterable object
        if (@generator.op is "..<" or @generator.op is "...")
            return "for (int _#{@innerId.generator.java()} = #{@generator.leftSide.generator.java()}; _#{@innerId.generator.java()} #{if @iterator.op is '..<' then '<' else '<='} #{@iterator.op.rightSide.generator.java()}; _#{@innerId.generator.java()}++) #{@block.generator.java()}"

module.exports = For
