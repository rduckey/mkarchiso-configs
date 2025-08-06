ISO ?= recovery-live

build:
	./tools/build.sh $(ISO)

test:
	./tools/test_iso.sh out/$(ISO).iso

update-templates:
	./tools/update-templates.sh
