error = require('./error').analysisError

class Variable
    constructor: (@id, @type) ->

class Class
    constructor: (@id, @properties, @parent, @methods, @typeConversions) ->

class Function
    constructor: (@id, @argTypes, @returnTypes) ->

class Arr
    constructor: (@id, @type) ->

obj = new Class('Obj', [], null, [], ['String'])
print = new Function('print', ['String'], ['void'])

module.exports = (program) ->
    context = Object.create(null)

    context._inFunctionBlock = false

    context.Obj = Obj
    context.print = print

    for declaration in program.declarations
        declaration.declare(context)

    for declaration in program.declarations
        declaration.analyse(context)

