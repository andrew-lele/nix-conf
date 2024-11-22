{
  user,
  config,
  pkgs,
  ...
}:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome = "${config.users.users.${user}.home}/.local/state";
in
{

  # make a base k8s config, but since many programs write to this
  # init the base as a separate nix store'd file then copy to .kube/config
  "${config.users.users.${user}.home}/.kube/nix.config".source = ./files/kubeconf;
  "${config.users.users.${user}.home}/.gitconfig" = {
    text = ''
      [user]
      	name = Andrew Le
      	email = andle@paloaltonetworks.com
      	username = andle
      [init]
      	defaultBranch = main
      [core]
      	editor = nvim
      	pager = delta
      [diff]
        external = difft
        tool = difftastic
      [difftool "difftastic"]
        # See `man git-difftool` for a description of MERGED, LOCAL and REMOTE.
        cmd = difft "$MERGED" "$LOCAL" "abcdef1" "100644" "$REMOTE" "abcdef2" "100644"
      [difftool]
        # Run the difftool immediately, don't ask 'are you sure' each time.
        prompt = false
      [pager]
        # Use a pager if the difftool output is larger than one screenful,
        # consistent with the behaviour of `git diff`.
        difftool = true
      [gitlab]
      	user = andle
      	token = token
      [sequence]
      	editor = interactive-rebase-tool
      [alias]
      	a = add --all
      	ai = add -i
      	#############
      	ap = apply
      	as = apply --stat
      	ac = apply --check
      	#############
      	ama = am --abort
      	amr = am --resolved
      	ams = am --skip
      	#############
      	b = branch
      	ba = branch -a
      	bd = branch -d
      	bdd = branch -D
      	br = branch -r
      	bc = rev-parse --abbrev-ref HEAD
      	bu = !git rev-parse --abbrev-ref --symbolic-full-name "@{u}"
      	bs = !git-branch-status
      	#############
      	c = commit
      	ca = commit -a
      	cm = commit -m
      	cam = commit -am
      	cem = commit --allow-empty -m
      	cd = commit --amend
      	cad = commit -a --amend
      	ced = commit --allow-empty --amend
      	#############
      	cl = clone
      	cld = clone --depth 1
      	clg = !sh -c 'git clone https://github.com/$1 $(basename $1)' -
      	clgp = !sh -c 'git clone git@github.com:$1 $(basename $1)' -
      	clgu = !sh -c 'git clone git@github.com:$(git config --get user.username)/$1 $1' -
      	#############
      	cp = cherry-pick
      	cpa = cherry-pick --abort
      	cpc = cherry-pick --continue
      	#############
      	d = diff
      	dp = diff --patience
      	dc = diff --cached
      	dk = diff --check
      	dck = diff --cached --check
      	dt = difftool
      	dct = difftool --cached
      	#############
      	f = fetch
      	fo = fetch origin
      	fu = fetch upstream
      	#############
      	fp = format-patch
      	#############
      	fk = fsck
      	#############
      	g = grep -p
      	#############
      	l = log --oneline
      	lg = log --oneline --graph --decorate
      	#############
      	ls = ls-files
      	lsf = !git ls-files | grep -i
      	#############
      	m = merge
      	ma = merge --abort
      	mc = merge --continue
      	ms = merge --skip
      	#############
      	o = checkout
      	om = checkout main
      	ob = checkout -b
      	#############
      	pr = prune -v
      	#############
      	ps = push
      	psf = push -f
      	psu = push -u
      	pst = push --tags
      	#############
      	pso = push origin
      	psao = push --all origin --force-with-lease
      	psfo = push -f origin --force-with-lease
      	psuo = push -u origin
      	#############
      	psom = push origin main --force-with-lease
      	psaom = push --all origin main
      	psfom = push -f origin main
      	psuom = push -u origin main
      	psoc = !git push origin $(git bc)
      	psaoc = !git push --all origin $(git bc)
      	psfoc = !git push -f origin $(git bc)
      	psuoc = !git push -u origin $(git bc)
      	psdc = !git push origin :$(git bc)
      	#############
      	pl = pull
      	pb = pull --rebase
      	#############
      	plo = pull origin
      	pbo = pull --rebase origin
      	plom = pull origin master
      	ploc = !git pull origin $(git bc)
      	pbom = pull --rebase origin master
      	pboc = !git pull --rebase origin $(git bc)
      	#############
      	plu = pull upstream
      	plum = pull upstream master
      	pluc = !git pull upstream $(git bc)
      	pbum = pull --rebase upstream master
      	pbuc = !git pull --rebase upstream $(git bc)
      	#############
      	rb = rebase
      	rba = rebase --abort
      	rbc = rebase --continue
      	rbi = rebase --interactive
      	rbs = rebase --skip
      	#############
      	re = reset
      	rh = reset HEAD
      	reh = reset --hard
      	rem = reset --mixed
      	res = reset --soft
      	rehh = reset --hard HEAD
      	remh = reset --mixed HEAD
      	resh = reset --soft HEAD
      	rehom = reset --hard origin/master
      	#############
      	r = remote
      	ra = remote add
      	rr = remote rm
      	rv = remote -v
      	rn = remote rename
      	rp = remote prune
      	rs = remote show
      	rao = remote add origin
      	rau = remote add upstream
      	rro = remote remove origin
      	rru = remote remove upstream
      	rso = remote show origin
      	rsu = remote show upstream
      	rpo = remote prune origin
      	rpu = remote prune upstream
      	#############
      	rmf = rm -f
      	rmrf = rm -r -f
      	#############
      	s = status
      	sb = status -s -b
      	#############
      	sa = stash apply
      	sc = stash clear
      	sd = stash drop
      	sl = stash list
      	sp = stash pop
      	ss = stash save
      	ssk = stash save -k
      	sw = stash show
      	st = !git stash list | wc -l 2>/dev/null | grep -oEi '[0-9][0-9]*'
      	#############
      	t = tag
      	td = tag -d
      	#############
      	w = show
      	wp = show -p
      	wr = show -p --no-color
      	#############
      	svnr = svn rebase
      	svnd = svn dcommit
      	svnl = svn log --oneline --show-commit
      	#############
      	subadd = !sh -c 'git submodule add https://github.com/$1 $2/$(basename $1)' -
      	subrm = !sh -c 'git submodule deinit -f -- $1 && rm -rf .git/modules/$1 && git rm -f $1' -
      	subup = submodule update --init --recursive
      	subpull = submodule foreach 'git pull --tags -f origin master || git pull --tags -f origin main || git pull --tags -f origin development'
      	#############
      	assume = update-index --assume-unchanged
      	unassume = update-index --no-assume-unchanged
      	assumed = !git ls -v | grep ^h | cut -c 3-
      	unassumeall = !git assumed | xargs git unassume
      	assumeall = !git status -s | awk {'print $2'} | xargs git assume
      	#############
      	bump = !sh -c 'git commit -am \"Version bump v$1\" && git psuoc && git release $1' -
      	release = !sh -c 'git tag v$1 && git pst' -
      	unrelease = !sh -c 'git tag -d v$1 && git pso :v$1' -
      	merged = !sh -c 'git o master && git plom && git bd $1 && git rpo' -
      	aliases = !git config -l | grep alias | cut -c 7-
      	snap = !git stash save 'snapshot: $(date)' && git stash apply 'stash@{0}'
      	bare = !sh -c 'git symbolic-ref HEAD refs/heads/$1 && git rm --cached -r . && git clean -xfd' -
      	whois = !sh -c 'git log -i -1 --author=\"$1\" --pretty=\"format:%an <%ae>\"' -
      	serve = daemon --reuseaddr --verbose --base-path=. --export-all ./.git
      	#############
      	behind = !git rev-list --left-only --count $(git bu)...HEAD
      	ahead = !git rev-list --right-only --count $(git bu)...HEAD
      	#############
      	ours = "!f() { git checkout --ours $@ && git add $@; }; f"
      	theirs = "!f() { git checkout --theirs $@ && git add $@; }; f"
      	subrepo = !sh -c 'git filter-branch --prune-empty --subdirectory-filter $1 master' -
      	human = name-rev --name-only --refs=refs/heads/*
      [filter "lfs"]
      	clean = git-lfs clean -- %f
      	smudge = git-lfs smudge -- %f
      	process = git-lfs filter-process
      	required = true
      [push]
        autoSetupRemote = true
    '';
  };
}
