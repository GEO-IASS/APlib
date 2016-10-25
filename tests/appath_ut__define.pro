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
    resolve_routine, ['pfss__define','pfss_b_eff','lat2theta', $
            'aparrayintercepts','apcontainer__define', $
            'apdictionary__define'], /either, /no_recompile
    
    return, 1
end

function appath_ut::test_helioflux_aplib_works
    compile_opt idl2

    ; Load HelioFlux's APLib path
    apPath, /reset, /unit, /hfap

    ; Attempt to compile some APlib code
    resolve_routine, ['rotate180','apstack__define','apconsole__define', $
            'apfitsmanager__define', 'apsetcsi', 'minformat', 'apintersect', $
            'apmean', 'apuisunscaler__define'], /either, /no_recompile

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

    resolve_routine, 'apContainer__define'
    i = routine_info('apContainer__define', /source)
    assert, i.path eq '/Users/aram/Dropbox/IDL/AH_HelioViewer/APlib/core/' + $
            'apcontainer__define.pro', $
            'HFAP got apContainer from somewehere unexpected'
    
    return, 1
end

function appath_ut::test_gitap_core_preferred_over_old_hfap_core_1
    compile_opt idl2

    ; Load both git APlib and HelioFlux's APLib paths
    apPath, /reset, /unit, /pfss
    apPath, /hfap
    
    resolve_routine, 'apContainer__define'
    i = routine_info('apContainer__define', /source)
    assert, i.path eq '/Users/aram/git/APlib/core/apcontainer__define.pro', $
            'Got apContainer from wrong place'

    return, 1
end

function appath_ut::test_no_tecurisve_path_adding
    compile_opt idl2
    
    apPath, /reset, /unit, /hfap
    assert, strpos(!path,'recursion_test') eq -1, 'Recursive path loading'
    
    return, 1
end

pro appath_ut__define
    class = { appath_ut, INHERITS MGutTestCase }
end

