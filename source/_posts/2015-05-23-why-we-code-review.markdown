---
layout: post
title: "Why We Code Review"
date: 2015-05-23
comments: true
categories: [Software Engineering, Github, Code Review]
---
At this year's Railsconf in Atlanta, I got the pleasure of sitting in on
Derek Prior's [Cultivating a Code Review Culture](https://www.youtube.com/watch?v=PJjmw9TRB7s&amp;index=16&amp;list=PLE7tQUdRKcybf82pLlMnPZjAMMMV5DJsK).
 For those of us who use Github's Pull Request functionality on a daily
basis, Derek hit some pretty good points.  I used to *HATE* doing code
reviews.  <!-- more -->I thought they were tedious and unhelpful in identifying
actual bugs.  But as he points out, Code Reviews can be a prime location
to learn each and every day.  This talk has changed the working
agreement in my current team and has done wonders for my product
knowledge in just a few short weeks.  In the lecture he talks about
three main aspects of code reviews:

- Why do we do them?

- How can we better craft the summaries we write for reviewers?

- How can we better review our peers' code?

## Why we do Code Reviews

Code reviews have long been thought of as a way to reduce bugs.
 However, several studies (detailed in Derek's lecture) show that it is
relatively ineffective at finding them.  But what if we looked at code
reviews in a different light?  What if we thought about them in terms of
the value they hold for other engineers on the team?

Code reviews, done right, can communicate information about how the
product works as well as valuable engineering knowledge both from and to
the reviewer.

## How can we craft our code review requests to support this change in
attitude

Over at BLiNQ we've been using Github's Pull Request feature to manage
our code reviews.  The process goes like this...

1. Develop a new feature on a its own branch

2. Push up to Github and create a Pull Request (PR)

3. Write a description of your change

4. Get it reviewed and merged into master

This looks like pretty much every Github code review.  But the real key
here is in step #3.  Our Pull Requests looked like this:

<a
href="https://badmonkeydev.files.wordpress.com/2015/05/screen-shot-2015-05-19-at-9-13-25-pm1.png"><img
class="alignnone size-full wp-image-64"
src="https://badmonkeydev.files.wordpress.com/2015/05/screen-shot-2015-05-19-at-9-13-25-pm1.png"
alt="Screen Shot 2015-05-19 at 9.13.25 PM" width="660" height="127"
/></a>

You can tell from the message that a web request was being constructed
with too many IDs in the query string and you can see that I some how,
some way resolved it oh and I decided to include the card number from
our Rally project.  But it hasn't helped you to understand at all why
I'm making this change, how I decided to accomplish it, or why I decided
against another perfectly reasonable approach.  What if this Pull
Request looked more like this one:

<a
href="https://badmonkeydev.files.wordpress.com/2015/05/screen-shot-2015-05-19-at-9-29-48-pm.png"><img
class="alignnone size-full wp-image-58"
src="https://badmonkeydev.files.wordpress.com/2015/05/screen-shot-2015-05-19-at-9-29-48-pm.png"
alt="Screen Shot 2015-05-19 at 9.29.48 PM" width="660" height="941"
/></a>

Don't you feel like you know what's going on here?  I could have simply
said "removed explicit status parameter".  However, written out into
three basic sections:

1. Problem

2. Cause

3. Solution

The reviewer learns what you've learned while working on the feature or
defect.  Along with you guys...dropped a little Facebook Marketing API
knowledge on you ;)

## How can we better review code

So earlier in this post I made the blasphemous statement that code
reviews don't actually help reduce the number of bugs that make it out
to production.  I mean sure, every once and a while someone notices a
possible off-by-one or null-pointer mistake, but ultimately in this new
world of TDD, that's what tests are intended to resolve.  What we're
here to do it become better engineers which means a whole lot more than
simply catching bugs.

When you're reviewing code, it's important to bring your style and
experience to the table, regardless of experience level.  I encourage
the entire team to look at pull requests, even the juniors because every
team member has a unique perspective on how a feature should be
implemented and they will quite often think of something you missed.

## Conclusion

When it comes to code reviews, it's time we put down the old "fix the
bugs" mantra and realize the actual benefits they have.  As long as we
approach them with respect and an open mind, code reviews can be one of
the most powerful tools in an engineers arsenal.
