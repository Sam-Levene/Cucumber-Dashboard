require 'mysql2'
output = Hash.new({ value: 0 })

connection =  Mysql2::Client.new(:host => "localhost", :port => 3306, :username => "cucumberuser", :password => "sogeti", :database => "cucumber")
results = connection.query("select id, passed, test_run_at from scenario_test_runs")

myItems = results.map do |row|
	row = {
		:label => row['id'],
		:value => "Test Passed [1(Y) / 0(N)]: " << row['passed'].to_s << " At: " << row['test_run_at'].to_s
	}
end

send_event('cucumberresults', { items: myItems })