test_result = input('test_result')

expected_test_result = input('expected_test_result')

describe test_result do
  it { should eq expected_test_result }
end
