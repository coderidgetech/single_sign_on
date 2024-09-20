//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <untitled/untitled_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) untitled_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UntitledPlugin");
  untitled_plugin_register_with_registrar(untitled_registrar);
}
