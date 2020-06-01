# Overview of the reference implementation

The reference implementation allows applying two specific DMPC algorithms to the AHU and the test hall use case. 

## System
The System module is used to generate a set of subsystems (agents) that perform the actual control task. It is also useful to define the overall algorithm. In the reference implementation, this algorithm is called BExMoC and simply inherits from the System class. 

## Subsystem
The Subsystem module contains the definition of the subsystems (agents). In the BaseSubsystem class, only the main model types are defined. 