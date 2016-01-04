#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.


AC_PREREQ(2.52)

m4_define([required_apertium_version], [3.3.0])
m4_define([required_lttoolbox_version], [3.3.0])

AC_INIT([apertium-id-ms], [0.1.1], [raymhs91@gmail.com])
AM_INIT_AUTOMAKE([apertium-id-ms], [0.1.1], no-define)
AC_PROG_LN_S
AC_PROG_AWK
AC_CONFIG_HEADER([config])


PKG_CHECK_MODULES(APERTIUM,   apertium >= required_apertium_version)
PKG_CHECK_MODULES(LTTOOLBOX, lttoolbox >= required_lttoolbox_version)


AP_MKINCLUDE

AC_OUTPUT([Makefile])
