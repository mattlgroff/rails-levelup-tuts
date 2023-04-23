# Course Learnings
[Beginner Ruby on Rails](https://levelup.video/tutorials/beginner-ruby-on-rails/series-introduction)

## [Dev setup](https://levelup.video/tutorials/beginner-ruby-on-rails/dev-setup)
```bash
rails new eventz -j esbuild --css tailwindcss -d postgresql
```

Start your dev server

```bash
bin/dev
```

If you just run `rails s` you will not be able to use esbuild, and the bundled js/css from Tailwind will not be updated when you make changes.

Runs the contents of the Procfile.dev file in the root of the project.

```bash
web: unset PORT && bin/rails server
js: yarn build --watch
css: yarn build:css --watch
```

## [Making a static page](https://levelup.video/tutorials/beginner-ruby-on-rails/static-pages)

```bash
rails g controller home index
```

Output should look like:

```bash
      create  app/controllers/home_controller.rb
       route  get 'home/index'
      invoke  erb
      create    app/views/home
      create    app/views/home/index.html.erb
      invoke  test_unit
      create    test/controllers/home_controller_test.rb
      invoke  helper
      create    app/helpers/home_helper.rb
      invoke    test_unit
```

Open `app/views/home/index.html.erb` and add some content.

```html
<h1>Hello <%= @name %></h1>
<p>Find me in app/views/home/index.html.erb</p>
```

`.erb` is a templating language that allows you to embed ruby code in your html.

The `@name` variable is set in the controller. Open `app/controllers/home_controller.rb` and add the following code:

```ruby
class HomeController < ApplicationController
  def index
    @name = "Matt"
  end
end
```

## [Adding a Navbar to the top of the page](https://levelup.video/tutorials/beginner-ruby-on-rails/navbar)

```html
<header class="mb-4">
  <nav
    class="flex flex-wrap items-center justify-between px-3 py-3 text-gray-700 bg-gray-100 lg:px-10"
  >
    <div class="flex items-center mr-6 flex-no-shrink">
      <a href="#" class="link text-xl tracking-tight font-black">Eventz</a>
    </div>

    <div class="block lg:hidden">
      <button
        class="flex items-center px-3 py-2 border rounded text-grey border-gray-500 hover:text-gray-600 hover:border-gray-600"
      >
        <svg
          class="fill-current h-3 w-3"
          viewBox="0 0 20 20"
          xmlns="http://www.w3.org/2000/svg"
        >
          <title>Menu</title>
          <path d="M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z" />
        </svg>
      </button>
    </div>

    <div
      class="items-center block w-full text-center lg:flex-1 lg:flex lg:text-left"
    >
      <div class="lg:flex-grow">
        <a
          href="/about"
          class="block mt-4 lg:inline-block lg:mt-0 lg:mr-4 mb-2 lg:mb-0 link"
          >About</a
        >
      </div>
      <div
        class="items-center block w-full mt-2 text-center lg:flex lg:flex-row lg:flex-1 lg:mt-0 lg:text-left lg:justify-end"
      >
        <button href="#" class="btn btn-default mb-2 lg:mb-0 block">
          Login
        </button>
        <button href="#" class="btn btn-default block ml-4">Sign Up</button>
      </div>
    </div>
  </nav>
</header>
```

## Create the /about page manually

Go to `config/routes.rb` and add the following line:

```ruby
  get 'about', to: 'about#index'
```

So it'll look like:

```ruby
Rails.application.routes.draw do
  get 'home/index'
  get 'about', to: 'about#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
```

Create a new file in `app/controllers/about_controller.rb` and add the following code:

```ruby
class AboutController < ApplicationController
  def index
  end
end
```

Create a view for About in `app/views/about/index.html.erb` and add the following code:

```html
<h1>About Us</h1>
```

## [Making the Navbar dynamic](https://levelup.video/tutorials/beginner-ruby-on-rails/navbar)

Let's use Rails helpers to make the Navbar dynamic.

Replace the about anchor tag with a `link_to`

Before:

```html
<a
  href="/about"
  class="block mt-4 lg:inline-block lg:mt-0 lg:mr-4 mb-2 lg:mb-0 link"
  >About</a
>
```

After:

```html
<%= link_to 'About', about_path, class: "block mt-4 lg:inline-block lg:mt-0
lg:mr-4 mb-2 lg:mb-0 link" %>
```

In this `link_to` helper, the first argument is the text to display, the second argument is the path to link to, and the third argument is a hash of options.

Where does `about_path` come from? It's a Rails helper that generates the path to the about page. You can see all the available helpers by running `rails routes`.

```bash
$ rails routes

Prefix Verb   URI Pattern                                                                      Controller#Action
home_index GET    /home/index(.:format)
home#index

about GET    /about(.:format)                                             about#index
```

Next we'll replace the Home anchor tag.

Before:

```html
<a href="#" class="link text-xl tracking-tight font-black">Eventz</a>
```

After:

```html
<%= link_to 'Eventz', root_path, class: "link text-xl tracking-tight font-black"
%>
```

`root_path` is the root path of the application, pretty self-explanatory. We need to setup a `root_path` in `config/routes.rb`

```ruby
Rails.application.routes.draw do
  get 'home/index'
  root to: 'home#index'
  get 'about', to: 'about#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
```

We added `root to: 'home#index'` to the routes file. This tells Rails that the root path of the application is the `home#index` action.

We can remove the `get 'home/index'` line because it's redundant.

```ruby
Rails.application.routes.draw do
  root to: 'home#index'
  get 'about', to: 'about#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
```

## [Adding Navbar to every page of our app using Partials](https://levelup.video/tutorials/beginner-ruby-on-rails/partials)
Go to `app/views/layouts/application.html.erb` 

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Eventz</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>
```

`yield` renders the content of the application.

If we want to add our header to the page we could just toss it inside the body and above the `yield` like so:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Eventz</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
  </head>

  <body>
  <header class="mb-4">
    <nav class="flex flex-wrap items-center justify-between px-3 py-3 text-gray-700 bg-gray-100 lg:px-10">
      <div class="flex items-center mr-6 flex-no-shrink">
        <%= link_to 'Eventz', root_path, class: "link text-xl tracking-tight font-black" %>
      </div>       

      <div class="block lg:hidden">
        <button class="flex items-center px-3 py-2 border rounded text-grey border-gray-500 hover:text-gray-600 hover:border-gray-600">
          <svg class="fill-current h-3 w-3" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
            <title>Menu</title>
            <path d="M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z"/>
          </svg>
        </button>
      </div>

      <div class="items-center block w-full text-center lg:flex-1 lg:flex lg:text-left">
        <div class="lg:flex-grow">
          <%= link_to 'About', about_path, class: "block mt-4 lg:inline-block lg:mt-0 lg:mr-4 mb-2 lg:mb-0 link" %>
        </div>
        <div class="items-center block w-full mt-2 text-center lg:flex lg:flex-row lg:flex-1 lg:mt-0 lg:text-left lg:justify-end">
          <button href="#" class="btn btn-default mb-2 lg:mb-0 block">Login</button>
          <button href="#" class="btn btn-default block ml-4">Sign Up</button>
        </div>
      </div>
    </nav>
  </header>
    <%= yield %>
  </body>
</html>
```

Rather than having this HTML component in here, we'll use a partial. Let's make a new file: `app/views/shared/_navbar.html.erb`

The leading `_` means it is a Partial shared among different views.

Copy and paste the `<header>` and everything in it into the new file.

Now we go into out `app/views/layouts/application.html.erb` and replace the `<header>` with `<%= render 'shared/navbar' %>`

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Eventz</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
  </head>

  <body>
    <%= render "shared/navbar" %>
    <%= yield %>
  </body>
</html>
```

Much cleaner! We don't need to include all that extra HTML/CSS in our layout, we can import a partial and render it using one line:
```html
    <%= render "shared/navbar" %>
```

Notice how it doesn't use `_navbar` but just `navbar`. This is because Rails knows to look for a partial when you use `render` and it will automatically look for a file with a leading `_` in the name. Make sure to follow this convention.

You can think of `partials` kind of like a re-usable component. You can use them in multiple places and they are a great way to keep your code DRY.


## Flash Messages and how to send notifications to our users
