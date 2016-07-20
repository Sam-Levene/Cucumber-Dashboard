require 'mysql2'

SCHEDULER.every '2s', :first_in => 0 do |job|

	connection =  Mysql2::Client.new(:host => "localhost", :port => 3306, :username => "cucumberuser", :password => "sogeti", :database => "cucumber")
	results = connection.query("select id, passed, test_run_at from scenario_test_runs")

	myItems = results.map do |row|
		row = {
			:label => row['id'],
			:value => "Test Passed [1(Y) / 0(N)]: " << row['passed'].to_s << " At: " << row['test_run_at'].to_s
		}
	end

	connection.close

	send_event('cucumberresults', { items: myItems })


end