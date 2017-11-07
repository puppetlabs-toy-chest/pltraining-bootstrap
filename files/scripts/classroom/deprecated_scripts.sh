#! /bin/sh
case `basename "$0"` in
  reset_file_sync_services.sh)
    echo "Please use 'classroom reset filesync' instead."
    ;;

  reset_password.rb)
    echo "Please use 'classroom reset password' instead."
    ;;

  reset_ssl_certificates.sh)
    echo "Please use 'classroom reset certificates' instead."
    ;;

  restart_classroom_services.rb)
    echo "Please use 'classroom restart ${1}' instead."
    ;;

  troubleshooting)
    echo "Please use 'classroom troubleshoot' instead."
    ;;

  *)
    echo "This script exists only to tell you about modern alternative to deprecated scripts."
    exit 1

esac
