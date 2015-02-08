expect = require('chai').expect
foo = 'bar'
beverages = { tea: [ 'chai', 'matcha', 'oolong' ] };

describe 'tests', ->
    describe 'foo', ->
        it 'is a string', ->
            expect(foo).to.be.a('string')
        it 'is bar', ->
            expect(foo).to.equal('bar')
        it 'has length 3', ->
            expect(foo).to.have.length(3)

    describe 'beverages', ->
        it 'contains tea', ->
            expect(beverages).to.have.property('tea')
        it 'has three teas', ->
            expect(beverages.tea).to.have.length(3)
