PATH=/data/adb/ksu/bin:$PATH

## susfs_clone_perm <file/or/dir/perm/to/be/changed> <file/or/dir/to/clone/from>
susfs_clone_perm() {
	TO=$1
	FROM=$2
	if [ -z "${TO}" -o -z "${FROM}" ]; then
		return
	fi
	## stat https://github.com/backslashxx/bindhosts/commit/427f18fe0b212ef2754e79c8aaaa72cb59ad253d#diff-8cb0da3b1680ce3a9f3263622042aa6f0250431fa5069513664650a17c48fdabR15
	CLONED_PERM_STRING=$(stat -c "%a %U %G" ${FROM})
	set ${CLONED_PERM_STRING}
	chmod $1 ${TO}
	chown $2:$3 ${TO}
	busybox chcon --reference=${FROM} ${TO}
}

resetprop_n() {
	resetprop -n $1 $2
}

if_prop_value_exits_resetprop_n() {
	local PROP_NAME=$1
  local EXPECTED_VALUE=$2
  local CURRENT_VALUE=$(resetprop "${PROP_NAME}")

	[ -z "${CURRENT_VALUE}" ] || [ "${CURRENT_VALUE}" = "${EXPECTED_VALUE}" ] || resetprop -n "${PROP_NAME}" "${EXPECTED_VALUE}"
}

# if_contains_resetprop_n() {
# 	local PROP_NAME=$1
#   local CONTAINS_VALUE=$2
#   local NEW_VALUE=$3

#   [[ "$(resetprop ${PROP_NAME})" = *"${CONTAINS_VALUE}"* ]] && resetprop -n "${PROP_NAME}" "${NEW_VALUE}"
# }

# EOF
