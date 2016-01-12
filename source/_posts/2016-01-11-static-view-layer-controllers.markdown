---
layout: post
title: "Static/View Layer Controllers"
date: 2016-01-11
comments: true
categories: [Craft, Software Engineer, Junior Developer, Rails, Ruby]
---

<em><a href="https://badmonkeydev.wordpress.com/category/craft">The BadMonkey Craft</a>: This is part of a series on software engineering
craft.  The knowledge that takes us from factual tutorials and
walkthroughs to truly elegant applications.  In this article we're
diving deeper into what a View Layer Controller is and how it can be
leveraged to simplify API development.</em>
<!-- more -->
Last week I published a post on <a
href="https://badmonkeydev.wordpress.com/2016/01/03/model-less-controllers-in-ruby-on-rails/">Model-less Controllers in Rails</a> that talked about some of the different ways to
think about controller design in Ruby on Rails.  This week we're going
to dive further into one of those types, the <strong>Static</strong> or
<strong>View Layer Controller</strong>.  So I mentioned in my <a
href="https://badmonkeydev.wordpress.com/2016/01/03/model-less-controllers-in-ruby-on-rails/">previous post</a> that many of you have already seen a pretty standard example of
this kind of controller in <a
href="https://www.railstutorial.org/">Michael Hartle's Tutorial</a> or
similar.  It's used to handle requests for static pages like
<code>/home</code> or <code>/about</code> in a normal website or SaaS
product.  A controller like this will take the form:

```ruby
class StaticPagesController &amp;amp;lt; ApplicationController
  def home
  end

  def about
  end

  def contact
  end
end
```

Where each action corresponds to a specific page in a static website.
There can even be more controllers like this to handle a complex site
structure...all of which are not backed by any specific model (though I
suppose one could argue that the page itself becomes the "Model" in the
MVC concept.  The point is that we look outside the constriction
ActiveRecord model/controller/view.

I'm going to try and push the envelope a little further and talk about
how this concept applies to API controllers. I'm going to follow an a
real world feature that I had to implement that turned out to be best
implemented in this way.  So first a little background.

<h2>Background</h2>

At <a href="http://monsieur.co/">Monsieur</a> we have several backend
APIs that are used by all of our different client platforms (the
machines themselves, our <a
href="https://itunes.apple.com/us/app/monsieur-mobile/id963506264?mt=8">mobile app</a> and our front-end Ember.js application.  All of which are used
by a different kind of user.  In adding authorization and authentication
to this API, we discovered that our mobile users needed access to a
subset of information about machines, their locations, and what they
were pouring that is not supposed to be accessed across organization
boundaries...except in the case of mobile app so that users can discover
machines nearby.  This information was behind both <a
href="https://github.com/plataformatec/devise">Devise</a> and <a
href="https://github.com/elabs/pundit">Pundit</a> so the user wasn't
passing any of the <code>before_filter</code> checks.

We struggled for a while trying to adjust our <a
href="https://github.com/elabs/pundit">Pundit</a> policies to allow for
all the different interactions that we were expecting these routes and
controllers to handle.  It finally became obvious that our issue was too
complex to handle with just adding another level of <code>if</code>
statements.  We needed to rethink the structure of these requests, not
the logic.

<h2>First, The Controller in Question</h2>

So initially, our mobile app would access a route like
<code>/locations</code> and would be routed to the
<code>LocationsController#index</code> action.  Tt would provide a list
of locations that it would then present to the user on a map (letting
them locate nearby machines).  But as the platform grew we decided to
tenant the data and allow our users to build menus and drink recipes,
all stored under their organization that could get statistics about the
machines they had deployed in different locations. So this endpoint now
needs to serve the purpose of allowing a user to see <em>THEIR</em>
locations.  Not all of them in the database.  But...public users still
needed to be able to access all of them.  We have two different contexts
under which we want to use the same resource's controller.  This is
where you get into trouble.  But don't loose hope weary traveler,
there's a easy technique to simplify this whole mess.

<h2>Refactoring into a View Layer Controller</h2>

We split our controllers in two along the context lines (public users
and organization users) instead along resource lines (the
<code>Location</code> model).  This means creating a new controller to
handle the public user interaction under a new path,
<code>/public/locations</code>.  And with Rails, doing something like
this is pretty easy.  First, create your new route by modifying your
<code>config/routes.rb</code> file.

```ruby
get 'public/locations' => 'public/locations#index'
```

We're providing a new url for the mobile app to use.  It will be
designed and iterated on from the perspective of a public mobile app
user.  I'm going to put this new controller in a Public module so that
it is clear what the context is when developing on the controller. So
create <code>app/controllers/public/locations_controller.rb</code> and
we'll fill it like this:

```ruby
class Public::LocationsController &amp;amp;lt; ApplicationController
  skip_before_filter :authenticate_user!

  def index
    locations = Location.all # Or some kind of 'near'; logic
    render json: locations, each_serializer: PublicLocationSerializer
  end
end
```

So now, we won't be accessing Locations through a Pundit scope or
anything like that.  We're accessing them directly...we're going to
limit the data that is returned here using the serializer.  Only
serializing data that is public consumable like GPS location, location
name, the machines in this location, etc.  To do this, all we have to do
is create a <code>PublicLocationSerializer</code> that only contains the
appropriate fields for a public user.

The original <code>LocationsController</code> is free to serve our
internal users their locations scoped by organization and authorization
role. We're free to develop and iterate from both perspective now
without impacting the other.  It's actually become a joy to get a new
feature request from a mobile user.  Because that controller is
segregated and easy to work with.

<h2>Conclusion</h2>

So what I showed you here is a slight simplification of a real world
issue I dealt with not too long ago.  I ended up creating two different
controllers to represent the <code>Location</code> resource in my API.
Each was designed under a different use-case and each represents a
different <em>view</em> of our data.  Now if there is an issue with the
internal endpoint, my public users aren't affected.  Changes to
authorization scheme don't prevent our mobile users from accessing
nearby machines.  And to boot, both controllers are pretty skinny and
easy to navigate.
