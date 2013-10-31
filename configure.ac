#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.


AC_PREREQ(2.52)

m4_define([required_apertium_version], [3.1.0])

AC_INIT([apertium-id-ms], [0.1.0], [raymhs91@gmail.com])
AM_INIT_AUTOMAKE([apertium-id-ms], [0.1.0], no-define)
AC_PROG_LN_S
AC_PROG_AWK
AC_CONFIG_HEADER([config])


PKG_CHECK_MODULES(APERTIUM,   apertium >= required_apertium_version, [], [PKG_CHECK_MODULES(APERTIUM,   apertium-3.2 >= required_apertium_version)])


AC_PATH_PROG(XSLTPROC, xsltproc, no)
if test x$ac_cv_path_XSLTPROC = x
then
  AC_MSG_ERROR([You don't have xsltproc installed.])
fi
if test x$ac_cv_path_XSLTPROC = xno
then
  AC_MSG_ERROR([You don't have xsltproc installed.])
fi
                     
AC_OUTPUT([Makefile])
