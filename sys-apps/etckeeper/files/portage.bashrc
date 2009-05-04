case "$EBUILD_PHASE" in
"preinst" | "prerm" )
	if [ -x /usr/sbin/etckeeper ]; then
		etckeeper pre-install
	fi
	;;
"postinst" | "postrm" )
	if [ -x /usr/sbin/etckeeper ]; then
		etckeeper post-install
	fi
	;;
esac