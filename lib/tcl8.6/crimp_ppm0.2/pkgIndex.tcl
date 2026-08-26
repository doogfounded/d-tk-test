if {![package vsatisfies [package provide Tcl] 8.6]} {return}
package ifneeded crimp::ppm 0.2 [list ::apply {dir {
    source [file join $dir critcl-rt.tcl]
    set path [file join $dir [::critcl::runtime::MapPlatform]]
    set ext [info sharedlibextension]
    set lib [file join $path "crimp_ppm$ext"]
    load $lib Crimp_ppm
    ::critcl::runtime::Fetch $dir policy_ppm_1.tcl
    package provide crimp::ppm 0.2
}} $dir]
