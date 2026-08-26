if {![package vsatisfies [package provide Tcl] 8.6]} {return}
package ifneeded crimp::bmp 0.2 [list ::apply {dir {
    source [file join $dir critcl-rt.tcl]
    set path [file join $dir [::critcl::runtime::MapPlatform]]
    set ext [info sharedlibextension]
    set lib [file join $path "crimp_bmp$ext"]
    load $lib Crimp_bmp
    ::critcl::runtime::Fetch $dir policy_bmp_1.tcl
    package provide crimp::bmp 0.2
}} $dir]
