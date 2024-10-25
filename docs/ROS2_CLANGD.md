#### **Getting clangd LSP working with ROS2**
* To use the included clangd LSP with ROS2 (rclcpp) and other included headers (e.g. opencv2), colcon needs to be told to generate a `compile_commands.json` when building as clang will need this to generate suggestions for included headers (rclcpp, or others like opencv2).
`colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=YES`