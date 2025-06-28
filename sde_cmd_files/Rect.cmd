; Initialise workspace
(sde:clear)

; Create substrate doped regions
(sdegeo:create-polygon (list 
	(position 0 0 0)
	(position 0 -12 0)
	(position -8.5 -12 0)
	(position -8.5 -11 0)
	(position -7 -11 0)
	(position -7 -10 0)
	(position -4 -10 0)
	(position -4 0 0)
	(position 0 0 0)
	)
	"Silicon"
	"Substrate_1"
)

(sdegeo:create-polygon (list
	(position -7 0 0)
	(position -7 -9 0)
	(position -8.5 -9 0)
	(position -8.5 -8 0)
	(position -10 -8 0)
	(position -10 -7 0)
	(position -8.5 -7 0)
	(position -8.5 0 0)
	(position -7 0 0)
	)
	"Silicon"
	"Substrate_2"
)

; Create process doped regions
(sdegeo:create-rectangle (position -4 0 0) (position -7 -10 0) "Silicon" "DNW")
(sdegeo:create-rectangle (position -7 -9 0) (position -8.5 -11 0) "Silicon" "NW")
(sdegeo:create-rectangle (position -8.5 -8 0) (position -10 -12 0) "PolySi" "NP")
(sdegeo:create-rectangle (position -8.5 0 0) (position -10 -7 0) "PolySi" "PP")

; Create oxide layers
(sdegeo:create-rectangle (position -10 -6 0) (position -11 -9.5 0) "Oxide" "Ox")
(sdegeo:create-rectangle (position -10 -10.5 0) (position -11 -12 0) "Oxide" "Ox")

; Define contacts for simulation
(sdegeo:set-contact (find-edge-id (position -10 -2 0)) "anode")
(sdegeo:set-contact (find-edge-id (position -10 -10.2 0)) "cathode")
(sdegeo:set-contact (find-edge-id (position 0 -2 0)) "bulk")

; Create a sweeping path and sweep along it
(define rectangular_path (sdegeo:create-polyline-wire (list
	(position 0 6 0)
	(position 0 6 6)
	(position 0 -6 6)
	(position 0 -6 -6)
	(position 0 6 -6)
	(position 0 6 0)
)))
(sdegeo:sweep (entity:faces (find-material-id "PolySi")) rectangular_path 
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"  ))
(sdegeo:sweep (entity:faces (find-material-id "Silicon")) rectangular_path 
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"  ))
(sdegeo:sweep (entity:faces (find-material-id "Oxide")) rectangular_path 
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"  ))

; Define and set doping profiles
(sdedr:define-constant-profile "NP_doping" "PhosphorusActiveConcentration" 1e+21)
(sdedr:define-constant-profile "DNW_doping" "PhosphorusActiveConcentration" 1e+19)
(sdedr:define-constant-profile "NW_doping" "PhosphorusActiveConcentration" 1e+15)
(sdedr:define-constant-profile "Substrate_doping" "BoronActiveConcentration" 1e+15)
(sdedr:define-constant-profile "PP_doping" "BoronActiveConcentration" 1e+21)

(sdedr:define-constant-profile-material "Substrate_1_doping" "Substrate_doping" "Silicon")
(sdedr:define-constant-profile-material "Substrate_2_doping" "Substrate_doping" "PolySi")
(sdedr:define-constant-profile-region "NP_doping" "NP_doping" "NP")
(sdedr:define-constant-profile-region "DNW_doping" "DNW_doping" "DNW")
(sdedr:define-constant-profile-region "NW_doping" "NW_doping" "NW")
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

