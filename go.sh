#!/bin/bash
#
BIN=/usr/bin/tofu

OT_DIR=opentf

case $1 in
    ot-init)
        cd $OT_DIR
        $BIN init
        ;;
    ot-plan)
        cd $OT_DIR
        $BIN plan --var-file=../config.tfvars
        ;;
    ot-apply)
        cd $OT_DIR
        $BIN plan --var-file=../config.tfvars
        ;;
    *)
        echo "plan or apply"
        ;;
esac

