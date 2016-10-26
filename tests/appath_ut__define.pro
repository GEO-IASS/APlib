;==============================================================================
; :: APPATH_UT ::
;+=============================================================================
;
; This class is a collection of tests for the appath procedure
;
; :Author:
;    Aram Panasenco: panasencoaram@gmail.com
;-=============================================================================

function appath_ut::init, _EXTRA=extra
    ok = self -> MGutTestCase::init(_extra=extra)
    if not ok then return, 0
    return, 1
end

function appath_ut::test_unit_doesnt_fail
    compile_opt idl2
    
    apPath, /reset
    assert, strpos(!path, 'mgunit') eq -1, $
            'mgunit somehow in path after reset'

    apPath, /unit
    assert, strpos(!path, 'mgunit') ne -1, $
            'Setting mgunit path failed'

    return, 1
end


function appath_ut::test_reset_works
    compile_opt idl2

    fake_path = '/this/path/isnt/real' 
    !path = fake_path + ':' + !path
    assert, strpos(!path, fake_path) ne -1, $
            'Bug in test prevented path from being set properly'
    ; Attempt to reset the path
    apPath, /reset

    assert, strpos(!path, fake_path) eq -1, $
            'apPath reset functionality not working properly'

    return, 1
end

function appath_ut::test_pfss_works
    compile_opt idl2

    ; Load PFSS path
    apPath, /reset, /unit, /pfss

    ; Attempt to compile some PFSS code
    routines = ['pfss__define','pfss_b_eff','lat2theta', $
            'aparrayintercepts','apcontainer__define', $
            'apdictionary__define']
    

    foreach r, routines do begin
        findpro, r, dirlist=d, /noprint
        assert, d[0] ne '', 'No containing directory found: ' + r
        assert, n_elements(d) lt 2, 'Too many directories found: ' + r
    endforeach

    return, 1
end

function appath_ut::test_helioflux_aplib_works
    compile_opt idl2

    ; Load HelioFlux's APLib path
    apPath, /reset, /unit, /hfap

    ; Attempt to compile some APlib code
    routines = ['rotate180','apstack__define','apconsole__define', $
                'apfitsmanager__define', 'apuisunscaler__define', $
                'apsetcsi', 'minformat', 'apintersect', 'apmean','readxyo']
    foreach r, routines do begin 
        findpro, r, dirlist=d, /noprint
        assert, d[0] ne '', 'No containing directory found: ' + r
        assert, n_elements(d) lt 2, 'Too many directories found: ' + r
    endforeach
    return, 1
end

function appath_ut::test_hfap_doesnt_load_extra
    compile_opt idl2

    ; Load HelioFlux's APLib path
    apPath, /reset, /unit, /hfap
    
    ; Check if unwanted libraries like template and prototype were loaded
    assert, strpos(!path,'APlib/Prototype') eq -1 && $
            strpos(!path,'APlib/template') eq -1 && $
            strpos(!path,'APlib/ui/atest') eq -1, $
            'Extra unwated libraries were added to !path.'

    return, 1
end

function appath_ut::test_hfap_reads_its_own_core
    compile_opt idl2

    ; Load both git APlib and HelioFlux's APLib paths
    apPath, /reset, /unit, /hfap
    
    findpro, 'apcontainer__define', dirlist=d, /noprint

    assert, d[0] ne '' && d eq $
            '/Users/aram/Dropbox/IDL/AH_HelioViewer/APlib/core/', $
            'HFAP got apContainer from somewehere unexpected'
    
    return, 1
end

function appath_ut::test_gitap_core_preferred_over_old_hfap_core
    compile_opt idl2

    ; Load both git APlib and HelioFlux's APLib paths
    apPath, /reset, /unit, /pfss
    apPath, /hfap

    findpro, 'apcontainer__define', dirlist=d, /noprint
    assert, n_elements(d) gt 0, 'No core in path'
    assert, n_elements(d) lt 2, 'Both old and new cores in path'
    assert, d[0] eq '/Users/aram/git/APlib/core/', $
            'Used old core instead of new'

    return, 1
end

function appath_ut::test_old_core_keyword_works
    compile_opt idl2

    ; Load both git APlib and HelioFlux's APLib paths with the old_core keyword
    apPath, /reset, /unit, /hfap
    apPath, /pfss, /old_core

    findpro, 'apcontainer__define', dirlist=d, /noprint
    assert, n_elements(d) gt 0, 'No core in path'
    assert, n_elements(d) lt 2, 'Both old and new cores in path'
    assert, d[0] eq '/Users/aram/Dropbox/IDL/AH_HelioViewer/APlib/core/', $
            'Used new core instead of old'

    return, 1
end

function appath_ut::test_no_recurisve_path_adding
    compile_opt idl2
    
    apPath, /reset, /unit, /hfap
    assert, strpos(!path,'recursion_test') eq -1, 'Recursive path loading'
    
    return, 1
end

function appath_ut::test_all_keyword_works
    compile_opt idl2

    apPath, /all

    return, 1
end

pro appath_ut__define
    class = { appath_ut, INHERITS MGutTestCase }
end

