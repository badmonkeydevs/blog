---
layout: post
title: "Model-less Controllers in Ruby on Rails"
date: 2016-01-03
comments: true
categories: [Software Engineering, Rails, Ruby, Refactoring]
---
<em><a href="https://badmonkeydev.wordpress.com/category/craft">The Bad Monkey Craft</a>: This is part of a series on software engineering
craft.  The knowledge that takes us from factual tutorials and
walkthroughs to truly elegant applications.  Each article in this series
is intended to inspire thought and conversation into the different ways
we use our web frameworks and the pieces that make them up.  Read along
and join the conversation about the craft of writing web
applications!</em>
<!-- more -->
So you're fresh out of a code bootcamp like <a
href="https://generalassemb.ly/">General Assembly</a> or <a
href="https://www.theironyard.com/">The Iron Yard</a>; Or maybe you
spent some hard earned hours at the ole' google, cranking out tutorials
and examples.  What you know now is that Ruby on Rails is an MVC web app
framework and you make routes that point to controllers with actions
that represent the basic CRUD (<strong>C</strong>reate,
<strong>R</strong>ead, <strong>U</strong>pdate, <strong>D</strong>elete)
for a model. All of this is true.  Except for one small assumption...In
real-world applications, it is not always so cut and dry.  You start
collecting more and more actions in your controller to marshal different
resources, preform some kind of processing, or render non-standard
views.

If you keep up with this long enough, you'll find your controllers
getting fat, your list of actions getting longer and longer while your
text editor struggles to even parse the file. <strong>Fear Not
Adventurer!</strong> There's a relatively simple way to design these
creeping complexities so that your project is still maintainable and
understandable...I call this approach <em>Model-less Controllers</em>.

<h2>What are Model-less Controllers?</h2>

<em>"Model-less Controller"</em> is the name I've given to Rails
controllers that don't represent a clear-cut rails model.  They instead
represent a conceptual resource that can be just about anything.  There
are a few different types including static controllers, composite
controllers, and aggregate controllers.  We'll see some examples of
these in just a minute, but the easiest way to envision this concept is
that they are

<blockquote>
  Model-less Controllers are controllers that do not tie one-to-one with
  a resource in your system.
</blockquote>

<h3>Not Your Average Controllers</h3>

"But, Michael, if there's a view or a data object behind my controller
it technically has a resource!?" you might be asking.  Well, that's
true.  I'm speaking to those in the community who are just learning
Ruby on Rails from a tutorial like <a
href="https://www.railstutorial.org/">Michael Hartle's</a> and are
looking to take their solution design to a higher level.  Composite or
<em>Model-less</em> controllers are those that don't follow the RoR
way.  They can't be generated as a scaffold with <code>rails
generate</code>.

There are a couple of different types of model-less controllers
including composite, aggregate, and static controllers.  Here are a
few examples:

<h4>Static Pages a la <a href="https://www.railstutorial.org/">Michael Hartle's Rails Tutorial</a></h4>

Mike uses what I call "static" controllers pretty early in his
tutorial when he's adding static pages to the example app.  These
controllers are meant primarily as a shim between the router and the
static views you want at an endpoint.  Most if any logic in these
controllers is going to be related to localization or time-based
output.

<h4>Devise's Registration and Session Controllers</h4>

<a href="https://github.com/plataformatec/devise">Devise</a> provides
a fairly simple way to add authentication to a RoR app.  A few
commands and <strong>BOOM</strong> you've got database authentication,
or OAuth integration right out of the gate...it even includes a ton of
helpful routes like <code>/users/registration/new</code> and
<code>users/session/new</code> that setup user signup and user login
to work with <a
href="https://github.com/plataformatec/devise">Devise</a>'s internal
controllers.

If you've ever extended any of these to customize the login behavior
or to add more detailed logic to user signup, then you've worked with
<em>Composite Controllers</em>.  These controllers loosely represent a
resource in your app.  However, it is not one that ties directly to a
model.  You'll find no <code>Session</code> or
<code>Registration</code> models.  These are composite concepts that
relate to a type of <code>User</code> model interaction.

<h4>Dashboards</h4>

Modern web applications almost always require some kind of dashboard
functionality.  Whether that is an admin panel to get at-a-glance
information about your sales application, or a KPI/analytics page for
your CRM tool, it is still a page dedicated to presenting information
that intentionally cross-cuts the entire platform.  You'll be reading
from four tables and running aggregation mathematics to be cached and
retrieved by the page.

With a complicated feature like a dashboard, it is almost certain that
you'll find what I call <em>Aggregate Controllers</em> behind the
scenes.  These controllers are responsible for the marshaling of large
amount of data, spread seemingly at random across a massive database.
You'll also often see controllers like these interacting with Redis or
Memcache to access data that has been aggregated by a background
process.

<h3>How Do I Implement an Aggregate/Composite Controller?</h3>

So here's the thing.  You don't.  These <em>special</em> types of
controllers are nothing more than a standard Rails controller, just
without a matching model.  The difference is in how you use them and
the logic that lives within them (or the objects that they in turn
delegate action to).  My intent here is to point out that there are
many different ways to think about controllers and we can't let
ourselves get stuck creating entire scaffolds for features that may
have been better served by compiling or aggregating data already
available into it's own controller.

You'll also find that by thinking about your controllers as more than
just faceplates for your models, you can more easily refactor your
existing logic into a wider assortment of controllers, isolating logic
into conceptual units is never a bad thing ;).

<h2>What about my API and RESTfulness?</h2>

In talking about this topic with other engineers I've found one
question pretty common.

<blockquote>
  What about RESTful APIs?  Shouldn't they be resource-backed?
</blockquote>

And the answer to this is "Yes".  However, you'd be surprised how
many APIs are out there that present RESTful data (data that can be
created, read, updated, and deleted) that is not in fact backed by a
specific model that matches the structure of your RESTful resource.
Think about the example I gave above about <a
href="https://github.com/plataformatec/devise">Devise</a>'s
controller structure.  They work with a RESTful resource like a
<code>Session</code>.  A session can be created (logging in), read
(current_user specific info), updated (storing of session related
values like page visits or temporary objects), and deleted (logging
out).  It is a viable RESTful resource, but there is again no
persisted <code>Session</code> object in our application (and I'm
not referring to the <code>session</code> hash in Rails, that is
only a key-value store that represents the so-called fields of our
conceptual <code>Session</code>.

<h2>Conclusion</h2>

I hope I've shown you some good examples of other ways of thinking
about your Rails controllers.  Model-less controllers are a great
way to decouple the data representation used by your application and
the data representation used by your client or users.  This kind of
benefit allows your application to adapt and adjust technically
while maintaining a consistent structure in the eyes of the people
using it.

Do you dis/agree with me?  Leave a comment below or hit me up <a
href="https://twitter.com/thebadmonkeydev">@thebadmonkeydev</a> and
let me know what you think!

