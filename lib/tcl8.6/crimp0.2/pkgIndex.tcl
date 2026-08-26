if {![package vsatisfies [package provide Tcl] 8.6]} {return}
package ifneeded crimp 0.2 [list ::apply {dir {
    source [file join $dir critcl-rt.tcl]
    set path [file join $dir [::critcl::runtime::MapPlatform]]
    set ext [info sharedlibextension]
    set lib [file join $path "crimp$ext"]
    load $lib Crimp
    ::critcl::runtime::Fetch $dir r_strimj_1.tcl
    ::critcl::runtime::Fetch $dir policy_2.tcl
    package provide crimp 0.2
}} $dir]
