chai = require('chai')
expect = chai.expect
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai

error = require '../error'
sinon.stub(error, 'parserError');

parse = require '../parser'

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
                expect(program.declarations[0].name.lexeme).to.eql('main')
                expect(program.declarations[0].block.statements[0].id.lexeme).to.eql('print')

        context.skip 'parsing classes', ->
            it 'should parse animals', ->
                program = parse require('./test_files/parser/animals')[..]
                expect(program.declarations).to.have.length(5)


