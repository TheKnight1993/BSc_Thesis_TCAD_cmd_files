; Initialise workspace
(sde:clear)

; Create substrate doped regions
(sdegeo:create-rectangle (position 0 0 0) (position -4 -12 0) "Silicon" "Substrate_1")
(sdegeo:create-polygon (list
	(position -7 -6.6 0)
	(position -7 -8.4 0)
	(position -10 -8.4 0)
	(position -10 -7.2 0)
	(position -8.5 -7.2 0)
	(position -8.5 -6.6 0)
	(position -7 -6.6 0)
	)
	"Silicon"
	"Substrate_2"
)

; Create process doped regions
(sdegeo:create-rectangle (position -4 0 0) (position -7 -12 0) "Silicon" "DNW")
(sdegeo:create-rectangle (position -7 0 0) (position -8.5 -6.6 0) "Silicon" "NW_1")
(sdegeo:create-rectangle (position -7 -8.4 0) (position -8.5 -12 0) "Silicon" "NW_2.1")
(sdegeo:create-rectangle (position -8.5 -8.4 0) (position -10 -9 0) "Silicon" "NW_2.2")
(sdegeo:create-rectangle (position -8.5 -11.4 0) (position -10 -12 0) "Silicon" "NW_2.3")
(sdegeo:create-rectangle (position -8.5 -9 0) (position -10 -11.4 0) "PolySi" "NP")
(sdegeo:create-rectangle (position -8.5 0 0) (position -10 -7.2 0) "PolySi" "PP")

; Set oxide regions for insulation
(sdegeo:create-rectangle (position -10 -12 0) (position -11 -10.8 0) "Oxide" "Ox")
(sdegeo:create-rectangle (position -10 -9.6 0) (position -11 -6 0) "Oxide" "Ox")

; Define contacts for simulation
(sdegeo:set-contact (find-edge-id (position -10 -2 0)) "anode")
(sdegeo:set-contact (find-edge-id (position -10 -10.2 0)) "cathode")
(sdegeo:set-contact (find-face-id (position 0 2 0)) "bulk")

; Create a sweeping path and sweep along it
(define rectangular_path (sdegeo:create-polyline-wire (list
	(position 0 -6 0)
	(position 0 -6 2.5)
	(position 0 -2.5 6)
	(position 0 2.5 6)
	(position 0 6 2.5)
	(position 0 6 -2.5)
	(position 0 2.5 -6)
	(position 0 -2.5 -6)
	(position 0 -6 -2.5)
	(position 0 -6 0)
)))
(sdegeo:sweep (entity:faces (find-material-id "PolySi")) rectangular_path 
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"  ))
(sdegeo:sweep (entity:faces (find-material-id "Silicon")) rectangular_path 
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"  ))
(sdegeo:sweep (entity:faces (find-material-id "Oxide")) rectangular_path 
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"  ))

; Define contacts for simulation
(sdegeo:set-contact (find-face-id (position -10 -2 0)) "anode")
(sdegeo:set-contact (find-face-id (position -10 2 0)) "anode")
(sdegeo:set-contact (find-face-id (position -10 0 -2)) "anode")
(sdegeo:set-contact (find-face-id (position -10 0 2)) "anode")
(sdegeo:set-contact (find-face-id (position 0 -2 0)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 -2 2)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 -2 -2)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 0 -2)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 2 -2)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 -2 -2)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 2 0)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 2 2)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 0 2)) "bulk")

; Define and set doping profiles
(sdedr:define-constant-profile "NP_doping" "PhosphorusActiveConcentration" 1e+21)
(sdedr:define-constant-profile "DNW_doping" "PhosphorusActiveConcentration" 1e+19)
(sdedr:define-constant-profile "NW_doping" "PhosphorusActiveConcentration" 1e+15)
(sdedr:define-constant-profile "Substrate_doping" "BoronActiveConcentration" 1e+15)
(sdedr:define-constant-profile "PP_doping" "BoronActiveConcentration" 1e+29)

(sdedr:define-constant-profile-material "Substrate_doping" "Substrate_doping" "Silicon")
(sdedr:define-constant-profile-material "Substrate2_doping" "Substrate_doping" "PolySi")
(sdedr:define-constant-profile-region "NP_doping" "NP_doping" "NP")
(sdedr:define-constant-profile-region "DNW_doping" "DNW_doping" "DNW")
(sdedr:define-constant-profile-region "NW_1_doping" "NW_doping" "NW_1")
(sdedr:define-constant-profile-region "NW_2.1_doping" "NW_doping" "NW_2.1")
(sdedr:define-constant-profile-region "NW_2.2_doping" "NW_doping" "NW_2.2")
(sdedr:define-constant-profile-region "NW_2.3_doping" "NW_doping" "NW_2.3")
(sdedr:define-constant-profile-region "PP_doping" "PP_doping" "PP")

; Define meshing strategy
(sdedr:define-refinement-size "RefDef.Mat.All" 5 5 5 0.5 0.5 0.5)
(sdedr:define-refinement-placement "Ref.Mat.All" "RefDef.Mat.All" (list "material" "Silicon" "material" "PolySi"))
(sdedr:define-refinement-function "RefDef.Mat.All" "DopingConcentration" "MaxTransDiff" 0.05)
(sdedr:define-refinement-function "RefDef.Mat.All" "MaxLenInt" "Silicon" "PolySi" 0.5 1.4)
(sdedr:define-refinement-function "RefDef.Mat.All" "MaxLenInt" "Silicon" "Silicon" 0.5 1.4)

; Mesh the device
(sde:build-mesh "n1")

(system:command "svisual n1_msh.tdr &")

