# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appVocabular_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appVocabular_autogen.dir/ParseCache.txt"
  "appVocabular_autogen"
  )
endif()
