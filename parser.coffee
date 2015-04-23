error = require('./error').parserError

ArrayAccess = require './entities/arrayaccess'
Assignment = require './entities/assign'
BinaryExpression = require './entities/binaryexpression'
Block = require './entities/block'
ClassDec = require './entities/classdec'
ForLoop = require './entities/for'
Func = require './entities/func'
FunctionBlock = require './entities/functionblock'
FunctionCall = require './entities/functioncall'
GenericType = require './entities/generictype'
IfStatement = require './entities/if'
Literal = require './entities/literal'
Parameter = require './entities/parameter'
PrimitiveDeclaration = require './entities/primitivedeclaration'
Program = require './entities/program'
PropDec = require './entities/propdec'
ReturnStatement = require './entities/returnstatement'
StringPart = require './entities/stringpart'
TupleAssignment = require './entities/tupleassignment'
TupleDeclaration = require './entities/tupledec'
Type = require './entities/type'
UnaryExpression = require './entities/unaryexpression'
WhileLoop = require './entities/while'

tokens = []

module.exports = (scannerOutput) ->
    tokens = scannerOutput
    program = parseProgram()
    match 'EOF'
    return program

parseProgram = ->
    declarations = []

    match 'EOL' while at 'EOL'
    loop
        declarations.push parseDeclaration()
        match 'EOL' while at 'EOL'
        break if at 'EOF'
    return new Program declarations

parseDeclaration = ->
    if at 'class'
        return parseClass()
    else if at ['ID', 'main']
        if next() is ':' and tokens[2].kind is 'func'
            return parseFunc()
        else if [':', ':='].some((kind) -> kind is next())
            return parsePrimitive()
        else if next() is ','
            return parseTuple()
    else
        error 'declaration', tokens[0]

parseClass = ->
    match('class')
    name = match 'ID'
    match ':'
    if at 'ID' # TODO: need to support multiple inheritance?
        parent = match 'ID'
    else if at 'Obj'
        parent = match 'Obj'
    else if at 'Interface'
        parent = match 'Interface'
    else
        error 'parent', tokens[0]
        return
    match '{'
    match 'EOL'
    properties = []
    loop
        properties.push parsePropertyDeclaration()
        break if at '}'
    match '}'

    return new ClassDec name, parent, properties

parsePropertyDeclaration = ->
    # note, this looks stupid. Why you no requre this?
    # the problem is, constructors don't have an access level.
    # gnaw on that.
    if at ['public', 'private', 'protected']
        accessLevel = match ['public', 'private', 'protected']

    if at 'final'
        match 'final'
        final = true
    else
        final = false

    declaration = parseDeclaration()
    if at 'where'
        match 'where'
        whereExp = parseExp()

    match 'EOL'

    return new PropDec accessLevel, final, declaration, whereExp

parseFunc = ->
    name = match ['ID', 'main']
    match ':'
    match 'func'
    match '('
    params = parseParameters()
    match ')'
    match '->'
    match '('
    returns = parseReturns()
    match ')'
    block = parseFuncBlock()

    return new Func name, params, returns, block

parseParameters = ->
    parameters = []
    while at 'ID'
        name = match 'ID'
        match ':'
        type = parseType()
        match ',' if at ','
        parameters.push new Parameter name, type

    return parameters

parseReturns = ->
    returns = []
    if at 'void'
        returns.push match 'void'
        return returns
    until at ')'
        returns.push parseType()
    return returns

parsePrimitive = ->
    name = match 'ID'
    if at ':'
        match ':'
        type = parseType()
        if at '='
            match '='
            exp = parseExp()
    else
        match ':='
        exp = parseExp()

    return new PrimitiveDeclaration name, type, exp

