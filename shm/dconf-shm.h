/*
 * Copyright © 2010 Codethink Limited
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the licence, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Author: Ryan Lortie <desrt@desrt.ca>
 */

#ifndef __dconf_shm_h__
#define __dconf_shm_h__

#include <glib.h>

G_GNUC_INTERNAL
const gchar *           dconf_shm_get_shmdir                            (void);

G_GNUC_INTERNAL
guint8 *                dconf_shm_open                                  (const gchar *name);
G_GNUC_INTERNAL
void                    dconf_shm_close                                 (guint8      *shm);
G_GNUC_INTERNAL
void                    dconf_shm_flag                                  (const gchar *name);

static inline gboolean
dconf_shm_is_flagged (const guint8 *shm)
{
  return shm == NULL || *shm != 0;
}

G_GNUC_INTERNAL
gboolean                dconf_shm_homedir_is_native                     (void);

#endif /* __dconf_shm_h__ */
