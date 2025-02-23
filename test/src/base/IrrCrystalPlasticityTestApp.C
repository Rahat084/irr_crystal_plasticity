//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "IrrCrystalPlasticityTestApp.h"
#include "IrrCrystalPlasticityApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
IrrCrystalPlasticityTestApp::validParams()
{
  InputParameters params = IrrCrystalPlasticityApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

IrrCrystalPlasticityTestApp::IrrCrystalPlasticityTestApp(InputParameters parameters) : MooseApp(parameters)
{
  IrrCrystalPlasticityTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

IrrCrystalPlasticityTestApp::~IrrCrystalPlasticityTestApp() {}

void
IrrCrystalPlasticityTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  IrrCrystalPlasticityApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"IrrCrystalPlasticityTestApp"});
    Registry::registerActionsTo(af, {"IrrCrystalPlasticityTestApp"});
  }
}

void
IrrCrystalPlasticityTestApp::registerApps()
{
  registerApp(IrrCrystalPlasticityApp);
  registerApp(IrrCrystalPlasticityTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
IrrCrystalPlasticityTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  IrrCrystalPlasticityTestApp::registerAll(f, af, s);
}
extern "C" void
IrrCrystalPlasticityTestApp__registerApps()
{
  IrrCrystalPlasticityTestApp::registerApps();
}
