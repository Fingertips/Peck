# encoding: utf-8

require 'preamble'

describe 'change' do
  it 'tracks a single change' do
    a = 1
    lambda do
      a += 1
    end.should.change('a', +1)
  end

  it 'tracks multiple changes' do
    a = 1
    b = 4
    lambda do
      a += 1
      b -= 1
    end.should.change('a', +1, 'b', -1)
  end
end

# We need to specs to run now, not at exit because we want to inspect
# the outcomes.

Peck.run

require 'assert'

assert(Peck.counter.ran == 2,
  "Expected two specifications to have been run")

assert(Peck.counter.passed == 2,
  "Expected five specification to have passed")

