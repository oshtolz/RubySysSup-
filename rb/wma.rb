require 'csv'
require 'date'
require 'gruff'

# Load stock data from CSV
def load_stock_data(file_name)
  data = []
  file_path = "../csv/UHS.csv"

  CSV.foreach(file_path, headers: true) do |row|
    date = Date.parse(row['Date'])
    open_price = row['Open'].to_f
    high_price = row['High'].to_f
    low_price = row['Low'].to_f
    close_price = row['Close'].to_f
    adj_close_price = row['Adj Close'].to_f
    volume = row['Volume'].to_i

    data << {
      date: date,
      open: open_price,
      high: high_price,
      low: low_price,
      close: close_price,
      adj_close: adj_close_price,
      volume: volume
    }
  end

  data
end

# Calculate the Weighted Moving Average (WMA)
def calculate_wma(prices, period)
  weights = (1..period).to_a.reverse  # Weights: most recent gets the highest weight
  weighted_prices = []

  prices.each_cons(period) do |window|
    weighted_sum = window.each_with_index.sum { |price, idx| price * weights[idx] }
    weight_sum = weights.sum
    weighted_prices << (weighted_sum / weight_sum)
  end

  weighted_prices
end

# Plot WMA and stock data
def plot_wma(stock_data, wma_data)
  g = Gruff::Line.new
  g.title = "Stock Data with WMA"

  # Plot the Close Prices
  g.data(:close, stock_data.map { |row| row[:close] }[0...wma_data.size])  # Slice to match WMA data size

  # Plot the WMA line
  g.data(:wma, wma_data)

  # Save the plot to a file
  g.write('../output/UHS/wma_chart.png')
end

# Example usage
file_path = 'path_to_your_file.csv'  # Replace with your CSV file path
stock_data = load_stock_data(file_path)

# Parameters for WMA
wma_period = 5  # WMA period (e.g., 20 days)

# Calculate WMA
wma_data = calculate_wma(stock_data.map { |row| row[:close] }, wma_period)

# Plot the WMA with the stock data
plot_wma(stock_data, wma_data)