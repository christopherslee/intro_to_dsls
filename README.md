Introduction to Domain Specific Languages
=========================================

This workshop was originally prepared by [Christopher
Lee](http://github.com/christopherslee) for a [Boston.rb Project
Night](http://bostonrb.org).

The goal if this workshop is to give you a taste of creating your own
Domain Specific Languages (DSL) in Ruby. We'll cover two different
mechanisms for doing so. I hope that it intrigues you enough to discover
your own uses for DSLs to make developing your own application more
efficient, clear, effective, and fun (in my opinion.)

I believe internal DSLs in Ruby are part of the intuitive expressiveness
that draws developers to the language.


__Internal vs External DSLs__

There are two types of DSLs, internal and external. You can think of
internal DSLs as a DSL specfied and executed in your own code as your own code
(e.g. Rake, RSpec, Rails). External DSLs have their own custom syntax and
involve a parser (e.g.  many XML configurations, Puppet). This workshop will cover internal
DSLs in Ruby. [See Martin Fowlers Blog Post on
DSLs](http://www.martinfowler.com/bliki/DomainSpecificLanguage.html)

Workshop Structure
------------------

__Technical Requirements__

You need at Ruby 1.9.x installed on your machine. Although most of the
examples should work, Ruby 1.8.7 has been end of lifed and you should
avoid using it for new projects (and actively work to migrate your
existing projects too!)

__Running specs with rake__

At each part of workshop, you should run the specified rake task to run
the rspec tests to check your progress. In true TDD red/green fashion,
all your tests should be red to start, and you know you are done (or
can confidently refactor) when they all turn green.

You don't need an intimiate knowledge of RSpec for this workshop, although
you will need to be able to read the short specifications to guide your
development.

__Folder Structure__

Starter code will be put in the lib directory. The code you will write
can be found there. The test specs are found in the spec directory and
can be run using rake as mentioned above.

__Getting Answers__

If you get stuck, answers a GitHub gist can be found at the bottom of this
readme. I urge you to try and work through it without looking at the answers,
but they are there if you get stuck. Don't let that discourage you, try to
understand it and see if you can implement your own scenario later!

Part 1: Warmup Stretches
------------------------

RSpec is a ruby testing library with that uses a Behavior Driven Design DSL.

We're not going to get into the syntax too much, but RSpec specs
(specifications, or tests) look like the following:

      describe Customer do
        it "is in good standing if they have a positive balance" do
          customer = Customer.new
          customer.balance = 100
          customer.good_standing?.should be_true
        end
      end

``describe`` and ``it`` are not naturally part of the ruby language.
RSpec uses metaprogramming to bring BDD style testing to ruby. For more,
on creating your own RSpec from scratch, see [Destroy All Software's
Screencast](https://www.destroyallsoftware.com/screencasts/catalog/building-rspec-from-scratch).

In ``lib/part_1/customer.rb`` there is a Customer class. Simply implement the
``good_standing?`` method to make all the specs pass. You can run the specs
for part 1 with:

      > rake spec:part_1

When the tests are green, you are done!

Ok, that wasn't mind blowing, but really we just wanted to test that our
environment setup was working alright. Let's move on.

Part 2: The Builder Pattern
---------------------------

For our next example, let's write a simplified financial simulation that
calculates a credit score. In our simple credit score scenario, the
consumer gets 1 point for every hundred dollars spent (rounded up) when
they pay a bill on time, 1 point for every thousand dollars of credit they
successfully apply for, and loses 2 points for every hundred dolalrs
owed (rounded up) for every bill failed to be pay on time.

We could approach it with modules like we did in the last section, but
in this case, we this time let's try it with a builder pattern. This
time we're aiming for a DSL that looks like this:

      puts CreditScore.simulate do
        pay_bill :electric, 34.12      # +1 point
        pay_bill :gas, 16.54           # +1 point
        pay_bill :cable, 106.41        # +2 points
        awarded_credit 10000.00        # +10 points
        missed_payment :phone, 104.32  # -2 points
      end

      > 12

We're going to use the builder pattern, in which we will use
``CreditSccore.simulate`` to create us a ``Consumer`` object that will
keep track of its own score. But how do we execute our DSL on that
consumer?

You may have guessed it, ``instance_eval`` is what we're going to use.
If you examine the DSL code you've probably noticed that we're
leveraging Ruby blocks, and our DSL is a block that we pass to the
``CreditScore`` class for evaluation. ``instance_eval`` lets us evaluate
that block in the context of our consumer instance. This "trick" is the
majority of the magic behind most Ruby DSLs. We're leveraging Ruby
blocks and ``instance_eval`` to invoke methods on an object.

      class User
        def initialize
          @monthly_rent = 1000
        end
      end

      user = User.new
      user.instance_eval do
        puts self.class
        puts @monthly_rent
      end

      > User
      > 1000

The last part of the puzzle is how we get our block into our builder object.
By default, blocks are anonymous arguments to methods that can be
invoked with ``yield``. But when you want to pass the block to another
method you'll have to attach a binding the block with the ``&`` symbol.
The argument must be the last argument in the method signature and
prefix with the ``&`` symbol.

Let's leverage instance eval and blocks to get our DSL working.
Run the specs for part 2:

      > rake spec:part_2

Now it's your turn. Implement the builder pattern in
``CreditScore.simulate`` and our DSL actions on the ``Consumer`` class.
You'll pass a block to ``simulate`` and use ``instance_eval``.

As always, when the specs are green, you're good to move on.

Part 3: Delayed Execution
-------------------------

You've probably noticed our simulation doesn't really taken months into
account, so let's do that. Now we'll add to our DSL to set up a consumer's
accounts, and then we can specify what bills they paid in a month. If
they didn't pay it, we know they missed it and we can dock points
accordingly. For simplicity, they get 1 point for paying a bill on time,
and lose 2 points for every bill they forget to pay, regardless of the
amount.

One lesson I want you to take away from this is that your DSL doesn't
have to be executed in the order the code is written. You can set up the
accounts first, or you can set them up last. Either way it won't matter.
How will we do that? Blocks are not objects but we can convert them to
Procs. We can store the Procs and invoke them when we are ready.

From our previous lesson we learned that the ``&`` operator binds our
block to an object. When we drop the ``&`` symbol, we are left with a
Proc. If we want a block again? Just add the ``&`` symbol again.

We'll create a more advanced version of our credit score builder to
store our Procs, and then execute them all in our specified order at the end.

      puts AdvancedCreditScore.simulate do
        add_account :electric
        add_account :gas

        # 3 points for paying all bills on time
        month(:january) do
          pay_bill :electric, 34.12
          pay_bill :gas, 16.54
          pay_bill :cable, 106.41
        end

        # +2 points and -2 points for not paying the cable bill
        month(:february) do
          pay_bill :electric, 34.12
          pay_bill :gas, 16.54
        end

        add_account :cable
      end

      > 3


Of course, we'll red/green test our way through this:

      > rake spec:part_3

I've taken the liberty of writing a lot of the boilerplate already.
There are just a few places you need to inject your new ruby-fu.

* In ``lib/part_3/advanced_credit_score.rb``, use ``instance_eval`` to
  invoke the block on the ``AdvancedConsumer`` instance.
* In ``lib/part_3/advanced_consumer.rb`` fill in the implementation of
  the DSL methods.
* In ``lib/part_3/monthly_score.rb`` implement the ``process`` method to
  calculate the monthly score and then return it.

In the famous words of Keanu Reaves, "Whoa."

Conclusion
----------

We've worked through different examples of developing DSLs that should
give you a great base to explore on your own. You can mix in other
techniques to make more powerful DSLs for your own application. In my
recent experience, DSLs can be very useful in testing, especially in
test scenario setup for data and mocks/stubs.

Answers
-------

# [Part 1](https://gist.github.com/christopherslee/6153296)
# [Part 2](https://gist.github.com/christopherslee/6153279)
# [Part 3](https://gist.github.com/christopherslee/6161539)

Credits and additional resources
--------------------------------

I received inspiration and help from the following sources:

* [Metapgrogamming Ruby: Program Like the Ruby
  Pros](http://amzn.to/ZvYh2Q) (amazon affiliate link)
* [Martin Fowler's DSL Guide](http://martinfowler.com/dsl.html)
* [Yonkeltron.com
  Blog](http://yonkeltron.com/blog/2010/05/13/creating-a-ruby-dsl/)
* [Docile](http://ms-ati.github.io/docile/)

Want to contribute?
-------------------

This is GitHub after all. Fork and send me a pull request!

About the Author
----------------

Christopher Lee is a Principal Software Engineer at Technical Team Lead
at ConstantContact. He was the technical co-founder of MobManager.com,
which was acquired by Constant Contact in 2011. He leads the Ruby/Rails
best practice group at ConstantContact.

He has a B.S. Computer Science from the University of Illinois at
Urbana-Champaign, an M.S. Software Engineering w/distinction from DePaul
University, and is an alumnus of Northwestern's Kellogg School of
Management.

Like the course? Have some constructive criticisms? Just want to talk
about programming, craftsmanship, and startups? Feel free to contact me
at: christopher (dot) s (dot) lee (at) gmail (dot) com
