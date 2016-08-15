require 'mysql2'

SCHEDULER.every '2s', :first_in => 0 do |job|

	connection =  Mysql2::Client.new(:host => "localhost", :port => 3306, :username => "cucumberuser", :password => "sogeti", :database => "cucumber")
	results = connection.query("SELECT sfl.id AS ID,sfl.scenario_file AS File, sfl.scenario As Scenario, sfl.failed_step AS FailedStep FROM scenario_failed_links sfl, time ti WHERE sfl.updated_at BETWEEN ti.starttime AND ti.endtime")


	myItems = results.map do |row|

		row = {
			:value => "File: " << row['File'] << " Scenario: " << row['Scenario'] << " Failed Step: " << row['FailedStep']
		}
	end

	connection.close

	send_event('failed', { items: myItems })

end
