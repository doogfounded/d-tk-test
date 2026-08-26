if {![package vsatisfies [package provide Tcl] 8.6]} {return}
package ifneeded crimp::pcx 0.2 [list ::apply {dir {
    source [file join $dir critcl-rt.tcl]
    set path [file join $dir [::critcl::runtime::MapPlatform]]
    set ext [info sharedlibextension]
    set lib [file join $path "crimp_pcx$ext"]
    load $lib Crimp_pcx
    ::critcl::runtime::Fetch $dir policy_pcx_1.tcl
    package provide crimp::pcx 0.2
}} $dir]
