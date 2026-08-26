if {![package vsatisfies [package provide Tcl] 8.6]} {return}
package ifneeded crimp::tk 0.2 [list ::apply {dir {
    source [file join $dir critcl-rt.tcl]
    set path [file join $dir [::critcl::runtime::MapPlatform]]
    set ext [info sharedlibextension]
    set lib [file join $path "crimp_tk$ext"]
    load $lib Crimp_tk
    ::critcl::runtime::Fetch $dir policy_tk_1.tcl
    ::critcl::runtime::Fetch $dir plot_2.tcl
    package provide crimp::tk 0.2
}} $dir]
