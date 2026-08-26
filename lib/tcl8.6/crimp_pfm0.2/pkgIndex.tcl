if {![package vsatisfies [package provide Tcl] 8.6]} {return}
package ifneeded crimp::pfm 0.2 [list ::apply {dir {
    source [file join $dir critcl-rt.tcl]
    set path [file join $dir [::critcl::runtime::MapPlatform]]
    set ext [info sharedlibextension]
    set lib [file join $path "crimp_pfm$ext"]
    load $lib Crimp_pfm
    ::critcl::runtime::Fetch $dir policy_pfm_1.tcl
    package provide crimp::pfm 0.2
}} $dir]
