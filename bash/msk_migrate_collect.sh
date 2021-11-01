#!/bin/bash
#
#
usage() {
  cat <<HELP

USAGE: $(basename $0) <stone-name> <path>
migrates instances according to IDs in a specific file

EXAMPLES
  $(basename $0) stonename /home/...../__temp_migration_classes.bm

HELP
}

#
# Enough parameter defined ?
#
if [ $# -ne 2 ]; then
  usage; exit 1
fi

#
# Set the Gemstone environment
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

echo 'Creating the GsBitmap File'

cat << EOF | topaz -l -T 4000000 -u dev_migrate_collector_${1}
set user DataCurator pass $GEMSTONE_CURATOR_PASS gems $GEMSTONE_NAME
iferror where
login
doit
| domainClassesToConsider migrator|
domainClassesToConsider := GWCProject classCreated select: [ :eachClass | eachClass isSubclassOf: GWCProject projectPersistentMasterClass ].
domainClassesToConsider add: GWCProject.
migrator := MSKMigrater collector: '${2}' classes: domainClassesToConsider fastMode: true.
migrator createGsBitmapFile.
%
EOF
