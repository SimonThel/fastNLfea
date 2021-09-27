# fastNLfea

Fast and efficient Matlab code for geometric nonlinear Finite Element Analysis tailored for Topology Optimization.

## Requirements

* Matlab 2020b or newer 
* `fsparse` from Stefan Engblom's Matlab libraries [stenglib](https://github.com/stefanengblom/stenglib)

If you have Matlab 2020a or earlier, please use the code in the branch `mex-development`. This version does not use the newly introduces `pagemtimes` function. However, this implementation relies on `for`-loops for the matrix multiplication and, thus, is much slower (around 4 to 5 times). From this code, you can derive C/C++ code to run on other machines.  

Please note the different license type of the C files. These files are only for an academic application because an academic license of Matlab was used to generate them.

## Current Capabilities 

### Finite Element Analysis

This code solves fast and efficiently geometric nonlinear FEA problems with a linear material model (St. Venant Kirchhoff). **fasNLfea** is successfully applied to the initial wing design using topology optimization with predefined nonlinear behavior. This code is tailored for topology optimization. It assumes a uniform mesh with the dimension `nelx*nely*nelz`. Every element has a density `xPhys`. This density describes the topology of the domain. The element stiffness is determined by the SIMP material model. An energy interpolation scheme reduces mesh distortion for low stiffness/void elements.

**fastNLfea** is a great starting point for researchers and students in geometric nonlinear topology optimization. Its computational efficiency enables the solution of topology optimization problems within hours instead of days.

The results of **fastNLfea** have been [validated](https://github.com/SimonThel/fastNLfea/blob/main/vailidation/finite_element/VALIDATION.md) with the commercial software Abaqus and examples from the literature.

### Sensitivity Analysis

Additionally, **fastNLfea** provides the sensitivities with respect to the element densitiy `xPhys` from common objective functions/constraints that are based on the displacement of the topology. The sensitivity analysis of two different functions are implemented:
1. ![c_{lin}=\mathbf{l}^{T}\mathbf{u}](https://latex.codecogs.com/svg.latex?&space;c_{lin}=\mathbf{l}^{T}\mathbf{u})
2. ![c_{quad}=(\mathbf{l}^{T}\mathbf{u}-g)^2](https://latex.codecogs.com/svg.latex?&space;c_{quad}=(\mathbf{l}^{T}\mathbf{u}-g)^2)

The vector ![\mathbf{l}^{T}](https://latex.codecogs.com/svg.latex?&space;\mathbf{l}^{T}) "picks" the desired DOFs from ![\mathbf{u}](https://latex.codecogs.com/svg.latex?&space;\mathbf{u}). In case of compliance minimization, ![\mathbf{l}^{T}](https://latex.codecogs.com/svg.latex?&space;\mathbf{l}^{T}) becomes the external force vector.

The sensitivities are computed efficiently by caching and reusing the decomposition of the tangent stiffnes matrix in the FEA. The implementation can be [numerically validated](https://github.com/SimonThel/fastNLfea/blob/main/vailidation/sensitivity/sensitivity_valid.m) with the forward difference method.

## References

Code base from: 
 * N. H. Kim, "Introduction to nonlinear finite element analysis". 2015. DOI: 10.1007/978-1-4419-1746-1
 
 Node numebering scheme from:
 * F. Ferrari and O. Sigmund, “A new generation 99 line Matlab code for compliance topology optimization and its extension to 3D,” Struct. Multidiscip. Optim., vol. 62, no. 4, pp. 2211–2228, 2020, doi: 10.1007/s00158-020-02629-w.
 
 SIMP method from:
 * M. P. Bendsøe and O. Sigmund, “Material interpolation schemes in topology optimization,” Arch. Appl. Mech., vol. 69, no. 9–10, pp. 635–654, 1999, doi: 10.1007/s004190050248.
 
 Energy interpolation scheme from:
 * F. Wang, B. S. Lazarov, O. Sigmund, and J. S. Jensen, “Interpolation scheme for fictitious domain techniques and topology optimization of finite strain elastic problems,” Comput. Methods Appl. Mech. Eng., vol. 276, pp. 453–472, 2014, doi: 10.1016/j.cma.2014.03.021.
 
