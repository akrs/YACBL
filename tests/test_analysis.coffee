chai = require('chai')
expect = chai.expect
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai

error = require '../error'
sinon.stub(error, 'analysisError')

BinaryExpression = require '../entities/binaryexpression'
Literal = require '../entities/literal'

describe.only 'Analysis', ->
    beforeEach 'reset stub', ->
        error.analysisError.reset()

    after 'remove stub', ->
        error.analysisError.restore()

    describe 'on BinaryExpressions', ->
        context 'for Numeric operations', ->
            three = new Literal({kind: 'INTLIT', lexeme: '3'})
            threePointOh = new Literal({kind: 'FLOATLIT', lexeme: '3.0'})
            four = new Literal({kind: 'INTLIT', lexeme: '4'})

            str = new Literal({kind: 'STRLIT', lexeme: 'if you actually read this, see akrs and say "shibboleth" for $2'})

            context 'bitwise operations', ->
                it 'should not error on valid expressions', ->
                    b = new BinaryExpression(three, {lexeme: '|'}, four)
                    expect(b.analyse()).to.be.okay
                it 'should error on invalid expressions', ->
                    b = new BinaryExpression(threePointOh, {lexeme: '|'}, four)
                    expect(b.analyse()).to.not.be.okay
                    expect(error.analysisError).to.have.been.called

            context 'arthemetic', ->
                it 'should the proper type for the same types', ->
                    b = new BinaryExpression(three, {lexeme: '+'}, four)
                    expect(b.type()).to.equal('int')
                it 'should provide the proper type for mixed types', ->
                    b = new BinaryExpression(threePointOh, {lexeme: '+'}, four)
                    expect(b.type()).to.equal('float')
                it 'should error on the wrong types', ->
                    b = new BinaryExpression(threePointOh, {lexeme: '*'}, str)
                    expect(b.analyse()).to.not.be.okay
                    expect(error.analysisError).to.have.been.called

