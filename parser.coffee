error = require('./error').parserError

tokens = []

module.exports = (scannerOutput) ->
    tokens = scannerOutput
    program = parseProgram()
    match 'EOF'
    return program

parseProgram = ->
    program = []

    match 'EOL' while at 'EOL'
    loop
        program.push parseDeclaration()
        match 'EOL' while at 'EOL'
        break if at 'EOF'
    return program

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
    if at 'ID'
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
    declarations = []
    loop
        declarations.push parsePropertyDeclaration()
        break if at '}'
    match '}'

parsePropertyDeclaration = ->
    if at ['public', 'private', 'protected']
        accessLevel = match()

    if at 'final'
        final = match 'final'

    declaration = parseDeclaration()
    if at 'where'
        match 'where'
        whereExp = parseExp()

    match 'EOL'

parseFunc = ->
    name = match 'ID'
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

parseParameters = ->
    parameters = []
    while at 'ID'
        name = match 'ID'
        match ':'
        type = parseType()
        match ',' if at ','
        # parameters.push new param here
    return parameters

parseReturns = ->
    returns = []
    if at 'void'
        return match 'void'
    until at ')'
        if at 'ID' and next() is ':'
            match 'ID'
            match ':'
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

parseType = ->
    if at ['bool','int','uint','float']
        return match();
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
            returns.push parseType()
            match ',' if at ','
        match ')'
        # return new function thing
    else if at ['tuple', 'ID']
        type = match()
        if at '('
            match '('
            innertype = parseType()
            match ')'
            # return generic
        # return type

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

parseExpList = ->
    exps = []
    exps.push parseExp()
    while at ','
        match ','
        parseExp()
    return exps

parseBlock = ->
    stmts = []
    match '{'
    match 'EOL'
    while not at '}'
        match 'EOL' while at 'EOL'
        break if at '}'
        stmts.push parseStatment()
        match 'EOL'
    match '}'

parseFuncBlock = ->
    stmts = []
    match '{'
    match 'EOL'
    while not at ['}', 'return']
        match 'EOL' while at 'EOL'
        break if at '}'
        stmts.push parseStatment()
        match 'EOL'
    if at 'return'
        returns = parseReturnStatement()
        match 'EOL'
    match '}'

parseStatment = ->
    if at ['for', 'while', 'if']
        return parseIf() if at 'if'
        return parseForLoop() if at 'for'
        return parseWhileLoop() if at 'while'
        return parseAssignment() if at 'if'
    else
        if next() is ':' or next() is ':='
            return parseDeclaration()
        else if lineContains ['=', '+=', '-=', '*=', '/=', '%=']
            return parseAssignment()
        return parseExp()

parseReturnStatement = ->
    match 'return'
    return parseExp()

parseIf = ->
    match 'if'
    match '('
    condition = parseExp()
    match ')'
    block = parseBlock()

parseForLoop = ->
    match 'for'
    match '('
    innerId = match 'ID'
    match 'in'
    generator = if at 'ID' then match 'ID' else parseRange()
    match ')'
    block = parseBlock()

parseRange = ->
    leftSide = parseExp()
    op = if at '...' then match '...' else match '..<'
    rightSide = parseExp()

parseWhileLoop = ->
    match 'while'
    match '('
    condition = parseExp()
    match '('
    block = parseBlock()

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
        if at ','
            exps.push parseExp()
        # return tuple assign thingy
    else if at ['+=', '-=', '*=', '/=', '%=']
        op = match()
        exp = parseExp()
        # return modify assign thingy
    else
        op = match '='
        exp = parseExp()

parseExp = ->
    leftside = parseExp1()
    while at ['||', '&&']
        operation = if at '||' then match '||' else match '&&'
        rightside = parseExp1()

parseExp1 = ->
    leftside = parseExp2()
    if at ['<', '<=', '==', '!=', '>=', '>']
        operation = getExp1Op()
        rightside = parseExp2()

getExp1Op = ->
    if at '<' then match '<'
    else if at '<=' then match '<='
    else if at '==' then match '=='
    else if at '!=' then match '!='
    else if at '>=' then match '>='
    else match '>'

parseExp2 = ->
    leftside = parseExp3()
    while at ['|', '&', '^']
        operation = getExp2Op()
        rightside = parseExp3()

getExp2Op = ->
    if at '|' then match '|'
    else if at '&' then match '&'
    else if at '^' then match '^'

parseExp3 = ->
    leftside = parseExp4()
    while at ['<<', '>>']
        operation = if at '<<' then match '<<' else match '>>'
        rightside = parseExp4()

parseExp4 = ->
    leftside = parseExp5()
    while at ['+', '-']
        operation = if at '+' then match '+' else match '-'
        rightside = parseExp5()

parseExp5 = ->
    leftside = parseExp6()
    while at ['*', '/', '%']
        operation = getExp5Op()
        rightside = parseExp6()

getExp5Op = ->
    if at '*' then match '*'
    else if at '/' then match '/'
    else if at '%' then match '%'

parseExp6 = ->
    if at ['-', '!']
        operation = if at '-' then match '-' else match '!'
    rightside = parseExp7()

parseExp7 = ->
    if at ['++', '--']
        operation = if at '++' then match '++' else match '--'
    rightside = parseExp8()

parseExp8 = ->
    leftside = parseExp9()
    if at ['++', '--']
        operation = if at '++' then match '++' else match '--'

parseExp9 = ->
    leftside = parseExp10()
    if at '.'
        match '.'
        rightside = parseExp10()
        # dot access here

parseExp10 = ->
    if at 'ID'
        if next() is '('
            parseFuncCall()
        else if next() is '['
            parseArrayAccess()
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
            strprt.push match 'STRPRT'
        # make strprt thingy
    else if at ['INTLIT', 'FLOATLIT', 'STRLIT', 'true', 'false']
        return match()
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

parseArrayAccess = ->
    id = match 'ID'
    match '['
    exp = parseExp()
    match ']'

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
    if tokens.length is 0
        error 'end of file'
        exit(0)
        return
    else if kind is undefined or kind is tokens[0].kind
        # console.log "matched #{kind} with #{JSON.stringify(tokens[0])}"
        return tokens.shift()
    else
        error kind, tokens[0]
