#include "IrrCrystalPlasticityApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
IrrCrystalPlasticityApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

IrrCrystalPlasticityApp::IrrCrystalPlasticityApp(InputParameters parameters) : MooseApp(parameters)
{
  IrrCrystalPlasticityApp::registerAll(_factory, _action_factory, _syntax);
}

IrrCrystalPlasticityApp::~IrrCrystalPlasticityApp() {}

void
IrrCrystalPlasticityApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<IrrCrystalPlasticityApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"IrrCrystalPlasticityApp"});
  Registry::registerActionsTo(af, {"IrrCrystalPlasticityApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
IrrCrystalPlasticityApp::registerApps()
{
  registerApp(IrrCrystalPlasticityApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
IrrCrystalPlasticityApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  IrrCrystalPlasticityApp::registerAll(f, af, s);
}
extern "C" void
IrrCrystalPlasticityApp__registerApps()
{
  IrrCrystalPlasticityApp::registerApps();
}
