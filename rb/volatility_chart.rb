require 'csv'
require 'gruff'

def calculate_volatility(data)
  close_prices = data.map { |row| row['Close'].to_f }
  returns = close_prices.each_cons(2).map { |a, b| Math.log(b / a) }
  standard_deviation = Math.sqrt(returns.map { |r| (r - returns.sum / returns.size) ** 2 }.sum / (returns.size - 1))
  annualized_volatility = standard_deviation * Math.sqrt(2.5) # For csv in days - 252 trading days in a year, 12 - months, 1 - years 
  annualized_volatility.round(4)
end

# Array of CSV file names
csv_files = ['AZN.csv', 'CSIOY.csv', 'CSIQ.csv', 'GOOD.csv', 'ITUB.csv', 'TJX.csv']

volatility_data = {}

# Read and process data from each CSV file
csv_files.each do |csv_file|
  data = CSV.read("csv/#{csv_file}", headers: true)
  symbol = File.basename(csv_file, '.*')
  volatility_data[symbol] = calculate_volatility(data)
end

# Create volatility chart
bar_chart = Gruff::Bar.new
bar_chart.title = 'Volatility Comparison 2021 - 2023'
volatility_data.each do |symbol, volatility|
  bar_chart.data(symbol, [volatility])
end

# Set labels for x-axis
bar_chart.labels = volatility_data.keys.each_with_index.map { |symbol, index| [index, symbol] }.to_h

# Set maximum value for y-axis
max_volatility = volatility_data.values.max
bar_chart.maximum_value = max_volatility + (max_volatility * 0.1) # Add 10% buffer

# Output chart to file
bar_chart.write('output/other/volatility_chart_2021-2023.png')