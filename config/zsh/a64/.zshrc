#################################################
#
#  BASIC Setting
#

# zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  autoload -Uz compinit
  compinit
fi

#################################################
#
#  補完機能設定
#

#  補完機能を使用する
autoload -U compinit
compinit
zstyle ':completion::complete:*' use-cache true

#  zstyle ':completion:*:default' menu select true
zstyle ':completion:*:default' menu select=1

#  大文字、小文字を区別せず補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#  補完でカラーを使用する
autoload colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

#  kill の候補にも色付き表示
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

# Search path for sudo completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                           /usr/local/bin  \
                                           /usr/sbin       \
                                           /usr/bin        \
                                           /sbin           \
                                           /bin            \
                                           /usr/X11R6/bin
#  予測入力させる
autoload predict-on
zle -N predict-on
zle -N predict-off
bindkey '^X^P' predict-on
bindkey '^O' predict-off
zstyle ':predict' verbose true

#  入力途中の履歴補完
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#  履歴のインクリメンタル検索でワイルドカード利用可能
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

#################################################
#
#  PROMPT Setting
#

#-----------------------------------------------
#  starship
#-----------------------------------------------

# https://starship.rs/ja-JP
eval "$(starship init zsh)"

autoload -Uz promptinit
colors

#エディタでライン編集
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

#  ヒストリーサイズ設定
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

#  ヒストリの一覧を読みやすい形に変更
HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "

#  補完リストが多いときに尋ねない
LISTMAX=1000

#  "|,:"を単語の一部とみなさない
WORDCHARS="$WORDCHARS|:"

#  入力途中の履歴補完を有効化する
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

#  character-searchをbashと同じ挙動にする
bindkey '^]'   vi-find-next-char
bindkey '^[^]' vi-find-prev-char

