; USER IDL STARTUP FILE
!quiet = 1
; Set path to be able to use the apPath routine
ssw_path, '/Users/aram/git/APlib/utilities', /prepend, /quiet
; Use the apPath routine
apPath, /all, /old_core
!quiet = 0
