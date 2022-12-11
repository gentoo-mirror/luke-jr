# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Automatic speech recognition (ASR) models in whisper-cpp's ggml format"
HOMEPAGE="https://huggingface.co/datasets/ggerganov/whisper.cpp"
LICENSE="MIT"

SRC_URI="
	whisper_models_base-en? ( https://huggingface.co/datasets/ggerganov/whisper.cpp/resolve/2913f38099001306a20524ed6cd68630b6dfd31e/ggml-base.en.bin -> ${P}-base.en.bin )
	whisper_models_base? ( https://huggingface.co/datasets/ggerganov/whisper.cpp/resolve/2913f38099001306a20524ed6cd68630b6dfd31e/ggml-base.en.bin -> ${P}-base.bin )
	whisper_models_large? ( https://huggingface.co/datasets/ggerganov/whisper.cpp/resolve/2913f38099001306a20524ed6cd68630b6dfd31e/ggml-large.bin -> ${P}-large.bin )
"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

S="${WORKDIR}"

IUSE="+whisper_models_base-en whisper_models_base whisper_models_large"
# TODO (when someone has time to download to get Manifest hashes): large_v1 medium medium_en small small_en tiny tiny_en

REQUIRED_USE="|| ( whisper_models_base-en whisper_models_base whisper_models_large )"

src_install() {
	insinto /usr/share/whisper/ggml-models/
	local f
	for f in $A; do
		# Install directly from DISTDIR to avoid excess copying and needing even more free space
		newins "$(realpath "$DISTDIR/$f")" "${f/*-/}"
	done
}
