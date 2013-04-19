SLAM Visualizer
===============
A few tools I assembled for analyzing and visualizing .rec files output from GridSLAM.

Usage
-----
`rec_parse` will parse the .rec file and output a YAML file of the same name. Once you have ruby-processing installed, you can run the visualization tool with `rp5 watch plot_laser.rb`.

Visualizer
----------
In the visualizer, you can do a few things to explore the dataset:
- Press 'z' while dragging to zoom in/out
- Press 'c' and drag to change the clipping value (threshold for laser ranges)
- Press 'o' to output the current laser scan as a CSV (with clipping applied)
- Press ';' to advance to the next scan
- Press 'j' to step back a scan
- Press 's' to toggle plot smoothing
