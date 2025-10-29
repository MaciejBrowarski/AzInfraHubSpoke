#!/bin/bash
#
BIN=/usr/bin/tofu


OT_DIR=opentf/$1

case $2 in
    ot-fmt)
        cd $OT_DIR
        $BIN fmt
        ;;
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
        $BIN apply --var-file=../config.tfvars
        ;;
    ot-state)
        cd $OT_DIR
        $BIN state list --var-file=../config.tfvars
        ;;
    ot-output)
        cd $OT_DIR
        $BIN output --var-file=../config.tfvars -show-sensitive
        ;;
    ot-destroy)
        cd $OT_DIR
        $BIN destroy --var-file=../config.tfvars
        ;;
    *)
        echo "plan or apply"
        ;;
esac

