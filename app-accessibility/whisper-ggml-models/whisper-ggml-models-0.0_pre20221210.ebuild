# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Automatic speech recognition (ASR) models in whisper-cpp's ggml format"
HOMEPAGE="https://huggingface.co/ggerganov/whisper.cpp"
LICENSE="MIT"

SRC_URI="
	whisper_models_base-en? ( https://huggingface.co/ggerganov/whisper.cpp/resolve/80da2d8bfee42b0e836fc3a9890373e5defc00a6/ggml-base.en.bin -> ${P}-base.en.bin )
	whisper_models_base? ( https://huggingface.co/ggerganov/whisper.cpp/resolve/80da2d8bfee42b0e836fc3a9890373e5defc00a6/ggml-base.bin -> ${P}-base.bin )
	whisper_models_large? ( https://huggingface.co/ggerganov/whisper.cpp/resolve/80da2d8bfee42b0e836fc3a9890373e5defc00a6/ggml-large.bin -> ${P}-large.bin )
	whisper_models_large-v2? ( https://huggingface.co/ggerganov/whisper.cpp/resolve/80da2d8bfee42b0e836fc3a9890373e5defc00a6/ggml-large.bin -> ${P}-large-v2.bin )
"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

S="${WORKDIR}"

IUSE="+whisper_models_base-en whisper_models_base whisper_models_large whisper_models_large-v2"
# TODO (when someone has time to download to get Manifest hashes): medium medium-en small small-en tiny tiny-en

REQUIRED_USE="|| ( whisper_models_base-en whisper_models_base whisper_models_large whisper_models_large-v2 )"

src_install() {
	insinto /usr/share/whisper/ggml-models/
	local f
	for f in $A; do
		# Install directly from DISTDIR to avoid excess copying and needing even more free space
		newins "$(realpath "$DISTDIR/$f")" "${f#${P}-}"
	done
}
