IrrCrystalPlasticity
=====

Fork "IrrCrystalPlasticity" to create a new MOOSE-based application.

For more information see: [https://mooseframework.org/getting_started/new_users.html#create-an-app](https://mooseframework.org/getting_started/new_users.html#create-an-app)
# main branch 
Only Slip Based Deformation  
* Slip Rate Equation
    * Power Law  $$ \dot\gamma = \dot \gamma_0 {\frac{ \tau^{\alpha} }{g^{\alpha}}}^{frac{1}{m}} $$
* Slip Rassistance 
    * Strain Hardeing Component
	* Kocks-Mecking Hardening
    * Irradiation Hardening
	* Evolution of Damage Loop Density
# Orowan brach
* Slip Rate Equation
    * Orowans Law of slip/shear rate
	* Velocity function
# Twinnning branch
* Twin component of slip rate 
* Temprature modulated interpolation
