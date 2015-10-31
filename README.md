# rabbit-elixir-ruby

A proof of concept - connecting `Ruby` with `Elixir` via RabbitMQ

## Prerequisites

1. Make sure you have [Ruby installed](https://www.ruby-lang.org/en/documentation/installation/)
2. Make sure you have [Elixir installed
](http://elixir-lang.org/install.html)
2. Make sure you have [RabbitMQ installed
](https://www.rabbitmq.com/download.html)

## Setup

You need to run `RabbutMQ` server. To do that execute:

	rabbitmq-server
	
Now, it's available on your localhost and is waiting to accept any connection.

## Dependencies

Once you have everything installed, you need to fetch all dependencies for each project.

### Elixir

	cd rabbit_elixir
	mix deps.get
	
### Ruby

	cd rabbit_ruby
	bundle

## Usage

Run `Elixir` application:

	cd rabbit_elixir
	mix run --no-halt
	
Run `Ruby` application:

	cd rabbit_ruby
	bundle exec ruby bunny.rb

## Results

This simple program sends a number from `Ruby` to `Elixir` application. You should see a message like:

	Consumed a 1.