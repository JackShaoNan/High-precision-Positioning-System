# High-precision-Positioning-System
High-precision Infrared Binocular Positioning System

1. Implemented two functions, including 2D target extraction and 3D coordinate reconstruction

2. Applied Suzuki85 algorithm and sub-pixel edge extraction algorithm to track target’s contour quickly and accurately;
used OpenCV and Eigen libraries to match 2D target and obtain basic matrix of system

3. Proposed new method of using space region segmentation to improve lens distortion

4. Enabled system accuracy to reach within 1mm in the x and y direction, and within 2mm in the z direction after
testing; able to handle more than 30 frames per second
