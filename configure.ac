#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.


AC_PREREQ(2.52)

m4_define([required_apertium_version], [3.1.0])

AC_INIT([apertium-id-ms], [0.1.0], [raymhs91@gmail.com])
AM_INIT_AUTOMAKE([apertium-id-ms], [0.1.0], no-define)
AC_PROG_LN_S
AC_PROG_AWK
AC_CONFIG_HEADER([config])


AC_DEFUN([PKG_CHECK_APERTIUM], [
  APERTIUM_VER=0
  PKG_CHECK_MODULES(APERTIUM, apertium-1.0 >= 1.0.0,
  [
      APERTIUM_VER=10
  ],
  [
      PKG_CHECK_MODULES(APERTIUM, apertium-2.0 >= 2.0.0,
      [
          APERTIUM_VER=20
      ],
      [
          PKG_CHECK_MODULES(APERTIUM, apertium-3.0 >= 3.0.0,
          [
              APERTIUM_VER=30
          ],
          [
              PKG_CHECK_MODULES(APERTIUM, apertium-3.1 >= 3.1.0,
              [
                APERTIUM_VER=31
              ],
              [
                PKG_CHECK_MODULES(APERTIUM, apertium-3.2 >= 3.2.0)
                APERTIUM_VER=32
              ])
          ])
      ])
  ])
  AC_SUBST(APERTIUM_VER)
])

PKG_CHECK_APERTIUM

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
