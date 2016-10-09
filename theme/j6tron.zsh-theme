# `j6tron` ZSH Theme
#
# Three colorful prompt lines
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, blue, magenta, cyan, and white.
#
# Based on Yad Smood (ys) theme
#
# Mar 2013 Yad Smood
# May 2016 Jonathan Virga

# Time of a long process
TIMEFMT="${fg[magenta]}time of \`%J\` / user: %U / system: %S / cpu: %P / total: %*E${reset_color}"

# Current date and time (with binary clock)
now_info='$(now)'
now() {

python <<PY
#!/usr/bin/env python3.5
# coding: utf-8

import sys
import datetime


def binary_clock(t):
    """Binary clock.

    :param t: time (datetime.datetime object)
    :return: str
    """
    symbs = {'0': '-', '1': 'x'}
    h = format(int(bin(t.hour)[2:]), '05').replace('0', symbs['0']).replace('1', symbs['1'])
    m = format(int(bin(t.minute)[2:]), '06').replace('0', symbs['0']).replace('1', symbs['1'])
    s = format(int(bin(t.second)[2:]), '06').replace('0', symbs['0']).replace('1', symbs['1'])
    return '{h}|{m}|{s}'.format(**locals())


now = datetime.datetime.now()
sys.stdout.write(now.strftime('%d/%m/%Y (%j) %H:%M:%S') + ' {' + binary_clock(now) + '}')

PY
}

# VCS
J6_VCS_PROMPT_PREFIX1="%{$fg[white]%}|%{$reset_color%} "
J6_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
J6_VCS_PROMPT_SUFFIX="%{$reset_color%}"
J6_VCS_PROMPT_DIRTY=" %{$fg[red]%}⚫ "
J6_VCS_PROMPT_CLEAN=" %{$fg[green]%}⚫ "

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${J6_VCS_PROMPT_PREFIX1}git${J6_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$J6_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$J6_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$J6_VCS_PROMPT_CLEAN"

# HG info
local hg_info='$(j6_hg_prompt_info)'
j6_hg_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.hg' ]; then
		echo -n "${J6_VCS_PROMPT_PREFIX1}hg${J6_VCS_PROMPT_PREFIX2}"
		echo -n $(hg branch 2>/dev/null)
		if [ -n "$(hg status 2>/dev/null)" ]; then
			echo -n "$J6_VCS_PROMPT_DIRTY"
		else
			echo -n "$J6_VCS_PROMPT_CLEAN"
		fi
		echo -n "$J6_VCS_PROMPT_SUFFIX"
	fi
}

# Virtualenv (use the 'virtualenv' plugin)
local venv_info='$(venv_prompt_info)'
venv_prompt_info() {
	if [ ! "${VIRTUAL_ENV}" = "" ]; then
		venv_name=$( basename ${VIRTUAL_ENV} )
		echo -n "%{$reset_color%}| py:%{$fg[cyan]%}${venv_name}%{$reset_color%} "
	fi
}

local exit_code="%(?,,%{$fg[red]%}[exit code %?]%{$reset_color%})"

# Prefix (FG[208]: orange)
prefix1="%{$FG[208]%}|%{$reset_color%} "
prefix2="%{$FG[208]%}|%{$reset_color%} "
prefix3="%{$FG[208]%}|%{$reset_color%} "

# Prompt on 3 lines
PROMPT="
$prefix1\
%{$fg[magenta]%}${now_info}%{$reset_color%}  $exit_code
$prefix2\
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$fg[white]%}@ \
%{$fg[green]%}%m \
${hg_info}\
${venv_info}\
${git_info}
$prefix3\
%{$fg[yellow]%}%~%{$reset_color%} \
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
