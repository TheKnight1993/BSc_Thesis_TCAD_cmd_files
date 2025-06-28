Device "SPAD"{
File{
	Grid		= "n1_msh.tdr"
	Plot		= "n3_des.tdr"
	Current		= "n3_des.plt"
}

Electrode{
	{ Name="anode"		Voltage=0.0 }
	{ Name="cathode"	Voltage=0.0 }
	{ Name="bulk"	  	Voltage=0.0 }
}

Physics{
	Fermi
	EffectiveIntrinsicDensity( BandGapNarrowing(OldSlotboom) )
	Mobility(
		DopingDep
		eHighFieldsaturation( GradQuasiFermi )
		hHighFieldsaturation( GradQuasiFermi )
		Enormal
	)
	Recombination(
		SRH( DopingDependence )
		Avalanche( ElectricField )
	)
}
} * End of SPAD device

Plot{
	*--Density and Currents, etc
	eDensity hDensity
	TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
	eMobility/Element hMobility/Element
	eVelocity hVelocity
	eQuasiFermi hQuasiFermi

	*--Temperature 
	eTemperature hTemperature Temperature

	*--Fields and charges
	ElectricField/Vector Potential SpaceCharge

	*--Doping Profiles
	Doping DonorConcentration AcceptorConcentration

	*--Generation/Recombination
	SRH Band2Band Auger
	ImpactIonization eImpactIonization hImpactIonization

	*--Driving forces
	eGradQuasiFermi/Vector hGradQuasiFermi/Vector
	eEparallel hEparallel eENormal hENormal

	*--Band structure/Composition
	BandGap 
	BandGapNarrowing
	Affinity
	ConductionBand ValenceBand
	eQuantumPotential hQuantumPotential
}

Math{
	RefDens_eGradQuasiFermi_ElectricField_HFS = 1e12
	RefDens_hGradQuasiFermi_ElectricField_HFS = 1e12
	
	Extrapolate
	ExtendedPrecision
	NumberOfThreads=Maximum
	
	Derivatives
	Avalderivatives
	
	RelErrControl
	Digits=4
	
	Iterations=50
	NotDamped=100
	
}

File{
	Output = "simCV_des.log"
}

System {
	SPAD SPAD1 ( "cathode" = cat "anode" = an "bulk" = bulk)
	
	Vsource_pset vc (cat 0){dc=0}
	Vsource_pset va (an 0){dc=0}
	Vsource_pset vbulk (bulk 0){dc=0}
}

Solve {
	* initial solution
	NewCurrentPrefix="init_"
	Coupled(Iterations=100){ Poisson eQuantumPotential }
	Coupled { Poisson Electron Hole eQuantumPotential }
	
	Save ( FilePrefix = "n2_init" )
	
	NewCurrentPrefix="CV_"
	
	Quasistationary(
		InitialStep=0.1e-3 Increment=2 MinStep=1e-15 MaxStep=0.5
		Goal { Parameter=vc.dc Voltage=40 }
	) 
	{ ACCoupled (
		StartFrequency=1e4 EndFrequency=1e6
		NumberOfPoints=20 Decade
		Node(cat an bulk) Exclude(vc va vbulk)
		) 
		{ Poisson Electron Hole eQuantumPotential } 
	}
}