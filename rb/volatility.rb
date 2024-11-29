require 'csv'
require 'date'

def calculate_volatility(data)
  close_prices = data.map { |row| row['Close'].to_f }
  returns = close_prices.each_cons(2).map { |a, b| Math.log(b / a) }
  standard_deviation = Math.sqrt(returns.map { |r| (r - returns.sum / returns.size) ** 2 }.sum / (returns.size - 1))
  annualized_volatility = standard_deviation * Math.sqrt(2.5) # For csv in days - 252 trading days in a year, for month - 12
  annualized_volatility.round(4)
end

# Array of CSV file names
csv_files = ['COF.csv', 'DTST.csv', 'FRD.csv', 'TGB.csv', 'TKR.csv', 'UHS.csv']

volatility_data = {}

# Read and process data from each CSV file
csv_files.each do |csv_file|
  data = CSV.read("../csv/#{csv_file}", headers: true)
  symbol = File.basename(csv_file, '.*')
  volatility_data[symbol] = calculate_volatility(data)
end

# Output volatility results
volatility_data.each do |symbol, volatility|
  puts "#{symbol}: #{volatility}"
end