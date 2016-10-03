require 'mysql2'

SCHEDULER.every '2s', :first_in => 0 do |job|

	connection =  Mysql2::Client.new(:host => "localhost", :port => 3306, :username => "cucumberuser", :password => "sogeti", :database => "cucumber")
	results = connection.query("SELECT str.id AS ID, s.scenario_name AS Name, str.passed As PassedFailed, s.failure_rate AS FailureRate  FROM `scenario_test_runs` str, `time` ti, `scenarios` s WHERE  s.id = str.scenario_id AND str.updated_at BETWEEN ti.starttime AND ti.endtime")

	myItems = results.map do |row|
		if row['PassedFailed'].to_s == "1"
			passorfail = "Pass."
			else
				passorfail ="Fail."
		end

		row = {
			:value => "Scenario: " << row['Name'].to_s << "; Test Passed/Failed: " << passorfail << "; Failure Rate: " << row['FailureRate'].to_s << "%"
		}
	end

	connection.close

	send_event('real-data', { items: myItems} )

end
