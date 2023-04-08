git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
#echo 'Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc.'
sed -i 's#ZSH_THEME=.*#ZSH_THEME="powerlevel10k/powerlevel10k"#1' ~/.zshrc && echo "success"

