set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set GYP_MSVS_VERSION=2017 
set GYP_MSVS_OVERRIDE_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional
call gn --root=src --ide=vs args out/win/debug --args="is_clang=false is_component_build=false use_custom_libcxx=false symbol_level=0"
