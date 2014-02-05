require 'test/unit'
$USE_DBM = true
require_relative 'test_helper'
require_relative '../lib/model'
Model.dir = "./db"
require 'ruby-debug'

class Attempt < Model
end

class DbmTest < Test::Unit::TestCase
	def test_somethings
		attempt = Attempt.new(body: "this")
		attempt.save
		assert_equal attempt.body, Attempt.find(attempt.id).body
	end
end
