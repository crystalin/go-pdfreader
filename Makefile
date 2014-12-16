include $(GOROOT)/src/Make.$(GOARCH)

# uncomment next line if you do not like autoimport
#AUTO = #

FMT = gofmt -spaces -tabwidth=2 -tabindent=false
ALLGO = graf.go cmapi.go type1.go stacks.go
GOFILES = $(wildcard *.go) $(ALLGO)
ALLTS = $(GOFILES:.go=.ts)
ALL = $(ALLGO) $(ALLTS) pdtosvg pdstream tt1 pdserve
PIGGY = *.$O DEADJOE

all: $(ALL)

%: %.$O
	$(LD) -o $* $*.$O

%.$O: %.go %.ts
	$(GC) -I. $*.go

%.go: %.in
	perl $*.in >$*.go

%.ts: %.go
	@make -s $(ALLGO)
	$(AUTO) ./autoimport $*.go | $(FMT) > $*.new
	$(AUTO) mv $*.go $*.go~~ && mv $*.new $*.go
	touch $*.ts

depend: $(ALLGO) $(ALLTS)
	./mkdepend *.go <Makefile >mkf.new && \
	mv -f Makefile Makefile~ && \
	mv -f mkf.new Makefile

clean:
	-rm *~

distclean: clean
	-rm $(ALL) $(PIGGY) 2>/dev/null

# -- depends --
cmapi.$O: cmapt.$O fancy.$O ps.$O stacks.$O xchar.$O
graf.$O: fancy.$O ps.$O stacks.$O strm.$O util.$O
lzw.$O: crush.$O
pdfread.$O: fancy.$O hex.$O lzw.$O ps.$O
pdserve.$O: pdfread.$O strm.$O svg.$O
pdstream.$O: pdfread.$O util.$O
pdtosvg.$O: pdfread.$O strm.$O svg.$O
pfb.$O: hex.$O
ps.$O: fancy.$O hex.$O
svg.$O: fancy.$O pdfread.$O strm.$O svgdraw.$O svgtext.$O util.$O
svgdraw.$O: graf.$O stacks.$O strm.$O util.$O
svgtext.$O: cmapi.$O cmapt.$O fancy.$O graf.$O pdfread.$O ps.$O strm.$O util.$O
tt1.$O: fancy.$O pfb.$O type1.$O util.$O
type1.$O: fancy.$O hex.$O ps.$O stacks.$O strm.$O util.$O
util.$O: xchar.$O
