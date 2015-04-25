class ReturnStatement
    constructor: (@exps) ->
    
    toString: ->
        "#{@exps}"

    generator: {
        java: () ->
            rets = ""
            for exp, i in @exps
                rets += "_return_object._#{i} = #{@exp.generator.java()};\n"
            return "return _return_object;"
    }

module.exports = ReturnStatement