#  タブキーの連打で自動的にメニュー補完
setopt AUTO_MENU
#  ディレクトリ名のみ入力時、cdを適応させる
setopt AUTO_CD
#  "~$var" でディレクトリにアクセス
setopt AUTO_NAME_DIRS
#  補完が/で終って、つぎが、語分割子か/かコマンドの後(;とか&)だったら、補完末尾の/を取る
unsetopt AUTO_REMOVE_SLASH
#  曖昧な補完で、自動的に選択肢をリストアップ
setopt AUTO_LIST
#  変数名を補完する
setopt AUTO_PARAM_KEYS
#  プロンプト文字列で各種展開を行なう
setopt PROMPT_SUBST
# サスペンド中のプロセスと同じコマンド名を実行した場合はリジュームする
setopt AUTO_RESUME
#  rm * などの際確認しない
setopt rm_star_silent
#  ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt MARK_DIRS
#  明確なドットの指定なしで.から始まるファイルをマッチ
setopt GLOBDOTS
#  行の末尾がバッククォートでも無視する
setopt SUN_KEYBOARD_HACK
#  ~hoge以外にマッチする機能を使わない
setopt EXTENDED_GLOB
#  補完対象のファイルの末尾に識別マークをつける
setopt LIST_TYPES
#  BEEPを鳴らさない
setopt NO_BEEP
#  補完候補など表示する時はその場に表示し、終了時に画面から消す
setopt ALWAYS_LAST_PROMPT
#  cd kotaで/home/kotaに移動する
setopt CDABLE_VARS
#  クォートされていない変数拡張が行われたあとで、フィールド分割
setopt SH_WORD_SPLIT
#  定義された全ての変数は自動的にexportする
setopt ALL_EXPORT
#  ディレクトリ名を補完すると、末尾がスラッシュになる。
setopt AUTO_PARAM_SLASH
#  普通のcdでもスタックに入れる
setopt AUTO_PUSHD
#  コマンドのスペルの訂正を使用する
setopt CORRECT
#  引数のスペルの訂正を使用する
unsetopt CORRECT_ALL
#  aliasを展開して補完
unsetopt COMPLETE_ALIASES
#  "*" にドットファイルをマッチ
unsetopt GLOB_DOTS
#  補完候補を詰めて表示
setopt LIST_PACKED
#  ディレクトリスタックに、同じディレクトリを入れない
setopt PUSHD_IGNORE_DUPS
#  ^Dでログアウトしないようにする
unsetopt IGNORE_EOF
#  ジョブの状態をただちに知らせる
setopt NOTIFY
#  複数のリダイレクトやパイプに対応
setopt MULTIOS
#  ファイル名を数値的にソート
setopt NUMERIC_GLOB_SORT
#  リダイレクトで上書き禁止
unsetopt NOCLOBBER
#  =以降でも補完できるようにする
setopt MAGIC_EQUAL_SUBST
#  補完候補リストの日本語を正しく表示
setopt PRINT_EIGHT_BIT
#  右プロンプトに入力がきたら消す
setopt TRANSIENT_RPROMPT
#  戻り値が0以外の場合終了コードを表示
unsetopt PRINT_EXIT_VALUE
#  echo {a-z}などを使えるようにする
setopt BRACE_CCL
#  !!などを実行する前に確認する
setopt HISTVERIFY
#  余分な空白は詰めて記録
setopt HIST_IGNORE_SPACE
#  ヒストリファイルを上書きするのではなく、追加するようにする
setopt APPEND_HISTORY
#  ジョブがあっても黙って終了する
setopt NO_CHECK_JOBS
#  ヒストリに時刻情報もつける
setopt EXTENDED_HISTORY
#  履歴がいっぱいの時は最も古いものを先ず削除
setopt HIST_EXPIRE_DUPS_FIRST
#  履歴検索中、重複を飛ばす
setopt HIST_FIND_NO_DUPS
#  ヒストリリストから関数定義を除く
setopt HIST_NO_FUNCTIONS
#  前のコマンドと同じならヒストリに入れない
setopt HIST_IGNORE_DUPS
#  重複するヒストリを持たない
setopt HIST_IGNORE_ALL_DUPS
#  実行するまえに必ず展開結果を確認できるようにする
setopt HIST_VERIFY
#  履歴をインクリメンタルに追加
setopt INC_APPEND_HISTORY
#  history コマンドをヒストリに入れない
unsetopt HIST_NO_STORE
#  履歴から冗長な空白を除く
setopt HIST_REDUCE_BLANKS
#  履歴を共有
setopt SHARE_HISTORY
#  古いコマンドと同じものは無視
setopt HIST_SAVE_NO_DUPS
#  補完時にヒストリを自動的に展開する
setopt HIST_EXPAND
#  改行コードで終らない出力もちゃんと出力する
setopt NO_PROMPTCR
#  loop の短縮形を許す
setopt SHORT_LOOPS
#  コマンドラインがどのように展開され実行されたかを表示する
unsetopt XTRACE
#  ディレクトリの最後のスラッシュを自動で削除
unsetopt AUTOREMOVESLASH
#  シンボリックリンクは実体を追うようになる
unsetopt CHASE_LINKS
#  $0 にスクリプト名/シェル関数名を格納
setopt FUNCTION_ARGZERO
#  Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
setopt NO_FLOW_CONTROL
#  コマンドラインでも # 以降をコメントと見なす
setopt INTERACTIVE_COMMENTS
#  デフォルトの複数行コマンドライン編集ではなく、１行編集モードになる
unsetopt SINGLE_LINE_ZLE
#  語の途中でもカーソル位置で補完
setopt COMPLETE_IN_WORD

#  C-Uで行頭まで削除
bindkey "^U" backward-kill-line

#  TABで展開を抑止
bindkey "^I" complete-word

#  補完候補のメニュー選択で、矢印キーの代わりにhjklで移動出来るようにする。
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

REPORTTIME=3

#  補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{cyan}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{cyan} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{cyan}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{cyan}Completing %B%d%b%f'$DEFAULT

#  マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

#################################################
#
#  PLUGIN Setting

# Setting direnv
# Reference site: https://qiita.com/kompiro/items/5fc46089247a56243a62
eval "$(direnv hook zsh)"

# for asdf setting
#. /opt/homebrew/opt/asdf/libexec/asdf.sh
