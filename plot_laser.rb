require 'yaml'
require 'csv'

class PlotLaser < Processing::App
	def setup
		@filename = "albert"
		@data = YAML.load File.open("#{@filename}.yml")
		@smooth = false
		no_smooth

		@frame_index = 0
		@zoom = 1.0
		@origin = [0,0]
		@clip = 5000

		@mint = -PI/2
		@maxt = PI/2

		@changed = true
	end

	def draw
		@frame_index = max(min(@frame_index, @data.size-1), 0)
		if @changed
			@changed = false
			background 255

			@frame = @data[@frame_index]

			li = @frame[:laser][:items]
			pos = @frame[:pos][:items]

			if @smooth
				smooth
			else
				no_smooth
			end

			push_matrix
			translate 200, 300
			translate @origin[0], @origin[1]
			scale @zoom
			scale 0.5

			@local = @data.clone
			@local << @local.delete(@frame)

			for frame in @local do
				push_matrix
				stroke 0
				stroke_width 1
				if @frame == frame
					stroke 255, 0, 0
					stroke_width 3
				end
				pos = frame[:pos][:items]
				li = frame[:laser][:items]
				translate pos[0], pos[1]
				rotate pos[2]*PI/180.0

				li.each_with_index do |line, i|
					next if line > @clip
					percent = i / (li.size-1).to_f
					angle = percent * (@maxt-@mint) + @mint
					line 0,0,line*cos(angle), line*sin(angle)
				end
				fill 0, 0, 255
				ellipse 0, 0, 50, 50 if @frame == frame
				pop_matrix
			end

			pop_matrix

			fill 0, 0, 255
			text(@clip.to_s, 10, height - 20)
		end
	end

	def mouse_dragged
		if key_pressed? && key == 'z'
			@zoom -= (mouse_y - pmouse_y)/200.0
			@changed = true
		end

		if key_pressed? && key == 'c'
			@clip -= (mouse_y - pmouse_y)*10
			@clip = max(@clip, 0)
			@changed = true
		end

		if !key_pressed?
			@origin[0] += mouse_x - pmouse_x
			@origin[1] += mouse_y - pmouse_y
			@changed = true
		end

	end

	def key_released
		case key
		when ';'
			@frame_index += 1
			@changed = true
		when 'j'
			@frame_index -= 1
			@changed = true
		when 's'
			@smooth = !@smooth
			@changed = true
		when 'o'
			CSV.open("#{@filename}.csv", 'wb') do |csv|
				# pos = frame[:pos][:items]
				li = @frame[:laser][:items]
				li.each_with_index do |line, i|
					next if line > @clip
					percent = i / (li.size-1).to_f
					angle = percent * (@maxt-@mint) + @mint
					csv << [ line*cos(angle), line*sin(angle) ]
				end
			end
			puts "Finished writing to CSV."
		end
	end
end

PlotLaser.new :title => "Laser Plot", :width => 800, :height => 600
