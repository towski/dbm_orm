$TEST = true
require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../lib/dbm_orm'
Model.dir = "./db"
if RUBY_PLATFORM != "java"
	require 'debugger'
end

class Attempt < Model
end

class Event < Model
end

class ModelTest < MiniTest::Unit::TestCase
	def test_thought
		new_id = Attempt.head
		thought = Attempt.new(body: 'hey')
		thought.save
		assert new_id == thought.id
		assert new_id + 1 == Attempt.head
	end

	def test_find
		thought = Attempt.new(body: 'hey')
		thought.save
		same_thought = Attempt.find thought.id
		assert same_thought.id == thought.id
		same_thought.update(body: 'now')
		same_thought = Attempt.find thought.id
		assert same_thought.body == "now"
		same_thought.update_attribute :body, 'hey'
		next_thought = Attempt.find thought.id
		assert next_thought.body == "hey"
		Attempt.last(10).to_json
	end

	def test_two_models
		event = Event.find(Event.head)
		assert event == nil
		event = Event.new(body: 'hey')
		event.save
		find_event = Event.find(event.id)
		raise if find_event == nil
		event.destroy
		find_event = Event.find(event.id)
		raise if find_event != nil
	end
end

MiniTest::Unit.after_tests { Model.process_exit }
