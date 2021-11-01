#!/bin/bash
#
#
#
usage() {
  cat <<HELP

USAGE: $(basename $0) <stone-name> <index> <total> <path>
Starts a migration task

EXAMPLES
  $(basename $0) stonename 1 8 /home/...../__temp_migration_classes.bm

HELP
}

#
# Enough parameter defined ?
#
if [ $# -ne 4 ]; then
  usage; exit 1
fi

#
# set environement
#
cd
source $GS_HOME/bin/defGsDevKit.env
source $GS_HOME/server/stones/$1/defStone.env $1
if [ -s $GS_HOME/server/stones/$1/product/seaside/etc/gemstone.secret ]; then
    . $GS_HOME/server/stones/$1/product/seaside/etc/gemstone.secret
else
    echo 'Missing password file $GS_HOME/server/stones/$1/defStone.env'
    exit 1
fi

cat << EOF | topaz -l -T 500000 -u dev_migrate_migrator_${1}_${2}_${3}
set user DataCurator pass $GEMSTONE_CURATOR_PASS gems $GEMSTONE_NAME
iferror where
login
doit
|  migrator|
migrator := MSKMigrater
                migrator: '${4}'
                workerIndexOneBased: ${2}
                workerTotal: ${3}
                transactionStepSize: 500.
migrator migrate
%
EOF
