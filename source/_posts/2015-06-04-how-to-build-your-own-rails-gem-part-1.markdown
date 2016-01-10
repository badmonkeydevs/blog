---
layout: post
title: "How to build your own Rails Gem: Part 1 - The Gem"
date: 2015-06-09
comments: true
categories: [Software Engineering, Tutorials, Gems, Github, Rails, Ruby]
---
A walkthrough of  the process of creating a basic gem structure and gem
development workflow.
<!-- more -->
## Creating a Basic Gem and Setting Up Github

This week we're going to get our project setup and create our basic
skeleton which will act as the foundation of sidekiq-workflow. This is
probably going to be a long post, but you are welcome to skip any
sections with which you're familiar.

## Let's Get Started
- [The Generator and Gem Skeleton](#skeleton)
- [The Gemspec](#gemspec)
- [The Workflow Module](#module)
- [Getting the Gem Into Source Control](#source-control)
- [Deploying the Gem to RubyGems](#rubygems)
- [Conclusion](#conclusion)

<a name="skeleton"></a>
### The Generator and Gem Skeleton
Bundler is the gold standard for gem packaging and management. If you've
done any rails development (and I sincerely hope you have, it's great
fun!) you're familiar with the project's `Gemfile` which is used by
bundler when it installs dependencies. Luckily for us, it also includes
a generator for a skeleton gem. The generator has some special magic
sauce based on your gem's name. You can find a full reference on [How to
Name Your Gem](http://guides.rubygems.org/name-your-gem/) over in the
RubyGems guides. In our case, I'm using `sidekiq-workflow` because the
`-` between `sidekiq` and `workflow` indicates that `sidekiq` is the
name of my top level module and `workflow` is a sub-module. With this I
can write syntax like:

```ruby
# run a workflow with parameters
Sidekiq::Workflow.run(workflow_definition, *args)

# or include sub-classes like this later
Sidekiq::Workflow::Monitor.new()
```

This keeps our gem in the same namespace as Sidekiq itself and makes for
a rather clean gem API. The generator command looks like this:
```bash
bundle gem sidekiq-workflow
```

Bundler will create a folder in the current directory named
`sidekiq-workflow` and then generate all the necessary gem files within
it. You should see output similar to:

```bash
Code of conduct enabled in config
MIT License enabled in config
create sidekiq-workflow/Gemfile
create sidekiq-workflow/.gitignore
create sidekiq-workflow/lib/sidekiq/workflow.rb
create sidekiq-workflow/lib/sidekiq/workflow/version.rb
create sidekiq-workflow/sidekiq-workflow.gemspec
create sidekiq-workflow/Rakefile
create sidekiq-workflow/README.md
create sidekiq-workflow/bin/console
create sidekiq-workflow/bin/setup
create sidekiq-workflow/CODE_OF_CONDUCT.md
create sidekiq-workflow/LICENSE.txt
create sidekiq-workflow/.travis.yml
create sidekiq-workflow/.rspec
create sidekiq-workflow/spec/spec_helper.rb
create sidekiq-workflow/spec/sidekiq/workflow_spec.rb
Initializing git repo in /home/michael/Data/gems/sidekiq-workflow
```

You can see from the output that this command has generated a lot of
files for your gem. Most of these are standard like `.gitignore`,
`README.md`, `LICENSE.txt`, familiar rspec testing setup, etc. However,
when it comes to the actual gem files, there are two that are the most
important. They are `sidekiq-workflow.gemspec` and
`lib/sidekiq/workflow.rb`. I'll discuss both in detail below.

<a name="gemspec"></a>
#### The Gemspec
The `gemspec` file is the main location for the configuration of our
gem's metadata. This is where we set fancy things like our gem name,
version, summary/description, gem dependecies, etc. The `gemspec` file
for sidekiq-workflow looks like this:

```ruby
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/workflow/version'

Gem::Specification.new do |spec|
  spec.name          = 'sidekiq-workflow'
  spec.version       = Sidekiq::Workflow::VERSION
  spec.authors       = ['Michael Kelly']
  spec.email         = ['michaelkelly322@gmail.com']

  spec.summary       = 'Complex workflow management in
Sidekiq'
  spec.description   = 'Allows the execution of mixed parallel and
sequential workflows.  A workflow can be defined at runtime and executed
with full sidekiq integration.'
  spec.homepage      =
'https://github.com/michaelkelly322/sidekiq-workflow'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split('\x0').reject {
|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f)
}
  spec.require_paths = ['lib']

  spec.required_ruby_version = '1.9'
  spec.add_development_dependency 'bundler', '~<
1.10'
  spec.add_development_dependency 'rake', '~<
10.0'
  spec.add_development_dependency 'rspec', '~<
3.2'
end
```

There's a lot of boiler plate there that we don't really have the screen
space to explore in this tutorial (I plan on posting a dedicated post on
the elements of a `gemspec` file in the near future). The default
configuration is pretty good for now (except of course the things that
are custom to our gem like name and description). What is important to
note is that it is extremely bad form to use the `Gemfile` in our gem to
manage dependecies. Instead, we use the `gemspec` file instead. Notice
the section that starts with the line `spec.add_development_dependency
"bundler", "~> 1.10"`? This adds a development dependency on bundler.
Development dependencies are gems that are used during the development
of our gem, but not to be included in the actual packaged gem (things
like testing, building, etc.). To add runtime dependencies you would use
`spec.add_runtime_dependency 'gem_name', '1.2.3'` which tells the spec
that the gem is to be included as a dependency when the gem is packaged
for release (meaning our users will need to have these gems to run
ours).

This structure is similar to groups in a standard `Gemfile`. However,
the `Gemfile` itself will be used by our users when installing
dependencies and their configuration has to be passed through the gem
packaging process to be setup properly. That is why we include them in
the `gemspec` and not directly in the `Gemfile`.
<a name="module"></a>
#### The Workflow Module
The other major file involved with gem development is the gem's main
module file. It can be found in the `lib/` parent folder that bundler
created. In our case, it is located at `lib/sidekiq/workflow.rb` and if
you haven't modified it yet should look like:

```ruby
require 'sidekiq/workflow/version'

module Sidekiq
  module Workflow
    # Your code goes here...
  end
end
```

This is essentially the entry point of your gem. Remember earlier when I
talked about syntax like `Sidekiq::Workflow.run()`? Well here's where
we'd implement a run method, but more on that in a later post ;)

<a name="source-control"></a>
### Getting the Gem Into Source Control

Before we commit any of our code above, we need to make one modification
to our `.gitignore` file
```
*.gem
```
This way we don't commit our actual bundled gem after we've built it for
deployment to RubyGems. A flaw in the generator in my opinion because
the standard practice is to bundle the gem from within your projects
directory. Therefore, we shouldn't be committing specific (read
versioned) `.gem` files. The default should be to exclude them.

I also like to start my gem development with an obviously not
production-ready version. Bundler's generator initialized a file called
`lib/sidekiq/workflow/version.rb`. If you noticed above, our `gemspec`
file references this files module when setting the gem version (makes it
easier to script bumping the version number. The default version is
`0.1.0`. But based on my experience with semantic versioning, it is best
to label all MVP work as a hotfix/patch version *without* any major or
minor version. This shows that the product is moving forward and is
easily tracked throughout development, but is obvious to a user that the
gem is only wee babe.

```ruby
module Sidekiq
  module Workflow
    VERSION = '0.0.1';
  end
end
```

Based on this, sidekiq-workflow has an initial version of `0.0.1`. We'll
talk more about this below when we discuss deploying our gem to
[RubyGems](https://rubygems.org/).

There are many other things we could customize as part of this initial
setup. For instance, there is some `TODO` text in the `README.md` file
by default (this file is shown on the Github repository's front page)
that we could replace with actual readme information. But for now we
should be ready to commit our work and get it into source control.
Commit your changes with something like:

```bash
git commit -am 'Creates initial gem skeleton'
```

Now all that's left is to add our remote Github repository to our local
git remotes as `origin` and push our code so that it is safely in the
cloud.

```bash
git remote add origin
git@github.com:michaelkelly322/sidekiq-workflow.git
git push origin master
```

We now have an open source gem ready to start development up on Github.
Take a look at the actual [sidekiq-workflow repository](https://github.com/michaelkelly322/sidekiq-workflow)! Now
let's work on making it available to developers around the world.

<a name="rubygems"></a>
### Deploying the Gem to RubyGems
Luckily, the nice folks over at [RubyGems](http://rubygems.org) have
made the process of making a gem publically available to anyone with a
`Gemfile` and half a mind to type `gem 'sidekiq-workflow'` *EXTREMELY*
easy. It is a two step process that includes building the gem and
deploying the gem to RubyGems' servers.

Building the gem is a simple as running the following command:

```bash
gem build sidekiq-workflow.gemspec
```

This will build our modules into our gem based on the gemspec and saved
it to a `.gem` file. The output should be something like if everything
went according to plan:

```bash
  Successfully built RubyGem
  Name: sidekiq-workflow
  Version: 0.0.1
  File: sidekiq-workflow-0.0.1.gem
```

The final step is to deploy our gem. This step is a bit hairy so bare
with me. We have to first setup an account over at
[RubyGems](http://rubygems.org) and download our credentials file. Once
you've got an account created, use the following in a terminal to setup
your credentials:

```bash
curl -u thebadmonkeydev https://rubygems.org/api/v1/api_key.yaml
< ~/.gem/credentials; chmod 0600 ~/.gem/credentials
```

you'll be prompted for your password and once entered, your credentials
will be setup in your `~/.gem` folder. Now that we're all super
authenticated and what not we can push our new gem out to the world
using this simple command (notice that the file name is the same as the
one produced by the build command above):

```bash
gem push sidekiq-workflow-0.0.1.gem 
```

You should see `Successfully registered gem: sidekiq-workflow (0.0.1)`
if everything was successful. You can now visit your dashboard on
RubyGems to see your gem. Head on over to the [sidekiq-workflow gem site](https://rubygems.org/gems/sidekiq-workflow) to see the actual
sidekiq-workflow.

<a name="conclusion"></a>
### Conclusion
So what have we accomplished here? We now have a basic gem skeleton, in
source control, and with a deployment procedure in place. Basically, we
have everything we need to start actually developing this gem. Next time
we'll talk about what it is that we're actually building and start
putting together the first bits of functionality.

Also, if you notice any errors/omissions or have any questions feel free
to comment below and I'll reply back as soon as I possibly can.

