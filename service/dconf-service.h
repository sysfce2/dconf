/*
 * Copyright © 2009 Codethink Limited
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of version 3 of the GNU General Public License as
 * published by the Free Software Foundation.
 *
 * See the included COPYING file for more information.
 *
 * Authors: Ryan Lortie <desrt@desrt.ca>
 */

#ifndef _dconf_service_h_
#define _dconf_service_h_

#include <glib.h>

typedef struct OPAQUE_TYPE__DConfService                    DConfService;

typedef enum
{
  DCONF_SERVICE_SESSION_BUS,
  DCONF_SERVICE_SYSTEM_BUS
} DConfServiceBusType;

DConfService *          dconf_service_new                               (const gchar   *name,
                                                                         GError       **error);

const gchar            *dconf_service_get_bus_name                      (DConfService  *service);
DConfServiceBusType     dconf_service_get_bus_type                      (DConfService  *service);

gboolean                dconf_service_set                               (DConfService  *service,
                                                                         const gchar   *key,
                                                                         GVariant      *value,
                                                                         guint32       *sequence,
                                                                         GError       **error);

gboolean                dconf_service_set_locked                        (DConfService  *service,
                                                                         const gchar   *key,
                                                                         gboolean       locked,
                                                                         GError       **error);

gboolean                dconf_service_merge                             (DConfService  *service,
                                                                         const gchar   *prefix,
                                                                         const gchar  **names,
                                                                         GVariant     **values,
                                                                         gint           n_items,
                                                                         guint32       *sequence,
                                                                         GError       **error);

#endif /* _dconf_service_h_ */
