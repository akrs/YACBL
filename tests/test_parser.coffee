chai = require('chai')
expect = chai.expect
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai

error = require '../error'
sinon.stub(error, 'parserError');

parse = require '../parser'

ArrayAccess = require '../entities/arrayaccess'
Assignment = require '../entities/assign'
BinaryExpression = require '../entities/binaryexpression'
Block = require '../entities/block'
ClassDec = require '../entities/classdec'
ForLoop = require '../entities/for'
Func = require '../entities/func'
FunctionBlock = require '../entities/functionblock'
FunctionCall = require '../entities/functioncall'
GenericType = require '../entities/generictype'
IfStatement = require '../entities/if'
Literal = require '../entities/literal'
Parameter = require '../entities/parameter'
PrimitiveDeclaration = require '../entities/primitivedeclaration'
Program = require '../entities/program'
PropDec = require '../entities/propdec'
ReturnStatement = require '../entities/returnstatement'
StringPart = require '../entities/stringpart'
TupleAssignment = require '../entities/tupleassignment'
TupleDeclaration = require '../entities/tupledec'
Type = require '../entities/type'
UnaryExpression = require '../entities/unaryexpression'
VarRef = require '../entities/varref'
WhileLoop = require '../entities/while'

describe 'Parser', ->
    after 'remove stub', ->
        error.parserError.restore()

    context 'Syntax checking', ->
        context 'should not error on valid programs', ->
            beforeEach 'reset stub', ->
                error.parserError.reset()
            it 'should parse hello world', ->
                parse require('./test_files/parser/hello_world')[..]
                expect(error.parserError).to.not.have.been.called
            it 'should parse class declarations', ->
                parse require './test_files/parser/classes'
                expect(error.parserError).to.not.have.been.called

    context 'Parsing programs', ->
        context 'parsing different declarations', ->
            # because a program is a series of declarations, we test each here
            context 'parsing single declarations', ->
                context 'without types', ->
                    context 'with right hand literals', ->
                        it 'with numbers'
                        it 'with strings'
                        it 'with interpolated strings'
                    context 'with right hand expressions', ->
                        it 'with function calls'
                        it 'with arithmetic'
                context 'with types', ->
                    context 'with right hand literals', ->
                        it 'with numbers'
                        it 'with strings'
                        it 'with interpolated strings'
                    context 'with right hand expressions', ->
                        it 'with function calls'
                        it 'with arithmetic'

        context 'parsing simple programs', ->
            it 'should parse hello world', ->
                program = parse require('./test_files/parser/hello_world')[..]
                expect(program.declarations).to.have.length(1)
                console.log("hello")
                console.log(JSON.stringify(program.declarations[0].name))
                expect(program.declarations[0].id).to.eql(new VarRef { "kind": "main", "lexeme": "main", "line": 1, "col": 1 })
                console.log(JSON.stringify(program.declarations[0].block.statements[0]))
                expect(program.declarations[0].block.statements[0].id).to.eql(new VarRef { "kind": "ID", "lexeme": "print", "line": 2, "col": 5 })

            it 'should parse triple'
            # other simple programs

        context 'parsing classes', ->
            it 'should parse animals'
            # other class stuff
