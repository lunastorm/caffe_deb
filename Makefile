SOURCE_LINK=https://github.com/BVLC/caffe

VERSION=0.1

ROOT=tmp/caffe-$(VERSION)_amd64

DEST=usr/

all:	deb

deb:	$(ROOT)
	dpkg-deb --build $(ROOT)
	
$(ROOT): caffe/distribute debian/control
	mkdir -p $(ROOT)/$(DEST)
	mkdir -p $(ROOT)/DEBIAN
	cp -rf debian/* $(ROOT)/DEBIAN/
	sed -i -e 's/\$$VERSION/$(VERSION)/' $(ROOT)/DEBIAN/control
	cp -rf caffe/distribute/* $(ROOT)/$(DEST)
	mkdir -p $(ROOT)/$(DEST)/lib/python2.7/dist-packages
	mv $(ROOT)/$(DEST)/python/caffe $(ROOT)/$(DEST)/lib/python2.7/dist-packages
	mv $(ROOT)/$(DEST)/python $(ROOT)/$(DEST)/caffe-python

caffe/distribute: caffe
	cp Makefile.config caffe
	./build_env.sh
	sed -i -e 's/\/usr\/bin\/g++$$/\/usr\/bin\/g++-4.6/' caffe/Makefile
	cd caffe ; make -j$(shell nproc) all && make -j$(shell nproc) pycaffe && make distribute

caffe:
	git clone $(SOURCE_LINK)

.PHONY:
clean-caffe:
	rm -rf caffe

.PHONY:
clean-deb:
	rm -rf tmp
.PHONY:
clean: clean-caffe clean-deb