parseType = ->
    if at ['bool','int','uint','float']
        return new Type match();
    else if at 'func'
        match 'func'
        match '('
        params = []
        until at ')'
            params.push parseType()
            match ',' if at ','
        match ')'
        match '->'
        match '('
        returns =[]
        until at ')'
            if at 'void'
                returns.push 'void'
                break
            returns.push parseType()
            match ',' if at ','
        match ')'
        return new Func undefined, params, returns, undefined
    else if at ['tuple', 'ID']
        type = match()
        if at '('
            match '('
            innertype = parseType()
            match ')'
            return new GenericType type, innertype
        return new Type type

parseTupleDeclaration = ->
    names = []
    names.push match 'ID'
    while at ','
        match ','
        names.push match 'ID'
    if at ':'
        types = []
        types.push matchType()
        if at '='
            match '='
            exps = parseExpList()
    else
        match ':='
        exps = parseExpList()

    return new TupleDeclaration names, types, exps

parseExpList = ->
    exps = []
    exps.push parseExp()
    while at ','
        match ','
        parseExp()
    return exps

parseBlock = ->
    statements = []
    match '{'
    match 'EOL'
    while not at '}'
        match 'EOL' while at 'EOL'
        break if at '}'
        statements.push parseStatment()
        match 'EOL'
    match '}'
    return new Block statements

parseFuncBlock = ->
    statements = []
    match '{'
    match 'EOL'
    while not at ['}', 'return']
        match 'EOL' while at 'EOL'
        break if at '}'
        statements.push parseStatment()
        match 'EOL'
    if at 'return'
        returns = parseReturnStatement()
        match 'EOL'
    match '}'
    return new FunctionBlock statements, returns

parseStatment = ->
    if at ['for', 'while', 'if']
        return parseIf() if at 'if'
        return parseForLoop() if at 'for'
        return parseWhileLoop() if at 'while'
    else
        if next() is ':' or next() is ':='
            return parseDeclaration()
        else if lineContains ['=', '+=', '-=', '*=', '/=', '%=']
            return parseAssignment()
        return parseExp()

parseReturnStatement = ->
    match 'return'
    exps = []
    until at 'EOL'
        exps.push parseExp()
        match ',' if at ','
    return new ReturnStatement exps

parseIf = ->
    match 'if'
    match '('
    condition = parseExp()
    match ')'
    block = parseBlock()
    return new IfStatement condition, block

parseForLoop = ->
    match 'for'
    match '('
    innerId = match 'ID'
    match 'in'
    # TODO: refactor range expression into the exp chain, allow for function calls and stuff here
    generator = if at 'ID' then match 'ID' else parseRange()
    match ')'
    block = parseBlock()
    return new ForLoop innerId, generator, block

parseRange = ->
    leftSide = parseExp()
    op = if at '...' then match '...' else match '..<'
    rightSide = parseExp()

    return new BinaryExpression leftSide, op, rightSide

parseWhileLoop = ->
    match 'while'
    match '('
    condition = parseExp()
    match ')'
    block = parseBlock()
    return new WhileLoop condition, block

parseAssignment = ->
    id = parseExp9()
    if next() is ','
        ids = []
        ids.push id
        while at ','
            match ','
            ids.push parseExp9()
        match '='
        exps = []
        exps.push parseExp()
        while at ','
            match ','
            exps.push parseExp()
        return new TupleAssignment ids, exps     #change id to name?
    else if at ['+=', '-=', '*=', '/=', '%=']
        op = match()
        exp = parseExp()
        return new Assignment id, op, exp
    else
        op = match '='
        exp = parseExp()
        return new Assignment id, op, exp

parseExp = ->
    leftSide = parseExp1()
    while at ['||', '&&']
        operation = if at '||' then match '||' else match '&&'
        rightSide = parseExp1()
        return new BinaryExpression leftSide, operation, rightSide
    return leftSide

parseExp1 = ->
    leftSide = parseExp2()
    if at ['<', '<=', '==', '!=', '>=', '>']
        operation = match ['<', '<=', '==', '!=', '>=', '>']
        rightSide = parseExp2()
        return new BinaryExpression leftSide, operation, rightSide
    return leftSide

