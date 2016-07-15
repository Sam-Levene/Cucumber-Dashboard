require 'mysql2'

SCHEDULER.every '2s', :first_in => 0 do |job|

	connection =  Mysql2::Client.new(:host => "localhost", :port => 3306, :username => "cucumberuser", :password => "sogeti", :database => "cucumber")
	results1 = connection.query("SELECT COUNT(tr.passed) As NumTestsPassed FROM scenario_test_runs tr WHERE tr.passed  = 1")
	results2 = connection.query("SELECT COUNT(tr.passed) As NumTestsPassed FROM scenario_test_runs tr")

	connection.close

  send_event('synergy',   { value: results1.first['NumTestsPassed'].to_s << "/" << results2.first['NumTestsPassed'].to_s })
end