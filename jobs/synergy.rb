require 'mysql2'

SCHEDULER.every '15m', :first_in => 0 do |job|

	connection =  Mysql2::Client.new(:host => "localhost", :port => 3306, :username => "cucumberuser", :password => "sogeti", :database => "cucumber")
	results1 = connection.query("SELECT COUNT(tr.passed) As NumTestsPassed FROM scenario_test_runs tr WHERE tr.passed  = 1")
	results2 = connection.query("SELECT COUNT(tr.passed) As NumTestsFailed FROM scenario_test_runs tr WHERE tr.passed = 0")
	results3 = results1.first['NumTestsPassed'] + results2.first['NumTestsFailed']
	results4 = connection.query("SELECT MAX(tr.scenario_id) As NumScenarios FROM scenario_test_runs tr")
	testspassed = ((results1.first['NumTestsPassed'].to_f / results3.to_f) * 100.to_f).round(2)

	connection.close

  send_event('synergy',   { value: results1.first['NumTestsPassed'] })
  send_event('synergy2',	{ value: results2.first['NumTestsFailed'] })
  send_event('synergy3',  { value: testspassed 											})
  send_event('synergy4',	{ value: results4.first['NumScenarios']		})
end

#Synergy:
#Synergy2:
#Synergy3: All tests passed added to all tests failed then we divide the number of tests passed by the result and output as a percentage
#Synergy4: 