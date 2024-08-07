# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="An OSS column-oriented database management system for real-time data analysis"
HOMEPAGE="https://clickhouse.com/"
LICENSE="Apache-2.0"

SRC_URI="https://packages.clickhouse.com/tgz/stable/clickhouse-common-static-${PV}-${ARCH}.tgz
	server? ( https://packages.clickhouse.com/tgz/stable/clickhouse-server-${PV}-${ARCH}.tgz )
	client?	( https://packages.clickhouse.com/tgz/stable/clickhouse-client-${PV}-${ARCH}.tgz )
"
RESTRICT="primaryuri"
QA_PRESTRIPPED="/usr/bin/clickhouse /usr/bin/clickhouse-library-bridge /usr/bin/clickhouse-odbc-bridge"

SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="+client +server"
REQUIRED_USE="
	|| ( client server )
"

DEPEND="
	acct-group/clickhouse
	acct-user/clickhouse
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/"

src_install() {
	dobin clickhouse-common-static-${PV}/usr/bin/clickhouse
	#dobin clickhouse-common-static-${PV}/usr/bin/clickhouse-odbc-bridge
	#dobin clickhouse-common-static-${PV}/usr/bin/clickhouse-library-bridge
	dosym clickhouse /usr/bin/clickhouse-extract-from-config

	if use client; then
		doins -r clickhouse-client-${PV}/etc
		insinto /usr/bin
		doins clickhouse-client-${PV}/usr/bin/*
	fi

	if use server; then
		insinto /etc
		doins -r clickhouse-server-${PV}/etc/clickhouse-server
		insinto /usr/bin
		doins clickhouse-server-${PV}/usr/bin/*

		newinitd "${FILESDIR}"/clickhouse-server.initd clickhouse-server
		systemd_dounit "${FILESDIR}"/clickhouse-server.service

		keepdir /var/log/clickhouse-server

	fi
}

pkg_preinst() {
	if use server; then
		fowners clickhouse:clickhouse /var/log/clickhouse-server
	fi
}
