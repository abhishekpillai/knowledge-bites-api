# Knowledge Bites

Right now, Knowledge Bites is simply a Ruby Lightning Talk viewer. You can view popular Ruby lightning talks and mark them completed.

Knowledge Bites will be a place for developers to have regular training session of small bites of content from short videos to short blog posts to short code snippets. Let's develop a regular habit of training.

### Basic Setup

Make sure you are using ruby version 2.2.2

```
gem install bundler
bundle
# Make sure you have postgres running
rake db:create db:migrate
rails server
```

### Run specs
```
rake db:test:prepare
be rspec
```

### Populate Content
Generate your own Youtube API application password by following the directions [here](https://developers.google.com/youtube/v3/getting-started#before-you-start)
```
export YOUTUBE_API_KEY=insert-your-api-key-here
rake populate:videos
```

--

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
