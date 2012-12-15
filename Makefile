SWFFILE = main.swf

all: swf

swf:
	mc_fcsh Preloader.as -static-link-runtime-shared-libraries -default-frame-rate 60 -frames.frame mainframe Main
	mv Preloader.swf ${SWFFILE}

debug:
	mc_fcsh Preloader.as -debug=true -static-link-runtime-shared-libraries -default-frame-rate 60 -frames.frame mainframe Main
	mv Preloader.swf debug_${SWFFILE}
