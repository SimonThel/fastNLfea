# Validation using Abaqus
 ## Defintion of load cases
 
 The results of **fastNLfea** are compared to the commercial software Abaqus. Two load cases are compared: 
 * Load case 1 (L1) is a slim cantilever, which is clamped at `y=0`. On its other side an asymmetric area load is applied. 
   This load case tests the capabilities of **fastNLfea** display roation/torsion.
 * Load case 1 (L1) is a short cantilever, which si clamped at `y=0`. A symmetric area load is applied on the free end of the beam. 
   This load case was chosen to rule out locking as a possibility for different results. Two different resolutions are investigated to analyze convergence.
 
 ## Results
 
 The results of Abaqus and **fastNLfea** differ by up to 8%. Both solvers converge towards different results because a higher resulution does not reduce the difference.
 A possible explanation for this is different consitutive realtions. **fastNLfea** is based on the [St. Venant-Kirchhoff hyperelastic material model](https://en.wikipedia.org/wiki/Hyperelastic_material#Saint_Venant–Kirchhoff_model).
 This consitutive law is based on a linear relation between the 2nd Piola Kirchhoff stress tensor and the Lagrangian strain tensor. However, Abaqus uses a 
 [hypoelastic](https://en.wikipedia.org/wiki/Hypoelastic_material) material based on a linear relation between the Cauchy stress and the engineering strain. St. Venant-Kirchhoff material model is not implemented in Abaqus.
 
 
 # Validation using Literature 
 
 The file `one_element.m` represents the uniaxial bar example in [1] (example 3.8, p. 170). 
 The result of **fastNLfea** is within a marign of error of less than 0.1% of the results published in [1].
 
 [1] N. H. Kim, "Introduction to nonlinear finite element analysis". 2015. DOI: 10.1007/978-1-4419-1746-1
