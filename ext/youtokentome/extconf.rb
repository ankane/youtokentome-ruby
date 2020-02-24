require "mkmf-rice"

$CXXFLAGS << " -std=c++11"

ext = File.expand_path(".", __dir__)
youtokentome = File.expand_path("../../vendor/YouTokenToMe/youtokentome/cpp", __dir__)

$srcs = Dir["{#{ext},#{youtokentome}}/*.{cc,cpp}"]
$INCFLAGS << " -I#{youtokentome}"
$VPATH << youtokentome

create_makefile("youtokentome/ext")
