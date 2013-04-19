require 'date'
require 'yaml'

data = []
filename = "albert"
File.open "#{filename}.rec" do |f|
	f.each_slice(2) do |slice|
		# key = items.delete_at(0).downcase

		reads = slice.map do |line|
			items = line.chomp.split(/\s+/)
			time = items[1].to_i + items[2].to_i / 1E6
			time = Time.at(time).to_datetime
			items = items[3..-1]
			{ :time => time, :items => items }
		end

		pos = reads.first
		laser = reads.last
		pos[:items] = pos[:items].map(&:to_f)
		laser[:items] = laser[:items][3..-1].map(&:to_f)

		data << { :pos => pos, :laser => laser }
	end
end

# puts data.to_s
File.write "#{filename}.yml", data.to_yaml
puts data.map {|d| d[:pos][:items].to_s}
