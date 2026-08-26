if {![package vsatisfies [package provide Tcl] 8.6]} {return}
package ifneeded crimp::core 0.2 [list ::apply {dir {
    source [file join $dir critcl-rt.tcl]
    set path [file join $dir [::critcl::runtime::MapPlatform]]
    set ext [info sharedlibextension]
    set lib [file join $path "crimp_core$ext"]
    load $lib Crimp_core
    ::critcl::runtime::Fetch $dir policy_core_1.tcl
    package provide crimp::core 0.2
}} $dir]
