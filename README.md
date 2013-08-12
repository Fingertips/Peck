# Peck

Peck is a concurrent spec framework.

[![Build Status](https://secure.travis-ci.org/Fingertips/Peck.png?branch=master)](http://travis-ci.org/Fingertips/Peck)

## Getting Started

You can install Peck as a gem.

    $ gem install peck

Write a little test.

    require 'peck/flavors/vanilla'

    describe MicroMachine do
      it "drives really fast" do
        MicroMachine.should.drives(:fast)
      end
    end

And enjoy the output.

    ruby -rubygems spec/micro_machine_spec.rb -e ''
    .
    1 spec, 0 failures, finished in 0.0 seconds.

## Why another framework/test library/spec language?

I guess that's something you will have to find out for yourself. For us a spec
framework needs two things: a good way to describe intention of the specs and
flexibility to work with the different types of project we work on.

We really like Bacon and test/spec but we've found that they're to limiting
in some of our projects. Bacon doesn't work really well with Rails and
test/spec needs test/unit, which will be gone in Ruby 1.9.

In some projects we find that we have an enormous amount of little specs which
beg to be run concurrently.

Peck tries to be what we, and maybe you, need it to be. Within reason of
course.

### Peck can be concurrent

Peck has two run modes: serial and concurrent. Right now that's a global
setting for the whole suite.

    Peck.concurrency = 9

Some projects don't allow concurrency because either the code or the test
suite aren't thread safe. We've also found that some suites actually run
slower in threads.

### Peck can host your own spec syntax

When implementing your own spec syntax you only have to add expectations
to a little accessor when they run and raise Peck::Error when something
fails.

    describe "Fish" do
      it "breathes with water" do
        # If you don't like .should, you can write your own assertion
        # DSL
        expects {
          Fish.breathes == water
        }
      end
    end

With a bit of work you could make Peck run your Rspec tests.

### Peck has a pluggable notification system

You can write your own notifiers and register them with Peck's delegate
system.

    class Remotifier < Peck::Notifiers::Base
      def finished
        HTTP.post("https://ci.lan/runs?ran=#{Peck.counter.ran}" +
          "&failures=#{Peck.counter.failed}")
      end
    end
    Remotifier.use

### Peck is extensible

Expect opening up Peck classes you can also extend during runtime with the
`once` callback. This callback is ran when a new context (describe) is
created.

    Peck::Context.once do |context|
      context.class_eval do
        attr_accessor :controller_class

        before do
          @controller = controller_class.new
        end
      emd
    end

Except extension you can also add should macros which defined one or more
specifications:

    class Peck::Should::Specification
      class Disallow < Peck::Should::Proxy
        def get(action)
          context.it("disallows GET on `#{action}'") do
            get action
            response.should == :unauthorized
          end
        end
      end

      def disallow
        Peck::Should::Specification::Disallow.new(context)
      end
    end

    describe CertificatesController, "when accessed by a regular user" do
      before do
        login :regular_user
      end

      should.disallow.get :index
      should.disallow.get :show
    end

### Flavors

You can either require parts of Peck you're using for your test suite or
require an entire flavor. Flavors are pre-built configurations for common
use cases. Right now there are three flavors:

#### Vanilla

    require 'peck/flavors/vanilla'

Reports running specs with dots and ends with a short report.

#### Quiet

    require 'peck/flavors/quiet'

Runs your specs but doesn't report the results. This is useful when testing
Peck itself or your extensions for Peck.

If you want to learn more about testing Peck itself read `examples/preamble.rb`.

In the quiet flavor we do keep a counter, so you could write your own formatter using `Peck.counter`.

##### Documentation

The documentation runner is based on various other ‘documentation’ runners which are generally used for running on CI. This flavor reports the entire label for a spec and colored output. It also shows the runtime for a spec and can report slow specs.

You can configure the report cutoff for slow specs. By default it's configured at 500ms.

    require 'peck/notifiers/documentation'
    Peck::Notifiers::Documentation.runtime_report_cutoff = 20 # milliseconds

## Assertions

Peck is still very much in flux and will probably change a lot in the coming
months. Currently we support a small number of assertions:

  * should, should.not, and should.be
  * should.equal
  * should.raise([exception]) { }
  * should.change([expression]) { }
  * should.satisfy { |object| }

If you want to learn more you're probably best of reading the code
documentation.

## Copying

Peck inherits a lot of ideas, concepts and even some implementation from both
Bacon and MacBacon. Both of these projects have been released under the terms
of an MIT-style license.

Copyright (C) 2007 - 2012 Christian Neukirchen http://purl.org/net/chneukirchen
Copyright (C) 2011 - 2012 Eloy Durán eloy.de.enige@gmail.com
Copyright (C) 2012        Manfred Stienstra, Fingertips <manfred@fngtps.com>

Peck is freely distributable under the terms of an MIT-style license. See COPYING or http://www.opensource.org/licenses/mit-license.php.