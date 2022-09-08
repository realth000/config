#!/bin/bash

echo 'Download oh-my-zsh plugins'

cat <<EOF
choose download source:
1. gitee
2. github
EOF


while true
do
	echo -n 'choose [1/2] '
	read S
	case $S in
	1)
		DOWNLOAD_SOURCE='gitee'
		break
		;;
	2)
		DOWNLOAD_SOURCE='github'
		break
		;;
	*)
	#	echo 'invalid choose'
		;;
	esac
done


case ${DOWNLOAD_SOURCE} in
	'gitee')
		D_SUGGUEST_URL='https://gitee.com/mirror-github/zsh-autosuggestions.git'
		D_HIGHLIGHT_URL='https://gitee.com/mirror-github/zsh-syntax-highlighting'
		;;
	'github')
		D_SUGGUEST_URL='https://github.com/zsh-users/zsh-autosuggestions'
		D_HIGHLIGHT_URL='https://github.com/zsh-users/zsh-syntax-highlighting.git'
		;;
	*)
		echo "Unknown download source \"${DOWNLOAD_SOURCE}\", exit"
		exit 1
		;;
esac

D_SUGGEST_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
D_HIGHLIGHT_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo 'Install zsh-autosuggestions'
if [ -d ${D_SUGGEST_DIR} ];then
	echo 'clear old repo'
	rm -rf ${D_SUGGEST_DIR}
fi

#git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone ${D_SUGGUEST_URL} ${D_SUGGEST_DIR}

echo 'Install zsh-syntax-highlighting'
if [ -d ${D_HIGHLIGHT_DIR} ];then
	echo 'clear old repo'
	rm -rf ${D_HIGHLIGHT_DIR}
fi
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone ${D_HIGHLIGHT_URL} ${D_HIGHLIGHT_DIR}

#echo 'download zsh-autosuggestions zsh-syntax-highlighting success'

sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/1' ~/.zshrc && echo "success"