parseExp2 = ->
    leftSide = parseExp3()
    while at ['|', '&', '^']
        operation = match ['|', '&', '^']
        rightSide = parseExp3()
        return new BinaryExpression leftSide, operation, rightSide
    return leftSide

parseExp3 = ->
    leftSide = parseExp4()
    while at ['<<', '>>']
        operation = match ['<<', '>>']
        rightSide = parseExp4()
        return new BinaryExpression leftSide, operation, rightSide
    return leftSide

parseExp4 = ->
    leftSide = parseExp5()
    while at ['+', '-']
        operation = match ['+', '-']
        rightSide = parseExp5()
        return new BinaryExpression leftSide, operation, rightSide
    return leftSide

parseExp5 = ->
    leftSide = parseExp6()
    while at ['*', '/', '%']
        operation = match ['*', '/', '%']
        rightSide = parseExp6()
        return new BinaryExpression leftSide, operation, rightSide
    return leftSide

parseExp6 = ->
    if at ['-', '!']
        operation = match ['-', '!']
    rightSide = parseExp7()

    if operation?
        return new UnaryExpression rightSide, 'prefix', operation
    else
        return rightSide

parseExp7 = ->
    if at ['++', '--']
        operation = match ['++', '--']
    rightSide = parseExp8()

    if operation?
        return new UnaryExpression rightSide, 'prefix', operation
    else
        return rightSide

parseExp8 = ->
    leftSide = parseExp9()
    if at ['++', '--']
        operation = match ['++', '--']
        return new UnaryExpression leftSide, 'postfix', operation
    return leftSide

parseExp9 = ->
    leftSide = parseExp10()
    if at '.'
        op = match '.'
        rightSide = parseExp10()
        return new BinaryExpression leftSide, op, rightSide
    return leftSide

parseExp10 = ->
    # TODO: Ask Toal about this. Want to be able to say something like x()[1] and x[1]()
    if at 'ID'
        if next() is '('
            return parseFuncCall()
        else if next() is '['
            return parseArrayAccess()
        else
            return match 'ID'
    else if at '('
        match '('
        result = parseExp()
        match ')'
        return result
    else if at 'STRPRT'
        strprt = []
        strprt.push match 'STRPRT'
        while at '$('
            match '$('
            strprt.push parseExp()
            match ')'
            strprt.push match 'STRPRT'   #TODO I think this is wrong
        return new StringPart strprt
    else if at ['INTLIT', 'FLOATLIT', 'STRLIT', 'true', 'false']
        return new Literal match()
    else
        error 'expression expected', tokens[0]

parseFuncCall = ->
    id = match 'ID'
    match '('
    params = []
    while not at ')'
        params.push parseExp()
        match ',' if at ','
    match ')'

    return new FunctionCall id, params

parseArrayAccess = ->
    id = match 'ID'
    match '['
    exp = parseExp()
    match ']'

    return new ArrayAccess id, exp

at = (kind) ->
    if tokens.length is 0
        return false
    else if Array.isArray kind
        return kind.some at
    else
        return kind is tokens[0].kind

lineContains = (kind) ->
    if Array.isArray kind
        return kind.some lineContains
    else
        i = 0
        until tokens[i].kind is 'EOL'
            return true if kind is tokens[i].kind
            i++
        return false

next = ->
    return tokens[1].kind if tokens[1]?

match = (kind) ->
    # console.log tokens
    if Array.isArray kind
        error kind, tokens[0] if not kind.some at
        return match() for k in kind when at(k)
    if tokens.length is 0
        error 'end of file'
        exit(0)
        return
    else if kind is undefined or kind is tokens[0].kind
        # console.log "matched #{kind} with #{JSON.stringify(tokens[0])}"
        return tokens.shift()
    else
        error kind, tokens[0]
