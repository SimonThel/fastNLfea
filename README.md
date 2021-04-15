# fastNLfea

Fast and efficient Matlab code for geometric nonlinear Finite Element Analysis tailored for Topology Optimization.

## Requierments

* Matlab 2020b or newer 
* `fsparse` from Stefan Engblom's Matlab libraries [stenglib](https://github.com/stefanengblom/stenglib)

## Current Capabilities 

This code solves fast and efficiently geometric nonlinear FEA problems with a linear material model. **fasNLfea** is successfully applied to initial wing design using topology optimization with predefined nonlinear behavior. This code is tailored for topology optimization. It assumes a uniform mesh with the dimension `nelx*nely*nelz`. Every element has a density `xPhys`. This density describes the topology of the domain. The element stiffness is determined by the SIMP material model. An energy interpolation scheme reduces mesh distortion for low stiffness/void elements.

**fasNLfea** is a great starting point for researchers and students in geometric nonlinear topology optimization. Its computational efficiency enables the solution of topology optimization problems within hours instead of days.

## Future Features/Development

1. Improving computation time
2. Testing of 3-dim grids
3. Adding and publishing validation (only validation for 2-dim case in thesis)
4. Adding sensitivity analysis

## References

Code base from: 
 * N. H. Kim, "Introduction to nonlinear finite element analysis". 2015. DOI: 10.1007/978-1-4419-1746-1
 
 Node numebering scheme from:
 * F. Ferrari and O. Sigmund, “A new generation 99 line Matlab code for compliance topology optimization and its extension to 3D,” Struct. Multidiscip. Optim., vol. 62, no. 4, pp. 2211–2228, 2020, doi: 10.1007/s00158-020-02629-w.
 
 SIMP method from:
 * M. P. Bendsøe and O. Sigmund, “Material interpolation schemes in topology optimization,” Arch. Appl. Mech., vol. 69, no. 9–10, pp. 635–654, 1999, doi: 10.1007/s004190050248.
 
 Sensitivity analysis in part from:
 * J. Lee, T. Detroux, and G. Kerschen, “Enforcing a force-displacement curve of a nonlinear structure using topology optimization with slope constraints,” Appl. Sci., vol. 10, no. 8, 2020, doi: 10.3390/APP10082676.

 Energy interpolation scheme from:
 * F. Wang, B. S. Lazarov, O. Sigmund, and J. S. Jensen, “Interpolation scheme for fictitious domain techniques and topology optimization of finite strain elastic problems,” Comput. Methods Appl. Mech. Eng., vol. 276, pp. 453–472, 2014, doi: 10.1016/j.cma.2014.03.021.
 
