#ifndef HEADER_CURL_CONFIG_MAC_H
#define HEADER_CURL_CONFIG_MAC_H
/***************************************************************************
 *                                  _   _ ____  _
 *  Project                     ___| | | |  _ \| |
 *                             / __| | | | |_) | |
 *                            | (__| |_| |  _ <| |___
 *                             \___|\___/|_| \_\_____|
 *
 * Copyright (C) 1998 - 2022, Daniel Stenberg, <daniel@haxx.se>, et al.
 *
 * This software is licensed as described in the file COPYING, which
 * you should have received as part of this distribution. The terms
 * are also available at https://curl.se/docs/copyright.html.
 *
 * You may opt to use, copy, modify, merge, publish, distribute and/or sell
 * copies of the Software, and permit persons to whom the Software is
 * furnished to do so, under the terms of the COPYING file.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 * SPDX-License-Identifier: curl
 *
 ***************************************************************************/

/* =================================================================== */
/*                Hand crafted config file for Mac OS 9                */
/* =================================================================== */
/*  On Mac OS X you must run configure to generate curl_config.h file  */
/* =================================================================== */

#define OS "mac"

/* Define if you want the built-in manual */
#define USE_MANUAL              1

#define HAVE_ERRNO_H            1
#define HAVE_NETINET_IN_H       1
#define HAVE_SYS_SOCKET_H       1
#define HAVE_SYS_SELECT_H       1
#define HAVE_NETDB_H            1
#define HAVE_ARPA_INET_H        1
#define HAVE_UNISTD_H           1
#define HAVE_NET_IF_H           1
#define HAVE_SYS_TYPES_H        1
#define HAVE_GETTIMEOFDAY       1
#define HAVE_FCNTL_H            1
#define HAVE_SYS_STAT_H         1
#define HAVE_STDLIB_H           1
#define HAVE_TIME_H             1
#define HAVE_UTIME_H            1
#define HAVE_SYS_TIME_H         1
#define HAVE_SYS_UTIME_H        1

#define TIME_WITH_SYS_TIME      1

#define HAVE_ALARM              1
#define HAVE_FTRUNCATE          1
#define HAVE_UTIME              1
#define HAVE_SELECT             1
#define HAVE_SOCKET             1
#define HAVE_STRUCT_TIMEVAL     1

#define HAVE_SIGACTION          1
#define HAVE_SIGNAL_H           1

#define CURL_DISABLE_LDAP       1

#define HAVE_RAND_EGD           1

#define HAVE_FCNTL_O_NONBLOCK      1

#define SIZEOF_INT              4
#define SIZEOF_SIZE_T           4
#define SIZEOF_CURL_OFF_T 8

#define HAVE_RECV 1
#define RECV_TYPE_ARG1 int
#define RECV_TYPE_ARG2 void *
#define RECV_TYPE_ARG3 size_t
#define RECV_TYPE_ARG4 int
#define RECV_TYPE_RETV ssize_t

#define HAVE_SEND 1
#define SEND_TYPE_ARG1 int
#define SEND_QUAL_ARG2 const
#define SEND_TYPE_ARG2 void *
#define SEND_TYPE_ARG3 size_t
#define SEND_TYPE_ARG4 int
#define SEND_TYPE_RETV ssize_t

#endif /* HEADER_CURL_CONFIG_MAC_H */