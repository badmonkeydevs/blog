---
layout: post
title: "How to build your own Rails Gem: Start to Finish"
date: 2015-06-04
comments: true
categories: [Software Engineering, Tutorials, Gems, Github, Ruby]
---
Introduces why we'd want to create a Rails Gem and begins a step-by-step
guide to developing an actual open source Gem.

<!-- more -->
## Why build a gem?

So a couple of months ago I wrote a batch workflow manager for BLiNQ's
SMB Solo product.  The point here was that we had a large volume of
background operations to perform when we launched an account.  We did
all these batch operations using [Sidekiq](http://sidekiq.org/) and
[Redis](http://redis.io/).  Some could be paralleled, and some depended
on previous batches to complete.  We couldn't break these down into
large sequential jobs within a single batch because we work with the
Facebook API...not the most reliable partner ever, so we needed to be
smart about retries.

It also allowed us to execute workflows like this using a definition of
sorts and made it possible to define the workflows at run-time.  I
thought this was just an edge case in my niche, but I talked a bit about
the code to other teams and they seemed really interested.  I set out to
make a gem so they could use it over on their products.  The
functionality is easily generalized and the added level of abstraction
needed to model workflows like these is valuable.

![complex-workflows](https://lh4.googleusercontent.com/A9DsdHvVON8hgSB4XkEWDvcV_8UPz79Hd7qUp2_HxzC2M2WxtjCF-YWpbpqIKqHaXDYhFWyBmbkzyddg-QyHL1RBGUFoXJ72uiVehNzpsRQzz66NKyvBviLa)

So I started by following the guides over at
[RubyGems](http://guides.rubygems.org/make-your-own-gem/) and pushed an
empty module up to my [RubyGems
Profile](https://rubygems.org/profiles/thebadmonkeydev).  If you go to
my profile you can see that I've screwed around with the verioning
pattern and some basic tests and shell methods over the last month, but
not much else.  There's still no real functionality.However, since May
18th, it's been downloaded more than 250 times!!

## Why build a gem out in public like this?

Since I was already planning a tutorial post about creating a new rails
gem, I decided that since there is obviously demand for this kind of
functionality, why not build it publicly and let people learn from a gem
that is actually useful versus the whole "Hello World" approach of
online guides.

Most of us learn by doing and it can be difficult to get off the ground
with a new topic if you don't have the opportunity to work on something
that's not trivial.  In response to these far-too-simple guides around
the interwebz, I'm going to build this gem step by step here on my blog
so that you can build actual experience with gem development.  I only
ask that if you do follow along and push your gem out, please change the
name so there's no confusion with mine as I plan to continue maintaining
it after this tutorial is over.

## So...

Over the next several weeks I'm going to discuss in depth my experience
developing this gem, which I will be calling 'sidekiq-workflow'.  We'll
walk through the process of creating the initial gem itself to the final
touches implementing actual workflow functionality together.  I will be
loosely following a [Test-Driven Development
(TDD)](http://en.wikipedia.org/wiki/Test-driven_development) approach.
 However, I will be developing this in a rapid time frame and will
certainly stray from TDD in the strictest sense...you should get a feel
for how I develop day-to-day.  I try to strike a balance between
following a strict uniform process and the real-world down and dirty
approach that we all use but don't talk about.

I'm also going to be using some very popular tools for open source
projects along the way and will walk through setting them up for
sidekiq-workflow:
[Github](https://github.com)
[TravisCI](https://travis-ci.org)
[CodeClimate](https://codeclimate.com)
<table>
<tbody>
<tr>
<th>Let's Get Started</th>
</tr>
<tr>
<td><a
href="https://badmonkeydev.wordpress.com/2015/06/09/how-to-build-your-own-rails-gem-part-1/">Creating
a Basic Gem and Setting Up Github</a>
</td>
</tr>
<tr>
<td>What we're building and first tests <small
style="float:right;">Coming Soon</small></td>
</tr>
<tr>
<td>Core Features and Using CodeClimate <small
style="float:right;">Coming Soon</small></td>
</tr>
<tr>
<td>Finishing Touches and Publishing a Github Release <small
style="float:right;">Coming Soon</small></td>
</tr>
</tbody>
</table>

