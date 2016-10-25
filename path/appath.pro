;==============================================================================
;    APPATH
;+=============================================================================
; :Description:
;    Path management for Aram Panasenco's programs
;
; :Keywords:
;    RESET : optional, type=boolean
;      Resets path to ssw original
;    UNIT : optional, type=boolean
;      Initializes paths for unit testing.
;    PFSS : optional, type=boolean
;      Set this keyword to initialize paths for pfss_addons
;    HFAP : optional, type=boolean
;      Set this keyword to ininitialize paths for HelioFlux's APlib
;-=============================================================================
pro apPath, RESET=resetKW, UNIT=unitKW, PFSS=pfssKW, HFAP=hfapKW
    old_root = expand_path('~/Dropbox/IDL',/all_dirs)
    new_root = expand_path('~/git',/all_dirs)
    unit_paths = [expand_path('+~/git/mgunit/src',/array), $
            expand_path('+~/git/idldoc/lib/src',/array), $
            filepath('tests',root=new_root,sub='APlib'), $
            filepath('tests',root=new_root,sub='pfss_addons')]
    coyote_paths = expand_path('+~/IDL/coyote',/array)
    pfss_root = filepath('pfss_addons',root=new_root,sub='pfss_adons')
    pfss_paths =  [pfss_root, filepath('lib',root=pfss_root), $
            filepath('core',root=new_root,sub='APlib')]
    hfap_root = filepath('APlib',root=old_root,sub='AH_HelioViewer')
    hfap_paths = [hfap_root, $ 
            filepath('core',root=hfap_root), $
            filepath('error',root=hfap_root), $
            filepath('fits',root=hfap_root), $
            filepath('formats',root=hfap_root), $
            filepath('operation',root=hfap_root), $
            filepath('ui',root=hfap_root)]
    
    add_paths = []

    if keyword_set(resetKW) then begin
        ssw_path, /restore, /quiet 
    endif
    if keyword_set(unitKW) then begin
        add_paths = [add_paths, unit_paths]
    endif
    if keyword_set(pfssKW) then begin
        ssw_path, /pfss, /quiet
        add_paths = [add_paths, coyote_paths]
        add_paths = [add_paths, pfss_paths]
    endif
    if keyword_set(hfapKW) then begin
        add_paths = [add_paths, hfap_paths]
    endif
    
    ; Add the paths to the !path system variable
    if n_elements(add_paths) ne 0 then begin
        for i=n_elements(add_paths)-1, 0, -1 do begin
            if strpos(!path, add_paths[i]) eq -1 then $
                !path = add_paths[i] + ':' + !path
        endfor
    endif

    ; Check for conflicting APlib core definitions
    new_core = filepath('core',root=new_root,sub='APlib')
    old_core = filepath('core',root=old_root, $
                        sub=['AH_HelioViewer','APlib'])
    new_pos = strpos(!path, new_core)
    old_pos = strpos(!path, old_core)
    if new_pos ne -1 && old_pos ne -1 then $
            !path = strmid(!path, 0, old_pos) + $
            strmid(!path, old_pos + strlen(old_core)+1)
    
end

