require 'mysql2'

SCHEDULER.every '15m', :first_in => 0 do |job|

	connection =  Mysql2::Client.new(:host => "localhost", :port => 3306, :username => "cucumberuser", :password => "sogeti", :database => "cucumber")
	results = connection.query("SELECT tr.id AS ID, s.scenario_name AS Name, tr.passed As PassedFailed, s.failure_rate AS FailureRate FROM scenario_test_runs tr, scenarios s WHERE s.id = tr.scenario_id")

	myItems = results.map do |row|
		if row['PassedFailed'].to_s == "1" 
			passorfail = "Pass"
			else
				passorfail ="Fail"
		end

		row = {
			:label => row['ID'],
			:value => " File: " << row['File'].to_s << "Test ID: " << row['ID'].to_s << " Scenario Name: " << row['Name'].to_s << " Test Passed/Failed: " << passorfail << " Failure Rate: " << row['FailureRate'].to_s << "%"
		}
	end

	connection.close

	send_event('real-data', { items: myItems} )

end