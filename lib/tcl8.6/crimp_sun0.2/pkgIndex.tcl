if {![package vsatisfies [package provide Tcl] 8.6]} {return}
package ifneeded crimp::sun 0.2 [list ::apply {dir {
    source [file join $dir critcl-rt.tcl]
    set path [file join $dir [::critcl::runtime::MapPlatform]]
    set ext [info sharedlibextension]
    set lib [file join $path "crimp_sun$ext"]
    load $lib Crimp_sun
    ::critcl::runtime::Fetch $dir policy_sun_1.tcl
    package provide crimp::sun 0.2
}} $dir]
