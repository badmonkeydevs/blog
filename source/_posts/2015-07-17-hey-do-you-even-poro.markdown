---
layout: post
title: "Hey, Do you even PORO?"
date: 2015-07-17
comments: true
categories: [Software Engineering, Rails, Ruby, Refactoring]
---
Introduces POR objects and demonstrates the surprising benefits of NOT
using ActiveRecord objects
<!-- more -->
## First Things First
I know it's been a couple of weeks since my last post and I owe you an
apology. I've been head-down working on coming up to speed over at
[Monsieur](http://monsieur.co/) in the [ATDC](http://atdc.org/). It's a
really cool space with excellent growth potential. I'm taking over an
pretty well written MVP architecture and will be working hard in the
coming months to take it to true production quality. I've only been at
it for just a couple of weeks now and I'm getting really excited to see
where this product will go.  Right now we're also on the hunt for
another [Senior Web Engineer](http://monsieur.co/careers/) to help me
out in this effort.  Come check us out!

While I'm digging into new code, designing for growth and scale, and
forging new ground with this code base, I thought it'd be a good idea to
share some of my thoughts on code design. Now I'm I know what you're
thinking "Michael, what happened to the next post in the <a
href="https://badmonkeydev.wordpress.com/2015/06/04/how-to-build-your-own-ruby-gem-from-start-to-finish/">How
to Build Your Own Gem series</a>? Well don't worry, I'm still working on
that, I just haven't had much time to work on
[sidekiq-workflow](https://github.com/michaelkelly322/sidekiq-workflow)
recently. You'll see more on that soon.

What I want to share today is a pattern I use quiet often when
refactoring and designing Rails apps. It's very useful for creating
writable, readable, and highly modularized code. It's also a great means
of introducing domain abstraction into your app which will only reveal
more patterns and abstractions that will help the app grow and expand
gracefully.

## POR Objects
So it happens sometimes when rails apps grow that a model takes on too
much responsibility. The file is hundreds of lines long, you see methods
like `reset_spend_cap` and `set_spend_cap`, and new developers have
absolutely no idea where to find the code they need. One of the things
to remember in this situation is that just because we're writing a rails
app, doesn't mean we HAVE to use ActiveRecord for all of our objects.
Plain Old Ruby(POR) objects work _GREAT_ for encapsulating modular code
and shrinking those ginormous models.

To get started let's look at the examples I listed in the last
paragraph. Imagine we have a model file that looks like this:

```ruby
class Account < ActiveRecord::Base
  # Hundreds of lines of CRUFT
  # .
  # .

  def reset_spend_cap
    # stuff
  end

  def set_spend_cap
    # stuff
  end

  # Maybe even hundreds more!!
  # .
  # .
end
```

Without even knowing what these two methods do we can see that they
share something in common. They both deal with something called a "Spend
Cap." This is a concept in the Facebook Marketing API, but could just as
easily be connected to any environment's domain specific functionality.
Now imagine that Facebook decides to add a whole lot more functionality
to their SpendCap model...what do we do? (*Hint: if you say "write the
methods in the Account model!" I'm going to find you
and...ahem...[explain things](http://izquotes.com/quote/299176) to you)

We make a Plain Old Ruby object of course!! Take all those new methods
you'll have to write and move them to their own class like this:

```ruby
# app/models/spend_cap.rb

class SpendCap
  attr_accessor :account

  def initialize(account)
    self.account = account
  end

  def reset
    # stuff, now using the instance variable :account
  end

  def set
    # stuff, now using the instance variable :account
  end
end
```
Yup! It's that easy to create POR objects and house them in Rails. Just
put them in the `models` directory and _DON'T_ inherit the class from
`ActiveRecord::Base`. Plus, now when we want reset a spend cap we can
write the following which is much more readable in terms of the "What
the f*^@ is going on here" perspective:

```ruby
account = Account.find(params[:id])
SpendCap.new(account).reset
```

This is mostly clean code and it gives us a really convenient place to
put business logic and new features related to the SpendCap
functionality. I say "mostly clean" because I don't really like the look
of `SpendCap.new(account).reset` and I *REALLY* hate typing it. The
`new` method chained in there makes it difficult to read clearly and
we're not really creating something new (except the object in memory,
but in the context of our app, we want to work with code that is
syntactically similar to our business domain). But don't worry, I've got
a simple trick up my sleeve that has worked great for me.

## A Nifty Initializer
I mentioned earlier that the constant use of `new` to pass context
information to a ruby helper object is a little misleading and
cumbersome, plus you end up typing `.new(account)` six billion times
each day. I've found that by switching the mental model from "A new
SpendCap Model with account", it is helpful to think like an array of
SpendCaps and say "The SpendCap for this account". And an implementation
that supports this change looks like this:

```ruby
SpendCap[account].reset
```

which in ruby can be easily implemented by adding one extra method to
our SpendCap class:

```ruby
# app/models/spend_cap.rb

class SpendCap
  attr_accessor :account

  def self.[](account)
    self.new(account)
  end

  def initialize(account)
    self.account = account
  end

  def reset
    # stuff, now using the instance variable :account
  end

  def set
    # stuff, now using the instance variable :account
  end
end
```

The method signature `def self.[](account)` creates a class method "[]"
that accepts a parameter. This way when we're writing against our helper
object, we can think of the object in a more efficient way, we reduce
the overall characters needed, and it just plain looks cleaner to me.

## Conclusion
Plain old ruby objects are an extremely powerful way to encapsulate
similar functionality and to introduce some domain abstraction into your
application. It also has the added benefit of tying pieces of code to
terms and concepts used in the problem domain so new developers will
learn things like Facebook's SpendCap and immediately have the
information necessary to look directly at the functionality that
supports it.  _BONUS_ They're super easy to use and should be in every
Rails engineer's toolbox.

The new initializer pattern I introduced is a clean way of working with
these objects and makes working with them downright enjoyable. I highly
recommend that the next time you're facing down a monolithic rails
model, take a look at how you may be able to abstract some of the mess
away into helper objects.


